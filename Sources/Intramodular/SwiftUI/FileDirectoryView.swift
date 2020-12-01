//
// Copyright (c) Vatsal Manot
//

#if canImport(SwiftUI) && (os(iOS) || targetEnvironment(macCatalyst))

import Foundation
import Swift
import SwiftUIX
import System

@available(iOS 14.0, *)
public struct FileDirectoryView: FileLocationInitiable, View {
    public let location: FileLocation
    
    public init(_ location: FileLocation) {
        self.location = location
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            if location.hasChildren {
                List {
                    OutlineGroup(
                        location.children ?? [],
                        id: \.hashValue,
                        children: \.children,
                        content: FileItemRowView.init
                    )
                }
                .listStyle(InsetGroupedListStyle())
            } else {
                Text("No Files")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .fixedSize()
                    .padding(.bottom)
            }
        }
        .navigationTitle(Text(location.path.lastComponent))
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
