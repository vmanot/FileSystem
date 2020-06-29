//
// Copyright (c) Vatsal Manot
//

#if canImport(SwiftUI) && (os(iOS) || targetEnvironment(macCatalyst))

import Foundation
import Swift
import SwiftUI
import System

public struct FileManagerView: View {
    var locations: [FileLocation] {
        FileManager.default
            .urls(for: .libraryDirectory, in: .userDomainMask)
            .map(FileLocation.init(_unsafe:))
    }
    
    public var body: some View {
        NavigationView {
            List(locations, id: \.hashValue) { location in
                NavigationLink(destination: FileDirectoryView(root: location)) {
                    Text(location.url.lastPathComponent)
                }
            }
            .navigationBarTitle("Rover")
        }
    }
    
    public init() {
        
    }
}

#endif
