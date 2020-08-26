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
    public let root: FileLocation
    
    private var title: String {
        root.path.fileName
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            if root.hasChildren {
                List {
                    OutlineGroup(
                        root.children ?? [],
                        id: \.hashValue,
                        children: \.children,
                        content: FileItemRowView.init
                    )
                }
            } else {
                Text("No Files")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .fixedSize()
                    .padding(.bottom)
            }
        }
        .navigationTitle(Text(title))
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
