//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift
import System

public struct FileLocation: Hashable, Identifiable, URLRepresentable {
    public let url: URL
    public let bookmarkData: Data?
    
    @inlinable
    public var id: some Hashable {
        url
    }
    
    @inlinable
    public var path: FilePath {
        .init(fileURL: url)
    }
    
    @inlinable
    public init?(url: URL, bookmarkData: Data?) {
        guard url.isFileURL else {
            return nil
        }
        
        self.url = url
        self.bookmarkData = bookmarkData
    }
    
    public init?(url: URL) {
        self.init(url: url, bookmarkData: nil)
    }
    
    @inlinable
    public init(_unsafe url: URL) {
        self.url = url
        self.bookmarkData = nil
    }
}

extension FileLocation {
    public func discardingBookmarkData() -> FileLocation {
        FileLocation(url: url, bookmarkData: nil)!
    }
}

extension FileLocation {
    public static func == (lhs: Self, rhs: URL) -> Bool {
        lhs.url == rhs
    }
    
    public static func != (lhs: Self, rhs: URL) -> Bool {
        lhs.url != rhs
    }
    
    public static func == (lhs: URL, rhs: Self) -> Bool {
        lhs == rhs.url
    }
    
    public static func != (lhs: URL, rhs: Self) -> Bool {
        lhs != rhs.url
    }
}
