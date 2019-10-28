//
// Copyright (c) Vatsal Manot
//

import Darwin
import Foundation
import Swallow
import Swift

public struct Path {
    public var stringValue: String

    public var cocoaFilePath: String {
        return standardized.stringValue
    }

    public init(stringValue: String) {
        self.stringValue = stringValue
    }
}

extension Path: PathRepresentable {
    public var path: Path {
        return self
    }

    public init(path: Path) {
        self = path
    }
}


// MARK: - Auxiliary Implementation -

extension Path {
    public var isAbsolute: Bool {
        return stringValue.hasPrefix(Path.directorySeparator)
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

extension Path {
    public static var directorySeparator: String {
        return "/"
    }

    public static var root: Path {
        return .init(stringValue: directorySeparator)
    }

    public static var currentDirectory: Path {
        get {
            return .init(stringValue: FileManager.default.currentDirectoryPath)
        } set {
            FileManager.default.changeCurrentDirectoryPath(newValue.stringValue)
        }
    }
}

extension Path {
    public var parentDirectory: Path {
        if isAbsolute {
            return .init(stringValue: (absolute.stringValue as NSString).deletingLastPathComponent)
        } else {
            return appendingComponent(.init(stringValue: ".."))
        }
    }

    public var standardized: Path {
        return .init(stringValue: (stringValue as NSString).standardizingPath)
    }

    public var absolute: Path {
        return isAbsolute ? standardized : Path.currentDirectory.appendingComponent(self).absolute
    }

    public var resolved: Path {
        return .init(stringValue: (stringValue as NSString).resolvingSymlinksInPath)
    }
}

extension Path {
    public var components: [Path] {
        guard stringValue != "" && stringValue != "." else {
            return []
        }

        if isAbsolute {
            return (absolute.stringValue as NSString).pathComponents.filter({ $0 != "." && $0 != "/" }).map({ .init(stringValue: $0) }).inserting(.root)
        } else {
            func clean(_ components: [Path]) -> [Path] {
                var isStillDirty = false

                let result: [Path] = components.enumerated().compactMap {
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
        } else if components.first == Path.directorySeparator && components.count > 1 {
            unmigrated() // self.init(stringValue: components.joined(separator: Path.directorySeparator).dropFirst())
        } else {
            self.init(stringValue: components.joined(separator: Path.directorySeparator))
        }
    }

    public func appendingRawComponent(_ component: String) -> Path {
        return Path(url: url.appendingPathComponent(component)).forceUnwrap()
    }

    public func appendingComponent(_ component: Path) -> Path {
        return appendingRawComponent(component.stringValue)
    }

    public func appending(_ other: Path) -> Path {
        guard !other.isAbsolute else {
            fatalError("What in the fuck's name are you doing?")
        }

        guard !isEmptyOrLiteralHardlinkToCurrent else {
            return other
        }

        guard !other.isEmptyOrLiteralHardlinkToCurrent else {
            return self
        }

        return .init(stringValue: "\(stringValue.dropSuffixIfPresent(Path.directorySeparator))\(Path.directorySeparator)\(other.stringValue)")
    }

    public func replacingLastComponent(with component: Path) -> Path {
        var components = url.pathComponents

        components.removeLast()
        components.append(component.stringValue)

        return Path(url: NSURL.fileURL(withPathComponents: components)! as URL)!
    }
}

extension Path {
    public static func + (lhs: Path, rhs: Path) -> Path {
        return lhs.appending(rhs)
    }
}

extension Path {
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

extension Path: CustomStringConvertible {
    public var description: String {
        return describe(stringValue)
    }
}

extension Path: Equatable {
    public static func == (lhs: Path, rhs: Path) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}

extension Path: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}

extension Path: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stringValue)
    }
}

extension Path: URLRepresentable {
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

extension Path {
    public static var userDocumentDirectory: Path {
        return path(inUserDomain: .documentDirectory)
    }
}
