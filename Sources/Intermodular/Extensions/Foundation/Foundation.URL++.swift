//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension URL {
    public subscript(keys: Set<URLResourceKey>) -> Result<URLResourceValues, Error> {
        return .init(try resourceValues(forKeys: keys))
    }
    
    public subscript(key: URLResourceKey) -> Result<URLResourceValues, Error> {
        return self[[key]]
    }
    
    public func toUTI() throws -> UniformTypeIdentifier? {
        return try self[.typeIdentifierKey]
            .unwrap()
            .typeIdentifier.map(UniformTypeIdentifier.init)
    }
}
