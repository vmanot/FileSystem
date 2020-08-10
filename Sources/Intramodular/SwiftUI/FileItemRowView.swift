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
                DirectoryView(location: location)
            } else {
                RegularFileView(location: location)
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
        .disabled(!location.isReachable)
    }
    
    struct RegularFileView: View {
        let location: FileLocation
        
        var body: some View {
            Label(
                location.url.lastPathComponent,
                systemImage: .docFill
            )
        }
    }
    
    struct DirectoryView: View {
        let location: FileLocation
        
        var body: some View {
            NavigationLink(destination: FileDirectoryView(root: location)) {
                Label(
                    location.url.lastPathComponent,
                    systemImage: location.hasChildren ? .folderFill : .folder
                )
            }
            .disabled(!location.hasChildren || !location.isReachable)
        }
    }
}

#endif
