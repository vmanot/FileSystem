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
import Swift

public struct UniformTypeIdentifier: Wrapper {
    public typealias Value = String

    public let value: Value

    public init(_ value: Value) {
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

// MARK: - Helpers -

extension SequenceInitiableSequence where Element == UniformTypeIdentifier {
    public init(tag: String, class tagClass: UniformTypeTagClass, conformingTo uti: UniformTypeIdentifier?) {
        let identifiers = UTTypeCreateAllIdentifiersForTag(tagClass.rawValue as CFString, tag as CFString, uti?.value as CFString?)?.takeRetainedValue() as? [String]

        self.init((identifiers ?? []).lazy.map(UniformTypeIdentifier.init))
    }
}
