//
// Copyright (c) Vatsal Manot
//

import Swallow
import System

public protocol FilePathRepresentable {
    var path: FilePath { get }
    
    init?(path: FilePath)
}

// MARK: - Concrete Implementations -

extension FilePath: FilePathRepresentable {
    public var path: FilePath {
        self
    }
    
    public init(path: FilePath) {
        self = path
    }
}
