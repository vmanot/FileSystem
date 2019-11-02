//
// Copyright (c) Vatsal Manot
//

import Foundation
import POSIX
import Swallow
import Swift

public struct FilesystemItemPermissions: Wrapper {
    public typealias Value = POSIXFilePermissions
    
    public let value: Value

    public init(_ value: Value) {
        self.value = value
    }
}

extension FilesystemItemPermissions {
    public init?(_ attributes: FileAttributes) {
        self.init(nilIfNil: attributes.posixFilePermissions)
    }
}

// MARK: - Helpers -

extension FilePath {
    public func resolveFilePermissions() throws -> FilesystemItemPermissions? {
        return FilesystemItemPermissions(try resolveFileAttributes())
    }
}
