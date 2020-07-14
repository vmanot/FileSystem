//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift
import System

public struct FileLocation: Hashable, Identifiable, URLRepresentable {
    public let url: URL
    
    public var id: some Hashable {
        url
    }

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
