//
// Copyright (c) Vatsal Manot
//

#if canImport(SwiftUI) && (os(iOS) || targetEnvironment(macCatalyst))

import Foundation
import Swift
import SwiftUIX
import System

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

@available(iOS 14.0, *)
public struct FileDirectoryView: View {
    public let root: [FileLocation]
    
    public init(root: [FileLocation]) {
        self.root = root
    }
    
    public init(root: FileLocation) {
        self.root = [root]
    }
    
    private var items: [FileLocation] {
        root.flatMap({ $0.contents ?? [] })
    }
    
    private var title: String {
        if let first = root.first, root.count == 1 {
            return first.path.fileName
        } else {
            return "Files"
        }
    }
    
    public var body: some View {
        List {
            OutlineGroup(items, id: \.hashValue, children: \.contents) { location in
                FileItemRowView(location: location)
            }
            .navigationBarTitle(Text(title), displayMode: .inline)
        }
    }
}

extension FileLocation {
    fileprivate var contents: [FileLocation]? {
        let result = try? FileManager.default
            .suburls(at: url)
            .map(FileLocation.init(_unsafe:))
            .filter({ $0.path.exists })
        
        return (result ?? []).isEmpty ? nil : result
    }
}

#endif
