//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public struct FileReference: FileLocationResolvable {
    private var rawValue: NSURL // `NSURL` because `URL` cannot store file references.

    public init(url: URL) throws {
        rawValue = try ((url as NSURL).perform(#selector(NSURL.fileReferenceURL))?.takeUnretainedValue() as? NSURL).unwrapOrThrow(FilesystemError.fileNotFound(url))
    }

    public func resolveFileLocation() throws -> FileLocation {
        return .init(_unsafe: rawValue as URL)
    }
}

// MARK: - Protocol Implementations -

extension FileReference: CustomStringConvertible {
    public var description: String {
        return rawValue.description
    }
}
