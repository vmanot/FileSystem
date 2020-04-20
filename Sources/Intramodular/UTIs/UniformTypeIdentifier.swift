//
// Copyright (c) Vatsal Manot
//

#if os(macOS)
import CoreServices
#endif

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import MobileCoreServices
#endif

import Swallow
import SwiftUI

public struct UniformTypeIdentifier: Wrapper {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public init?(tag: String, class: UniformTypeTagClass, conformingTo uti: UniformTypeIdentifier? = nil) {
        self.init(nilIfNil: UTTypeCreatePreferredIdentifierForTag(`class`.rawValue as CFString, tag as CFString, uti?.value as CFString?)?.takeRetainedValue() as String?)
    }
}

extension UniformTypeIdentifier {
    public var isDynamic: Trilean {
        let value = self.value as CFString
        
        return UTTypeIsDeclared(value) ? false : (UTTypeIsDynamic(value) ? true : unknown)
    }
}

// MARK: - Protocol Implementations -

extension UniformTypeIdentifier: ApproximatelyEquatable {
    public static func ~= (lhs: UniformTypeIdentifier, rhs: UniformTypeIdentifier) -> Bool {
        return UTTypeConformsTo(rhs.value as CFString, lhs.value as CFString)
    }
}

extension UniformTypeIdentifier: CustomStringConvertible {
    public var description: String {
        return UTTypeCopyDescription(value as CFString)?.takeRetainedValue() as String? ?? value
    }
}

extension UniformTypeIdentifier: Equatable2 {
    public static func == (lhs: UniformTypeIdentifier, rhs: UniformTypeIdentifier) -> Bool {
        return UTTypeEqual(lhs.value as CFString, rhs.value as CFString)
    }
}

// MARK: - API -

extension UniformTypeIdentifier {
    public static let url = UniformTypeIdentifier(kUTTypeURL as String)
    public static let fileURL = UniformTypeIdentifier(kUTTypeFileURL as String)
}

extension View {
    @available(iOS 13.4, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func onDrop(of supportedTypes: [UniformTypeIdentifier], delegate: DropDelegate) -> some View {
        onDrop(of: supportedTypes.map(\.value), delegate: delegate)
    }
}

// MARK: - Helpers -

extension SequenceInitiableSequence where Element == UniformTypeIdentifier {
    public init(
        tag: String,
        class tagClass: UniformTypeTagClass,
        conformingTo uti: UniformTypeIdentifier?
    ) {
        let identifiers = UTTypeCreateAllIdentifiersForTag(tagClass.rawValue as CFString, tag as CFString, uti?.value as CFString?)?.takeRetainedValue() as? [String]
        
        self.init((identifiers ?? []).lazy.map(UniformTypeIdentifier.init))
    }
}
