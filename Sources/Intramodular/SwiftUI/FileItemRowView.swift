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
        .disabled(!location.isReachable)
    }
    
    struct RegularFileView: View {
        @Environment(\.presenter) var presenter
        @Environment(\.fileManager) var fileManager

        let location: FileLocation
        
        var body: some View {
            Label(
                location.url.lastPathComponent,
                systemImage: .docFill
            )
            .contextMenu {
                Label("Share", systemImage: .squareAndArrowUp)
                    .onPress(present: AppActivityView(activityItems: [location.url]))
            }
        }
    }
    
    struct DirectoryView: View {
        @Environment(\.fileManager) var fileManager

        let location: FileLocation
        
        var body: some View {
            Label(
                location.url.lastPathComponent,
                systemImage: location.hasChildren ? .folderFill : .folder
            )
            .onPress(navigateTo: FileDirectoryView(root: location))
            .disabled(!location.hasChildren || !location.isReachable)
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
}

#endif
