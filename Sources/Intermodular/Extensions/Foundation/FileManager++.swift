//
// Copyright (c) Vatsal Manot
//

#if canImport(Cocoa)
import Cocoa
#endif

import FoundationX
import Swallow
import SwiftUIX

extension FileManager {
    public func fileExists(at url: URL) -> Bool {
        fileExists(atPath: url.path)
    }
    
    public func isDirectory<T: URLRepresentable>(at location: T) -> Bool {
        let url = location.url
        var isDirectory = ObjCBool(false)
        
        guard fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return false
        }
        
        return isDirectory.boolValue
    }
    
    public func isReadableAndWritable<T: URLRepresentable>(at location: T) -> Bool {
        var url = location.url
        
        if isDirectory(at: url) && !url.path.hasSuffix("/") {
            url = URL(FilePath(url.path.appending("/")))!
        }
        
        return isReadableFile(atPath: url.path) && isWritableFile(atPath: url.path)
    }

    public func suburls<T: URLRepresentable>(at location: T) throws -> [T] {
        try contentsOfDirectory(atPath: location.url.path)
            .lazy
            .map({ location.url.appendingPathComponent($0) })
            .map({ try T(url: $0).unwrap() })
    }

    public func enumerateRecursively<T: URLRepresentable>(
        at location: T,
        includingPropertiesForKeys keys: [URLResourceKey]? = nil,
        options mask: FileManager.DirectoryEnumerationOptions = [],
        body: (T) throws -> Void
    ) throws {
        let url = location.url
        
        if !isDirectory(at: url) {
            return try body(location)
        }
        
        var errorEncountered: Error? = nil
        
        guard let enumerator = enumerator(
            at: url,
            includingPropertiesForKeys: keys,
            options: mask,
            errorHandler: { url, error in
                errorEncountered = error
                
                return false
            }
        ) else {
            return
        }
        
        var locations: [T] = []
        
        for case let fileURL as URL in enumerator {
            if let keys = keys {
                let _ = try fileURL.resourceValues(forKeys: .init(keys))
            }
            
            locations.append(try T.init(url: fileURL).unwrap())
        }
        
        if let error = errorEncountered {
            throw error
        }
        
        try locations.forEach(body)
    }
}

extension FileManager {
    public func createDirectoryIfNecessary(at url: URL) throws {
        guard !fileExists(at: url) else {
            return
        }
        
        try createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
    }
    
    public func removeItem(at path: FilePath) throws {
        try removeItem(at: URL(path).unwrap())
    }
    
    public func removeItemIfNecessary(at url: URL) throws {
        guard !fileExists(at: url) else {
            return
        }
        
        try removeItem(at: url)
    }
}

extension FileManager {
    private struct SandboxFolderAccessError: Error {
        
    }
    
    #if canImport(Cocoa)
    
    @discardableResult
    public func acquireSandboxAccess(
        toFolder location: FileLocationResolvable,
        openPanelMessage: String
    ) throws -> FileLocation {
        let location = try location.resolveFileLocation()
        
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

extension FileManager {
    public func documentsDirectoryURL(forUbiquityContainerIdentifier: String?) throws -> URL? {
        guard let url = url(forUbiquityContainerIdentifier: forUbiquityContainerIdentifier)?.appendingPathComponent("Documents") else {
            return nil
        }
        
        guard !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) else {
            return url
        }
        
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        
        return url
    }
}
