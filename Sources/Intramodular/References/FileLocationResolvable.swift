//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public protocol FileLocationResolvable {
    func resolveFileLocation() throws -> FileLocation
}

// MARK: - Implementation -

extension FileLocationResolvable where Self: URLRepresentable {
    public func resolveFileLocation() throws -> FileLocation {
        let url = self.url
        
        guard url.isFileURL else {
            throw FilesystemError.isNotFileURL(url)
        }
        
        return .init(unvalidated: url.standardizedFileURL)
    }
}

// MARK: - Extensions -

extension FileLocationResolvable {
    public func resolveFilePath() throws -> FilePath {
        return .init(fileURL: try resolveFileURL())
    }

    public func resolveFileURL() throws -> URL {
        return try resolveFileLocation().url
    }
}

// MARK: - Concrete Implementations -

extension FileLocation: FileLocationResolvable {
    
}

extension FilePath: FileLocationResolvable {
    
}


extension String: FileLocationResolvable {
    public func resolveFileLocation() throws -> FileLocation {
        return try FilePath(stringValue: self).resolveFileLocation()
    }
}

extension URL: FileLocationResolvable {
    
}
