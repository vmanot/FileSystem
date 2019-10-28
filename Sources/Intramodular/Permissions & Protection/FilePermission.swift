//
// Copyright (c) Vatsal Manot
//

import Foundation
import POSIX
import Swallow
import Swift

public enum FilePermission {
    case none
    case executeOnly
    case writeOnly
    case executeWrite
    case readOnly
    case readExecute
    case readWrite
    case readWriteExecute
}

public protocol StaticFilePermission: Static {
    static var value: FilePermission { get }
}

// MARK: - Concrete Implementations -

public struct ExecuteOnly: StaticFilePermission {
    public static let value: FilePermission = .executeOnly
}

public struct WriteOnly: StaticFilePermission {
    public static let value: FilePermission = .writeOnly
}

public struct ExecuteWrite: StaticFilePermission {
    public static let value: FilePermission = .executeWrite
}

public struct ReadOnly: StaticFilePermission {
    public static let value: FilePermission = .readOnly
}

public struct ReadExecute: StaticFilePermission {
    public static let value: FilePermission = .readExecute
}

public struct ReadWrite: StaticFilePermission {
    public static let value: FilePermission = .readWrite
}

public struct ReadWriteExecute: StaticFilePermission {
    public static let value: FilePermission = .readWriteExecute
}

// MARK: - Helpers -

extension POSIXFilePermissionBits {
    public init(_ permission: FilePermission) {
        switch permission {
            case .none:
                self.init(rawValue: 0)
            case .executeOnly:
                self.init(rawValue: 1)
            case .writeOnly:
                self.init(rawValue: 2)
            case .executeWrite:
                self.init(rawValue: 3)
            case .readOnly:
                self.init(rawValue: 4)
            case .readExecute:
                self.init(rawValue: 5)
            case .readWrite:
                self.init(rawValue: 6)
            case .readWriteExecute:
                self.init(rawValue: 7)
        }
    }
}
