//
// Copyright (c) Vatsal Manot
//

#if canImport(Cocoa) && !canImport(UIKit)

import Cocoa
import Foundation
import Swallow
import Swift

extension NSDraggingInfo {
    public func pathsFromDraggingPasteboard() -> [URL]? {
        let pasteboard = draggingPasteboard
        
        guard pasteboard.types?.contains(NSPasteboard.PasteboardType.fileURL) ?? false else {
            return nil
        }
        
        return try? cast(pasteboard.readObjects(forClasses: [NSURL.self], options: nil), to: [URL].self) ?? []
    }
}

#endif
