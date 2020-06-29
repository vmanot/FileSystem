//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift
import UniformTypeIdentifiers

extension URL {
    public subscript(keys: Set<URLResourceKey>) -> Result<URLResourceValues, Error> {
        .init(try resourceValues(forKeys: keys))
    }
    
    public subscript(key: URLResourceKey) -> Result<URLResourceValues, Error> {
        self[[key]]
    }
    
    public func toUTI() throws -> UTType? {
        try self[.typeIdentifierKey]
            .unwrap()
            .typeIdentifier.flatMap({ UTType($0) })
    }
}
