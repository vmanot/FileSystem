//
// Copyright (c) Vatsal Manot
//

import SwiftUI
import UniformTypeIdentifiers

public struct TextFileDocument: Codable, FileDocument, Hashable {
    public static var readableContentTypes = [UTType.plainText]
    
    public var text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: try text.data(using: .utf8).unwrap())
    }
}
