//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public struct DispatchFileSystemEvents: RawRepresentable2 {
    public typealias RawValue = UInt
    
    public let rawValue: RawValue

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

// MARK: - Protocol Implementations -

extension DispatchFileSystemEvents: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension DispatchFileSystemEvents: CustomStringConvertibleOptionSet {
    public static let delete = with(rawValue: DispatchSource.FileSystemEvent.delete.rawValue)
    public static let write = with(rawValue: DispatchSource.FileSystemEvent.write.rawValue)
    public static let extend = with(rawValue: DispatchSource.FileSystemEvent.extend.rawValue)
    public static let attribute = with(rawValue: DispatchSource.FileSystemEvent.attrib.rawValue)
    public static let link = with(rawValue: DispatchSource.FileSystemEvent.link.rawValue)
    public static let rename = with(rawValue: DispatchSource.FileSystemEvent.rename.rawValue)
    public static let revoke = with(rawValue: DispatchSource.FileSystemEvent.revoke.rawValue)
    public static let create = with(rawValue: 0x1000)
    
    public static let all: DispatchFileSystemEvents = [.delete, .write, .extend, .attribute, .link, .rename, .revoke, .create]

    public static let descriptions: [DispatchFileSystemEvents: String] = [.delete: "delete", .write: "write", .extend: "extend", .attribute: "attribute", .link: "link", .rename : "rename", .revoke: "revoke", .create: "create"]
}
