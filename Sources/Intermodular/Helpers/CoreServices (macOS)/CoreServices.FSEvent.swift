//
// Copyright (c) Vatsal Manot
//

#if os(macOS)
import CoreServices
#endif

import Foundation
import Swallow
import Swift

public struct FSEvent {
    #if os(macOS)
    public static let allEventID = 0
    public static let nowEventID = FSEventStreamEventId(kFSEventStreamEventIdSinceNow)

    public var id: FSEventStreamEventId
    public var path: FilePath
    public var flags: FSEventFlags
    #endif
}

// MARK: - Helpers -

extension FilePath {
    #if os(macOS)
    public func watch(_ latency: TimeInterval = 0, queue: DispatchQueue = DispatchQueue.main, callback: (@escaping (FSEvent) -> Void)) -> FSEventWatcher {
        let watcher = FSEventWatcher(paths: [self], latency: latency, queue: queue, callback: callback)

        watcher.watch()

        return watcher
    }
    #endif
}

extension Sequence where Self.Element == FilePath {
    #if os(macOS)
    public func watch(_ latency: TimeInterval = 0, queue: DispatchQueue = DispatchQueue.main, callback: (@escaping (FSEvent) -> Void)) -> FSEventWatcher {
        let watcher = FSEventWatcher(paths: .init(self), latency: latency, queue: queue, callback: callback)

        watcher.watch()

        return watcher
    }
    #endif
}
