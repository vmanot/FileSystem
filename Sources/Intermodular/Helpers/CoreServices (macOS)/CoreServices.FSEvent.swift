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
    public var path: Path
    public var flags: FSEventFlags
    #endif
}

// MARK: - Helpers -

extension Path {
    #if os(macOS)
    public func watch(_ latency: TimeInterval = 0, queue: DispatchQueue = DispatchQueue.main, callback: (@escaping (FSEvent) -> Void)) -> FSEventWatcher {
        let watcher = FSEventWatcher(paths: [self], latency: latency, queue: queue, callback: callback)

        watcher.watch()

        return watcher
    }
    #endif
}

extension Sequence where Self.Element == Path {
    #if os(macOS)
    public func watch(_ latency: TimeInterval = 0, queue: DispatchQueue = DispatchQueue.main, callback: (@escaping (FSEvent) -> Void)) -> FSEventWatcher {
        let watcher = FSEventWatcher(paths: .init(self), latency: latency, queue: queue, callback: callback)

        watcher.watch()

        return watcher
    }
    #endif
}
