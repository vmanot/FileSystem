//
// Copyright (c) Vatsal Manot
//

#if canImport(SwiftUI) && (os(iOS) || targetEnvironment(macCatalyst))

import Foundation
import Swift
import SwiftUIX
import System

public struct FileItemRowView: View {
    @Environment(\.fileManager) var fileManager
    
    public let location: FileLocation
    
    public init(location: FileLocation) {
        self.location = location
    }
    
    public var body: some View {
        Group {
            if try! FilePath(fileURL: location.url).resolveFileType() == .directory {
                FileDirectoryRowView(location: location)
            } else {
                RegularFileRowView(location: location)
            }
        }
        .contextMenu {
            TryButton {
                try fileManager.removeItem(at: location.url)
            } label: {
                Text("Delete")
                    .foregroundColor(.red)
            }
        }
    }
}

public struct RegularFileRowView: View {
    public let location: FileLocation
    
    public init(location: FileLocation) {
        self.location = location
    }
    
    public var body: some View {
        Text(location.url.lastPathComponent)
    }
}

public struct FileDirectoryRowView: View {
    @State var isNavigated: Bool = false
    
    public let location: FileLocation
    
    public init(location: FileLocation) {
        self.location = location
    }
    
    public var body: some View {
        Text(location.url.lastPathComponent)
            .navigate(isActive: $isNavigated) {
                FileDirectoryView(root: location)
            }
            .onTapGesture {
                isNavigated = true
            }
    }
}

#endif
