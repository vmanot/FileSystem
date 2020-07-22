//
// Copyright (c) Vatsal Manot
//

#if canImport(Cocoa)
import Cocoa
#endif

import Foundation
import Swallow
import SwiftUIX

extension FileManager {
    public func suburls(at url: URL) throws -> [URL] {
        try contentsOfDirectory(atPath: url.path).map({ url.appendingPathComponent($0) })
    }
    
    public func isReadableAndWritable(at url: URL) -> Bool {
        isReadableFile(atPath: url.path) && isWritableFile(atPath: url.path)
    }
}

extension FileManager {
    private struct SandboxFolderAccessError: Error {
        
    }
    
    #if canImport(Cocoa)
    
    public func acquireSandboxAccess(
        toFolder location: FileLocation,
        openPanelMessage: String
    ) throws -> FileLocation {
        if isReadableAndWritable(at: location.url) {
            return location
        }
        
        if let bookmarkData = location.bookmarkData {
            do {
                var isBookmarkStale = false
                let resolvedURL = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isBookmarkStale)
                
                if !isBookmarkStale {
                    if isReadableAndWritable(at: resolvedURL) {
                        return location
                    } else {
                        throw SandboxFolderAccessError()
                    }
                } else {
                    throw SandboxFolderAccessError()
                }
            } catch {
                return try acquireSandboxAccess(
                    toFolder: location.discardingBookmarkData(),
                    openPanelMessage: openPanelMessage
                )
            }
        }
        
        #if os(macOS)
        let openPanel = NSOpenPanel()
        #else
        let openPanel = NSOpenPanel_Type.init()
        #endif
        
        openPanel.directoryURL = location.url
        openPanel.message = openPanelMessage
        openPanel.prompt = "Open"
        
        openPanel.allowedFileTypes = ["none"]
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseDirectories = true
        
        openPanel.runModal()
        
        if let folderUrl = openPanel.urls.first {
            if folderUrl != location {
                #if os(macOS)
                let alert = NSAlert()
                alert.alertStyle = .informational
                #else
                let alert = NSAlert_Type.init()
                alert.alertStyle = 1
                #endif
                
                alert.messageText = "Can't get access to \(location.url.path) folder"
                alert.informativeText = "Did you choose the right folder?"
                
                alert.addButton(withTitle: "Repeat")
                
                alert.runModal()
                
                return try acquireSandboxAccess(toFolder: location.discardingBookmarkData(), openPanelMessage: openPanelMessage)
            }
            
            if isReadableAndWritable(at: folderUrl) {
                if let bookmarkData = try? folderUrl.bookmarkData() {
                    return FileLocation(url: folderUrl, bookmarkData: bookmarkData)!
                }
            } else {
                throw SandboxFolderAccessError()
            }
        } else {
            throw SandboxFolderAccessError()
        }
        
        return try acquireSandboxAccess(
            toFolder: location.discardingBookmarkData(),
            openPanelMessage: openPanelMessage
        )
    }
    
    #endif
}
