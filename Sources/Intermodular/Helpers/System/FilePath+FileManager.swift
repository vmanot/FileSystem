//
// Copyright (c) Vatsal Manot
//

import Darwin
import Foundation
import Swallow
import System

extension FilePath {
    public var stringValue: String {
        withCString(String.init(cString:))
    }
    
    public var cocoaFilePath: String {
        return standardized.stringValue
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
        return .init(directorySeparator)
    }
    
    public static var currentDirectory: FilePath {
        get {
            return .init(FileManager.default.currentDirectoryPath)
        } set {
            FileManager.default.changeCurrentDirectoryPath(newValue.stringValue)
        }
    }
}

extension FilePath {
    public var standardized: FilePath {
        return .init((stringValue as NSString).standardizingPath)
    }
    
    public var resolved: FilePath {
        return .init((stringValue as NSString).resolvingSymlinksInPath)
    }
}

extension FilePath {
    public var exists: Bool {
        return FileManager.default.fileExists(atPath: stringValue)
    }
    
    public var fileName: String {
        get {
            url.lastPathComponent
        } set {
            self = .init((stringValue as NSString).deletingLastPathComponent + newValue)
        }
    }
    
    public var pathExtension: String {
        get {
            return (stringValue as NSString).pathExtension
        } set {
            self = .init((stringValue as NSString).deletingPathExtension + ".\(newValue)")
        }
    }
}

// MARK: - Protocol Implementations -

extension FilePath: URLRepresentable {
    public var url: URL {
        return URL(fileURLWithPath: cocoaFilePath)
    }
    
    public init?(url: URL) {
        guard url.isFileURL else {
            return nil
        }
        
        self.init(url.path)
    }
    
    public init(fileURL url: URL) {
        self.init(url: url)!
    }
}

// MARK: - Auxiliary Extensions -

extension FilePath {
    public static func paths(inDomains directory: FileManager.SearchPathDirectory, mask: FileManager.SearchPathDomainMask) -> [FilePath] {
        return NSSearchPathForDirectoriesInDomains(directory, mask, true).map({ FilePath($0) })
    }
    
    public static func path(inUserDomain directory: FileManager.SearchPathDirectory) -> FilePath {
        return paths(inDomains: directory, mask: .userDomainMask).first!
    }
    
    public static func path(inSystemDomain directory: FileManager.SearchPathDirectory) -> FilePath {
        return paths(inDomains: directory, mask: .systemDomainMask).first!
    }
}
