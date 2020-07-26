//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public class FileBookmark: Codable {
    public private(set) var data: Data
    
    public init(url: URL) throws {
        self.data = try url.bookmarkData(options: type(of: self).bookmarkCreationOptions(), includingResourceValuesForKeys: [], relativeTo: nil)
    }
    
    fileprivate class func bookmarkCreationOptions() -> NSURL.BookmarkCreationOptions {
        return .suitableForBookmarkFile
    }
    
    fileprivate class func renew(url: URL) throws -> Data {
        return  try url.bookmarkData(options: bookmarkCreationOptions(), includingResourceValuesForKeys: nil, relativeTo: nil)
    }
}

extension FileBookmark {
    public func resolve(renewIfNecessary: Bool) throws -> (url: URL?, wasStale: Bool) {
        var isStale = false
        
        let url = try URL(resolvingBookmarkData: data, bookmarkDataIsStale: &isStale)
        
        if isStale, renewIfNecessary {
            self.data = try type(of: self).renew(url: url)
        }
        
        return (url, isStale)
    }
}

// MARK: - Subclasses -

public final class MinimalFileBookmark: FileBookmark {
    fileprivate override class func bookmarkCreationOptions() -> NSURL.BookmarkCreationOptions {
        return .minimalBookmark
    }
}

#if os(macOS)

public class SecureFileBookmark: FileBookmark {
    public override class func bookmarkCreationOptions() -> NSURL.BookmarkCreationOptions {
        return .withSecurityScope
    }
    
    fileprivate override class func renew(url: URL) throws -> Data {
        guard url.startAccessingSecurityScopedResource() else {
            throw FilesystemError.couldNotAccessWithSecureScope(url)
        }
        
        let result = try url.bookmarkData(options: bookmarkCreationOptions(), includingResourceValuesForKeys: nil, relativeTo: nil)
        
        url.stopAccessingSecurityScopedResource()
        
        return result
    }
}

public final class ReadOnlySecureFileBookmark: SecureFileBookmark {
    public override class func bookmarkCreationOptions() -> NSURL.BookmarkCreationOptions {
        return .securityScopeAllowOnlyReadAccess
    }
}

#endif
