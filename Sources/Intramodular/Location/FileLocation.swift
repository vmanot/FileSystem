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
        self.init(url: url, bookmarkData: try? url.bookmarkData())
    }
    
    @inlinable
    public init(_unsafe url: URL) {
        self.url = url
        self.bookmarkData = nil
    }
}

// MARK: - Protocol Conformances -

extension FileLocation: Codable {
    public enum CodingKeys: String, CodingKey {
        case url
        case bookmarkData
    }
    
    public func encode(to encoder: Encoder) throws {
        if let bookmarkData = bookmarkData {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(url, forKey: .url)
            try container.encode(bookmarkData, forKey: .bookmarkData)
        } else {
            var container = encoder.singleValueContainer()
            
            try container.encode(rawValue)
        }
    }
    
    public init(from decoder: Decoder) throws {
        do {
            self = try Self(rawValue: try decoder.decode(single: String.self)).unwrap()
        } catch {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            url = try container.decode(URL.self, forKey: .url)
            bookmarkData = try container.decodeIfPresent(Data.self, forKey: .bookmarkData)
        }
    }
}

extension FileLocation: RawRepresentable  {
    public var rawValue: String {
        url.path
    }
    
    public init?(rawValue: String) {
        guard let url = URL(FilePath(rawValue)) else {
            return nil
        }
        
        self.init(_unsafe: url)
    }
}

// MARK: - Helpers -

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

extension FileLocation {
    public var hasChildren: Bool {
        do {
            return try !FileManager.default
                .suburls(at: url)
                .map(FileLocation.init(_unsafe:))
                .filter({ $0.path.exists })
                .isEmpty
        } catch {
            return false
        }
    }
    
    public var isEmpty: Bool {
        let result = try? FileManager.default
            .suburls(at: url)
            .map(FileLocation.init(_unsafe:))
            .filter({ $0.path.exists })
        
        return result?.isEmpty ?? false
    }
}

extension Sequence where Element: FileLocationResolvable {
    public var isReachable: Bool {
        !contains(where: { !$0.isReachable })
    }
}
