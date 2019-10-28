//
// Copyright (c) Vatsal Manot
//

#if os(macOS)
import CoreServices
#else
import MobileCoreServices
#endif

import Swift

public enum UniformTypeTagClass: String {
    case fileNameExtension
    case mimeType

    #if os(macOS)
    case pasteboardType
    case osType
    #endif

    public var rawValue: String {
        #if os(macOS)
        switch self {
        case .fileNameExtension:
            return kUTTagClassFilenameExtension as String
        case .mimeType:
            return kUTTagClassMIMEType as String
        case .pasteboardType:
            return kUTTagClassNSPboardType as String
        case .osType:
            return kUTTagClassOSType as String
        }
        #else
        switch self {
        case .fileNameExtension:
            return kUTTagClassFilenameExtension as String
        case .mimeType:
            return kUTTagClassMIMEType as String
        }
        #endif
    }

    public init?(rawValue: String) {
        #if os(macOS)
        switch rawValue {
        case type(of: self).fileNameExtension.rawValue:
            self = .fileNameExtension
        case type(of: self).mimeType.rawValue:
            self = .mimeType
        case type(of: self).pasteboardType.rawValue:
            self = .pasteboardType
        case type(of: self).osType.rawValue:
            self = .osType

        default:
            return nil
        }
        #else
        switch rawValue {
        case type(of: self).fileNameExtension.rawValue:
            self = .fileNameExtension
        case type(of: self).mimeType.rawValue:
            self = .mimeType

        default:
            return nil
        }
        #endif
    }
}
