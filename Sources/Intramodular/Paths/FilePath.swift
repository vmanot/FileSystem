//
// Copyright (c) Vatsal Manot
//

import Darwin
import Foundation
import Swallow
import Swift

public struct FilePath {
    public var stringValue: String
    
    public var cocoaFilePath: String {
        return standardized.stringValue
    }
    
    public init(stringValue: String) {
        self.stringValue = stringValue
    }
}

extension FilePath: FilePathRepresentable {
    public var path: FilePath {
        return self
    }
    
    public init(path: FilePath) {
        self = path
    }
}


// MARK: - Auxiliary Implementation -

extension FilePath {
    public var isAbsolute: Bool {
        return stringValue.hasPrefix(FilePath.directorySeparator)
    }
    
    public var isLiteralHardlinkToCurrent: Bool {
        return stringValue == "."
    }
    
    public var isLiteralHardlinkToParent: Bool {
        return stringValue == ".."
    }
    
    public var isEmptyOrLiteralHardlinkToCurrent: Bool {
        return stringValue.isEmpty || isLiteralHardlinkToCurrent
    }
}

// MARK: - Implementation -

extension FilePath {
    public static var directorySeparator: String {
        return "/"
    }
    
    public static var root: FilePath {
        return .init(stringValue: directorySeparator)
    }
    
    public static var currentDirectory: FilePath {
        get {
            return .init(stringValue: FileManager.default.currentDirectoryPath)
        } set {
            FileManager.default.changeCurrentDirectoryPath(newValue.stringValue)
        }
    }
}

extension FilePath {
    public var parentDirectory: FilePath {
        if isAbsolute {
            return .init(stringValue: (absolute.stringValue as NSString).deletingLastPathComponent)
        } else {
            return appendingComponent(.init(stringValue: ".."))
        }
    }
    
    public var standardized: FilePath {
        return .init(stringValue: (stringValue as NSString).standardizingPath)
    }
    
    public var absolute: FilePath {
        return isAbsolute ? standardized : FilePath.currentDirectory.appendingComponent(self).absolute
    }
    
    public var resolved: FilePath {
        return .init(stringValue: (stringValue as NSString).resolvingSymlinksInPath)
    }
}

extension FilePath {
    public var components: [FilePath] {
        guard stringValue != "" && stringValue != "." else {
            return []
        }
        
        if isAbsolute {
            return (absolute.stringValue as NSString).pathComponents.filter({ $0 != "." && $0 != "/" }).map({ .init(stringValue: $0) }).inserting(.root)
        } else {
            func clean(_ components: [FilePath]) -> [FilePath] {
                var isStillDirty = false
                
                let result: [FilePath] = components.enumerated().compactMap {
                    if $0 < components.lastIndex {
                        if components[$0 + 1].isLiteralHardlinkToParent && !$1.isLiteralHardlinkToParent {
                            isStillDirty = true
                            
                            return nil
                        }
                    }
                        
                    else if $0 > components.startIndex {
                        if !components[$0 - 1].isLiteralHardlinkToParent && $1.isLiteralHardlinkToParent {
                            isStillDirty = true
                            
                            return nil
                        }
                    }
                    
                    return $1
                }
                
                return isStillDirty ? clean(result) : result
            }
            
            return clean(Array((stringValue as NSString).pathComponents.filter({ $0 != "." && $0 != "/" }).map({ .init(stringValue: $0) })))
        }
    }
    
    public init<S: Collection>(rawComponents components: S) where S.Element == String {
        if components.isEmpty {
            self.init(stringValue: ".")
        } else if components.first == FilePath.directorySeparator && components.count > 1 {
            unmigrated() // self.init(stringValue: components.joined(separator: FilePath.directorySeparator).dropFirst())
        } else {
            self.init(stringValue: components.joined(separator: FilePath.directorySeparator))
        }
    }
    
    public func appendingRawComponent(_ component: String) -> FilePath {
        return FilePath(url: url.appendingPathComponent(component)).forceUnwrap()
    }
    
    public func appendingComponent(_ component: FilePath) -> FilePath {
        return appendingRawComponent(component.stringValue)
    }
    
    public func appending(_ other: FilePath) -> FilePath {
        guard !other.isAbsolute else {
            fatalError("What in the fuck's name are you doing?")
        }
        
        guard !isEmptyOrLiteralHardlinkToCurrent else {
            return other
        }
        
        guard !other.isEmptyOrLiteralHardlinkToCurrent else {
            return self
        }
        
        return .init(stringValue: "\(stringValue.dropSuffixIfPresent(FilePath.directorySeparator))\(FilePath.directorySeparator)\(other.stringValue)")
    }
    
    public func replacingLastComponent(with component: FilePath) -> FilePath {
        var components = url.pathComponents
        
        components.removeLast()
        components.append(component.stringValue)
        
        return FilePath(url: NSURL.fileURL(withPathComponents: components)! as URL)!
    }
}

extension FilePath {
    public static func + (lhs: FilePath, rhs: FilePath) -> FilePath {
        return lhs.appending(rhs)
    }
}

extension FilePath {
    public var exists: Bool {
        return FileManager.default.fileExists(atPath: stringValue)
    }
    
    public var fileName: String {
        get {
            return absolute.components.last?.stringValue ?? ""
        } set {
            self = .init(stringValue: (stringValue as NSString).deletingLastPathComponent + newValue)
        }
    }
    
    public var pathExtension: String {
        get {
            return (stringValue as NSString).pathExtension
        } set {
            self = .init(stringValue: (stringValue as NSString).deletingPathExtension + ".\(newValue)")
        }
    }
}

// MARK: - Protocol Implementations -

extension FilePath: CustomStringConvertible {
    public var description: String {
        return describe(stringValue)
    }
}

extension FilePath: Equatable {
    public static func == (lhs: FilePath, rhs: FilePath) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}

extension FilePath: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}

extension FilePath: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stringValue)
    }
}

extension FilePath: URLRepresentable {
    public var url: URL {
        return URL(fileURLWithPath: cocoaFilePath)
    }
    
    public init?(url: URL) {
        guard url.isFileURL else {
            return nil
        }
        
        self.init(stringValue: url.path)
    }
    
    public init(fileURL url: URL) {
        self.init(url: url)!
    }
}

// MARK: - Auxiliary Extensions -

extension FilePath {
    public static var userDocumentDirectory: FilePath {
        return path(inUserDomain: .documentDirectory)
    }
}
