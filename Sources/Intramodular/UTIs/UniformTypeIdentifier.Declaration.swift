//
// Copyright (c) Vatsal Manot
//

#if os(macOS)
    import CoreServices
#else
    import MobileCoreServices
#endif

import Foundation
import Swallow
import Swift

extension UniformTypeIdentifier {
    public struct Declaration: CustomStringConvertible, DictionaryProtocol, ImplementationForwardingWrapper {
        public typealias Value = [AnyHashable: Any]

        public typealias DictionaryKey = Value.DictionaryKey
        public typealias DictionaryValue = Value.DictionaryValue

        public let value: Value

        public init(_ value: Value) {
            self.value = value
        }
    }
}

extension UniformTypeIdentifier.Declaration {
    public subscript(_ key: CFString) -> Any? {
        return self[key as AnyHashable]
    }
}

extension UniformTypeIdentifier.Declaration {
    public var exportedUTDs: [UniformTypeIdentifier.Declaration] {
        return cast(self[kUTExportedTypeDeclarationsKey], default: []).map(UniformTypeIdentifier.Declaration.init)
    }
    
    public var importedUTDs: [UniformTypeIdentifier.Declaration] {
        return cast(self[kUTImportedTypeDeclarationsKey], default: []).map(UniformTypeIdentifier.Declaration.init)
    }
    
    public var identifier: String? {
        return try? cast(self[kUTTypeIdentifierKey])
    }
    
    public var tagSpecification: [AnyHashable: Any] {
        return cast(self[kUTTypeTagSpecificationKey], default: [:])
    }
    
    public var conformances: [UniformTypeIdentifier] {
        let value = self[kUTTypeConformsToKey as AnyHashable]
        
        do {
            return [.init(try cast(value, to: String.self))]
        }
        
        catch {
            return try! cast(value, to: [String].self).map(UniformTypeIdentifier.init)
        }
    }
    
    public var iconFileName: String? {
        return try? cast(self[kUTTypeIconFileKey])
    }
    
    public var referenceURL: URL? {
        return try? URL(string: cast(self[kUTTypeReferenceURLKey])).unwrap()
    }
    
    public var version: String? {
        return try? cast(self[kUTTypeIconFileKey])
    }
}

extension UniformTypeIdentifier {
    public var declaration: Declaration {
        return .init(-?>(UTTypeCopyDeclaration(value as CFString)?.takeRetainedValue()) ?? [:])
    }
    
    public var declaringBundle: Bundle? {
        return (-?>UTTypeCopyDeclaringBundleURL(value as CFString)?.takeRetainedValue()).flatMap(Bundle.init(url:))
    }
    
    public var standardizedIconFilePath: URL? {
        return compound(declaringBundle, declaration.iconFileName, "icns").flatMap(URL.init(bundle:fileName:withOrWithoutExtension:))
    }
}
