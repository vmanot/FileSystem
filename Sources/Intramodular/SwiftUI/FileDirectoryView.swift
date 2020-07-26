//
// Copyright (c) Vatsal Manot
//

#if canImport(SwiftUI) && (os(iOS) || targetEnvironment(macCatalyst))

import Foundation
import Swift
import SwiftUIX
import System

@available(iOS 14.0, *)
public struct FileDirectoryView: View {
    public let root: [FileLocation]
    
    public init(root: [FileLocation]) {
        self.root = root
    }
    
    public init(root: FileLocation) {
        self.root = [root]
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
            OutlineGroup(
                root.flatMap({ $0.children ?? [] }),
                id: \.hashValue,
                children: \.children,
                content: FileItemRowView.init
            )
            .navigationBarTitle(Text(title), displayMode: .inline)
        }
    }
}

extension FileLocation {
    fileprivate var children: [FileLocation]? {
        let result = try? FileManager.default
            .suburls(at: url)
            .map(FileLocation.init(_unsafe:))
            .filter({ $0.path.exists })
        
        return (result ?? []).isEmpty ? nil : result
    }
}

#endif
