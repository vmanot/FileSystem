//
// Copyright (c) Vatsal Manot
//

import Data
import Foundation
import POSIX
import Swift

public class RegularFile<DataType, AccessMode: FileAccessModeType>: InputOutputResource {
    public var location: FileLocationResolvable {
        return reference
    }
    
    var reference: FileReference
    var handle: FileHandle
    
    public required init(at location: FileLocationResolvable) throws {
        let url = try location.resolveFileLocation().url
        
        self.reference = try .init(url: url)
        
        switch AccessMode.value {
            case .read:
                self.handle = try .init(forReadingFrom: url)
            case .write:
                self.handle = try .init(forWritingTo: url)
            case .update:
                self.handle = try .init(forUpdating: url)
        }
        
        try super.init(
            descriptor: .init(rawValue: handle.fileDescriptor),
            transferOwnership: false
        )
    }
}

// MARK: - Extensions -

extension RegularFile where AccessMode: FileAccessModeTypeForReading {
    public func getRawData() -> Data {
        return handle.seekingToStartOfFile().readDataToEndOfFile()
    }
}

extension RegularFile where AccessMode: FileAccessModeTypeForWriting {
    public func set(rawData data: Data) {
        handle.seekingToStartOfFile().write(truncatingTo: data)
    }
    
    public func flushToDisk() {
        handle.synchronizeFile()
    }
}

extension RegularFile where AccessMode: FileAccessModeTypeForUpdating {
    public var rawData: Data {
        get {
            return getRawData()
        } set {
            set(rawData: newValue)
        }
    }
}

extension RegularFile {
    public class func create<Location: FileLocationResolvable>(at location: Location) throws -> Self {
        let url = try location.resolveFileLocation()
        
        try FileManager.default.createFile(atPath: url.path.stringValue, contents: nil, attributes: nil).orThrow(CocoaError(.fileWriteUnknown))
        
        return try self.init(at: url)
    }
    
    public class func createIfNecessary<Location: FileLocationResolvable>(at location: Location) throws -> Self {
        return try FileManager.default.fileExists(atPath: location.resolveFileLocation().path.stringValue) ? .init(at: location) : create(at: location)
    }
    
    public func move(to other: FileLocation) throws {
        try FileManager.default.moveItem(at: resolveFileLocation().url, to: other.url)
    }
}

// MARK: - Protocol Implementations -

extension RegularFile: FileLocationResolvable {
    public func resolveFileLocation() throws -> FileLocation {
        return try reference.resolveFileLocation()
    }
}

// MARK: - Helpers -

extension RegularFile where AccessMode: FileAccessModeTypeForReading, DataType: DataDecodable {
    public func data(using strategy: DataType.DataDecodingStrategy) throws -> DataType {
        return try DataType.init(data: getRawData(), using: strategy)
    }
}

extension RegularFile where AccessMode: FileAccessModeTypeForReading, DataType: DataDecodableWithDefaultStrategy {
    public func data(using strategy: DataType.DataDecodingStrategy = DataType.defaultDataDecodingStrategy) throws -> DataType {
        return try DataType.init(data: getRawData(), using: strategy)
    }
}

extension RegularFile where AccessMode: FileAccessModeTypeForWriting, DataType: DataEncodable {
    public func write(_ data: DataType, using strategy: DataType.DataEncodingStrategy) throws {
        try set(rawData: data.data(using: strategy))
    }
}

extension RegularFile where AccessMode: FileAccessModeTypeForWriting, DataType: DataEncodableWithDefaultStrategy {
    public func write(_ data: DataType, using strategy: DataType.DataEncodingStrategy = DataType.defaultDataEncodingStrategy) throws {
        try set(rawData: data.data(using: strategy))
    }
}
