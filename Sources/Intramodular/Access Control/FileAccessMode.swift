//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public enum FileAccessMode: Hashable {
    case read
    case write
    case update
}

public protocol FileAccessModeType: StaticValue {
    static var value: FileAccessMode { get }
}

public protocol FileAccessModeTypeForWriting: FileAccessModeType {
    static var value: FileAccessMode { get }
}

public protocol FileAccessModeTypeForReading: FileAccessModeType {
    static var value: FileAccessMode { get }
}

public typealias FileAccessModeTypeForUpdating = FileAccessModeTypeForReading & FileAccessModeTypeForWriting

public struct ReadAccess: FileAccessModeTypeForReading {
    public static let value: FileAccessMode = .read
}

public struct WriteAccess: FileAccessModeTypeForWriting {
    public static let value: FileAccessMode = .write
}

public struct UpdateAccess: FileAccessModeTypeForUpdating {
    public static let value: FileAccessMode = .update
}

extension FileHandle {
    public convenience init(forURL url: URL, accessMode mode: FileAccessMode) throws {
        switch mode {
            case .read:
                try self.init(forReadingFrom: url)
            case .write:
                try self.init(forWritingTo: url)
            case .update:
                try self.init(forUpdating: url)
        }
    }
}
