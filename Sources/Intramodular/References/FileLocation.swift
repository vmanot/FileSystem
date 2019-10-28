//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public struct FileLocation: URLRepresentable {
    public let url: URL
    
    public init?(url: URL) {
        guard url.isFileURL else {
            return nil
        }
        
        self.url = url
    }
    
    public init(unvalidated url: URL) {
        self.url = url
    }
    
    @inlinable
    public var path: String {
        return url.path
    }
}

extension FileLocation {
    public func cocoaFileURL() throws -> URL {
        return url
    }
    
    public func cocoaFilePath() throws -> String {
        return try cocoaFileURL().path
    }
}
