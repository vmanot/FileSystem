//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public protocol CocoaURLReadable {
    static func cocoaRead(from _: URL) throws -> Self
}

public protocol CocoaURLWritable {
    func cocoaWrite(to _: URL, atomically: Bool) throws
}

public typealias CocoaURLReadableWritable = CocoaURLReadable & CocoaURLWritable

// MARK: - Concrete Implementations -

extension Array: CocoaURLReadable, CocoaURLWritable where Element == AnyObject {
    public static func cocoaRead(from url: URL) throws -> Array {
        return try NSArray.cocoaRead(from: url) as [AnyObject]
    }
    
    public func cocoaWrite(to url: URL, atomically: Bool) throws {
        try (self as NSArray).cocoaWrite(to: url, atomically: atomically)
    }
}

extension Data: CocoaURLReadable, CocoaURLWritable {
    public static func cocoaRead(from url: URL) throws -> Data {
        return try .init(contentsOf: url)
    }
    
    public func cocoaWrite(to url: URL, atomically: Bool) throws {
        try write(to: url, options: .atomic)
    }
}

extension Dictionary: CocoaURLReadable, CocoaURLWritable where Key == NSObject, Value == AnyObject {
    public static func cocoaRead(from url: URL) throws -> Dictionary {
        return try NSDictionary.cocoaRead(from: url) as Dictionary
    }
    
    public func cocoaWrite(to url: URL, atomically: Bool) throws {
        try (self as NSDictionary).cocoaWrite(to: url, atomically: atomically)
    }
}

extension NSArray: CocoaURLReadable, CocoaURLWritable {
    public static func cocoaRead(from url: URL) throws -> Self {
        return try self.init(contentsOf: url).unwrap()
    }
    
    public func cocoaWrite(to url: URL, atomically: Bool) throws {
        try write(to: url, atomically: atomically).orThrow(CocoaError.error(.fileWriteUnknown, url: url))
    }
}

extension NSDictionary: CocoaURLReadable, CocoaURLWritable {
    public static func cocoaRead(from url: URL) throws -> Self {
        return try self.init(contentsOf: url).unwrap()
    }
    
    public func cocoaWrite(to url: URL, atomically: Bool) throws {
        try write(to: url, atomically: atomically).orThrow(CocoaError.error(.fileWriteUnknown, url: url))
    }
}

extension NSString: CocoaURLReadable, CocoaURLWritable {
    public static func cocoaRead(from url: URL) throws -> Self {
        return try self.init(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
    }
    
    public func cocoaWrite(to url: URL, atomically: Bool) throws {
        try write(to: url, atomically: atomically, encoding: String.Encoding.utf8.rawValue)
    }
}

extension String: CocoaURLReadable, CocoaURLWritable {
    public static func cocoaRead(from url: URL) throws -> String {
        return try NSString.cocoaRead(from: url) as String
    }
    
    public func cocoaWrite(to url: URL, atomically: Bool) throws {
        try (self as NSString).cocoaWrite(to: url, atomically: atomically)
    }
}
