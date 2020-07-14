//
// Copyright (c) Vatsal Manot
//

#if canImport(SwiftUI) && (os(iOS) || targetEnvironment(macCatalyst))

import Foundation
import Swift
import SwiftUI
import System

public struct FileManagerView: View {
    public let manager: FileManager
    public let directory: FileManager.SearchPathDirectory
    public let domainMask: FileManager.SearchPathDomainMask
    
    public init(
        manager: FileManager = .default,
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask
    ) {
        self.manager = manager
        self.directory = directory
        self.domainMask = domainMask
    }
    
    public var body: some View {
        NavigationView {
            List(fileLocations) { location in
                NavigationLink(destination: FileDirectoryView(root: location)) {
                    Text(location.url.lastPathComponent)
                }
            }
            .navigationBarTitle("Rover")
        }
    }
    
    private var fileLocations: [FileLocation] {
        FileManager.default
            .urls(for: directory, in: domainMask)
            .map(FileLocation.init(_unsafe:))
    }
    
}

#endif
