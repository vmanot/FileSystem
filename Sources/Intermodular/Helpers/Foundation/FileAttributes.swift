//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import System

public struct FileAttributes: Collection2, ImplementationForwardingMutableWrapper, Initiable, MutableDictionaryProtocol {
    public typealias DictionaryKey = Value.DictionaryKey
    public typealias DictionaryValue = Value.DictionaryValue
    public typealias Element = Value.Element
    public typealias Index = Value.Index
    public typealias Iterator = Value.Iterator
    public typealias SubSequence = Value.SubSequence
    public typealias Value = [FileAttributeKey: Any]

    public var value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
}

extension FileAttributes {
    public subscript(_ key: FileAttributeKey) -> Any? {
        get {
            return value[key]
        } set {
            value[key] = newValue
        }
    }
}

// MARK: - Extensions - 

extension FileAttributes {
    public var fileSize: UInt64? {
        return -?>self[.size]
    }

    public var dateModified: Date? {
        return -?>self[.modificationDate]
    }
    
    public var fileReferenceCount: UInt? {
        return -?>self[.referenceCount]
    }

    public var ownerAccountName: String? {
        return -?>self[.ownerAccountName]
    }
    
    public var groupOwnerAccountName: String? {
        return -?>self[.groupOwnerAccountName]
    }

    public var posixFilePermissions: FilePermissions? {
        get {
            return self[.posixPermissions].castMap({ .init(rawValue: $0) })
        } set {
            self[.posixPermissions] = newValue?.rawValue
        }
    }

    public var systemFileNumber: UInt? {
        return -?>self[.systemFileNumber]
    }

    public var extensionIsHidden: Bool? {
        return -?>self[.extensionHidden]
    }

    public var dateCreated: Date? {
        return -?>self[.creationDate]
    }
    
    public var ownerAccountID: UInt? {
        return -?>self[.ownerAccountID]
    }
    
    public var groupOwnerAccountID: UInt? {
        return -?>self[.groupOwnerAccountID]
    }
}

// MARK: - Helpers -

extension FilesystemItem {
    public func attributes() throws -> FileAttributes {
        return .init(try FileManager.default.attributesOfItem(atPath: resolveFilePath().stringValue))
    }

    public func setAttributes(_ attributes: FileAttributes) throws {
        return try FileManager.default.setAttributes(attributes.value, ofItemAtPath: resolveFilePath().stringValue)
    }
}

extension FilePath {
    public func resolveFileAttributes() throws -> FileAttributes {
        return FileAttributes(try FileManager.default.attributesOfItem(atPath: stringValue))
    }
    
    public func resolveFilePermissions() throws -> FilePermissions? {
        try resolveFileAttributes().posixFilePermissions
    }
}
