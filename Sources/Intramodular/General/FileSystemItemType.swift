//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public enum FilesystemItemType: String {
    case blockSpecial
    case characterSpecial
    case directory
    case regular
    case socket
    case symbolicLink
    case unknown
    
    public var rawValue: String {
        switch self {
            case .blockSpecial:
                return FileAttributeType.typeBlockSpecial.rawValue
            case .characterSpecial:
                return FileAttributeType.typeCharacterSpecial.rawValue
            case .directory:
                return FileAttributeType.typeDirectory.rawValue
            case .regular:
                return FileAttributeType.typeRegular.rawValue
            case .socket:
                return FileAttributeType.typeSocket.rawValue
            case .symbolicLink:
                return FileAttributeType.typeSymbolicLink.rawValue
            case .unknown:
                return FileAttributeType.typeUnknown.rawValue
        }
    }

    public init?(rawValue: String) {
        switch rawValue {
            case type(of: self).blockSpecial.rawValue:
                self = .blockSpecial
            case type(of: self).characterSpecial.rawValue:
                self = .characterSpecial
            case type(of: self).directory.rawValue:
                self = .directory
            case type(of: self).regular.rawValue:
                self = .regular
            case type(of: self).socket.rawValue:
                self = .socket
            case type(of: self).symbolicLink.rawValue:
                self = .symbolicLink
            case type(of: self).unknown.rawValue:
                self = .unknown
            
            default:
                return nil
        }
    }
}

// MARK: - Helpers -

extension Path {
    public func resolveFileType() throws -> FilesystemItemType {
        return try (-?>(try resolveFileAttributes())[FileAttributeKey.type]).flatMap(FilesystemItemType.init(rawValue:)).unwrap()
    }
}
