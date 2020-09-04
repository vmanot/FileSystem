//
// Copyright (c) Vatsal Manot
//

import Foundation
import Merge
import POSIX
import Runtime
import Swift

public class TextFile<AccessMode: FileAccessModeType, Encoding: StringEncodingType>: RegularFile<String, AccessMode> {

}

extension TextFile where AccessMode: FileAccessModeTypeForReading {
    public func data() throws -> String {
        return try data(using: .init(encoding: Encoding.encodingTypeValue))
    }
}

extension TextFile where AccessMode: FileAccessModeTypeForWriting {
    public func write(_ data: String) throws {
        try write(data, using: .init(encoding: Encoding.encodingTypeValue, allowLossyConversion: false))
    }
}

extension TextFile where AccessMode: FileAccessModeTypeForUpdating {
    public var unsafelyCodedData: String {
        get {
            return try! data()
        } set {
            try! write(newValue)
        }
    }
}
