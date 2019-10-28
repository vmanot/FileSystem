//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public enum MobileFileProtection: RawRepresentable {
    #if os(iOS) || os(tvOS) || os(watchOS)
    case none
    case complete
    case completeUnlessOpen
    case completeUntilFirstUserAuthentication
    #endif

    public init?(rawValue: String) {
        #if os(iOS) || os(tvOS) || os(watchOS)
        switch rawValue {
        case FileProtectionType.none.rawValue:
            self = .none
        case FileProtectionType.complete.rawValue:
            self = .complete
        case FileProtectionType.completeUnlessOpen.rawValue:
            self = .completeUnlessOpen
        case FileProtectionType.completeUntilFirstUserAuthentication.rawValue:
            self = .completeUntilFirstUserAuthentication
        default:
            return nil
        }
        #else
        return nil
        #endif
    }

    public var rawValue: String {
        #if os(iOS) || os(tvOS) || os(watchOS)
        switch self {
        case .none:
            return FileProtectionType.none.rawValue
        case .complete:
            return FileProtectionType.complete.rawValue
        case .completeUnlessOpen:
            return FileProtectionType.completeUnlessOpen.rawValue
        case .completeUntilFirstUserAuthentication:
            return FileProtectionType.completeUntilFirstUserAuthentication.rawValue
        }
        #else
        return impossible()
        #endif
    }
}

// MARK: - Helpers -

extension Data.WritingOptions {
    public init(mobileFileProtection: MobileFileProtection) {
        #if os(iOS) || os(tvOS) || os(watchOS)
        switch mobileFileProtection {
        case .none:
            self = .noFileProtection
        case .complete:
            self = .completeFileProtection
        case .completeUnlessOpen:
            self = .completeFileProtectionUnlessOpen
        case .completeUntilFirstUserAuthentication:
            self = .completeFileProtectionUntilFirstUserAuthentication
        }
        #else
        self.init()
        #endif
    }
}
