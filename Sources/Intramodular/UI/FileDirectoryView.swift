//
// Copyright (c) Vatsal Manot
//

#if canImport(SwiftUI) && (os(iOS) || targetEnvironment(macCatalyst))

import Foundation
import Swift
import SwiftUI
import System

extension FileLocation {
    fileprivate var contents: [FileLocation]? {
        let result = try? FileManager.default
            .suburls(at: url)
            .map(FileLocation.init(_unsafe:))
            .filter({ $0.path.exists })
        
        return (result ?? []).isEmpty ? nil : result
    }
}

@available(iOS 14.0, *)
public struct FileDirectoryView: View {
    public let root: FileLocation
    
    public var body: some View {
        List(root.contents ?? [], id: \.hashValue, children: \.contents) { location in
            if try! FilePath(fileURL: location.url).resolveFileType() == .directory {
                NavigationLink(destination: FileDirectoryView(root: location)) {
                    Text(location.url.lastPathComponent)
                }
            } else {
                Text(location.url.lastPathComponent)
            }
        }
        .navigationBarTitle(Text(root.path.fileName), displayMode: .inline)
    }
}

#endif
