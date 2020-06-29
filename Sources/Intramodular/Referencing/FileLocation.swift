//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift
import System

public struct FileLocation: Hashable, URLRepresentable {
    public let url: URL
    
    @inlinable
    public init?(url: URL) {
        guard url.isFileURL else {
            return nil
        }
        
        self.url = url
    }
    
    @inlinable
    public init(_unsafe url: URL) {
        self.url = url
    }
    
    @inlinable
    public var path: FilePath {
        .init(fileURL: url)
    }
}
