//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

#if os(macOS)

public class FSEventWatcher {
    private static let callback: FSEventStreamCallback = {
        (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutableRawPointer?, numEvents: Int, eventPaths: UnsafeMutableRawPointer, eventFlags: UnsafePointer<FSEventStreamEventFlags>, eventIds: UnsafePointer<FSEventStreamEventId>) in

        let watcher: FSEventWatcher = -*>contextInfo

        defer {
            watcher.lastEventId = eventIds[numEvents - 1]
         }
        
        guard let paths = (-*>eventPaths as NSArray) as? [String] else {
            return
        }

        for index in 0..<numEvents {
            let id = eventIds[index]
            let path = paths[index]
            let flags = eventFlags[index]
            
            watcher.process(.init(id: id, path: .init(stringValue: path), flags: .init(rawValue: Int(flags))))
        }
    }

    public let paths: [Path]

    public let latency: CFTimeInterval
    public let queue: DispatchQueue?
    public let flags: FSEventStreamCreateFlags

    public var runLoopMode: CFRunLoopMode = CFRunLoopMode.defaultMode
    public var runLoop: CFRunLoop = CFRunLoopGetMain()

    private let callback: ((FSEvent) -> Void)

    public private(set) var lastEventId: FSEventStreamEventId

    private var started = false
    private var stream: FSEventStream?

    public init(paths: [Path], sinceWhen: FSEventStreamEventId = FSEvent.nowEventID, flags: FSEventStreamCreateFlags = [.useCFTypes, .fileEvents], latency: CFTimeInterval = 0, queue: DispatchQueue? = nil, callback: @escaping (FSEvent) -> Void) {
        self.lastEventId = sinceWhen
        self.paths = paths
        self.flags = flags
        self.latency = latency
        self.queue = queue
        self.callback = callback
    }

    deinit {
        self.close()
    }

    private func process(_ event: FSEvent) {
        self.callback(event)
    }

    public func watch() {
        guard started == false else {
            return
        }

        var context = FSEventStreamContext()

        context.info = Unmanaged.passUnretained(self).toOpaque()

        guard let streamRef = FSEventStreamCreate(kCFAllocatorDefault, FSEventWatcher.callback, &context, paths.map({ $0.stringValue }) as CFArray, lastEventId, latency, UInt32(flags.rawValue)) else {
            return
        }
        
        stream = FSEventStream(rawValue: streamRef)

        stream?.schedule(with: runLoop, runLoopMode: runLoopMode)
        
        if let queue = queue {
            stream?.dispatchQueue = queue
        }
        
        stream?.start()

        started = true
    }

    public func close() {
        guard started == true else {
            return
        }

        stream?.stop()
        stream?.invalidate()
        stream?.release()
        stream = nil

        started = false
    }

    public func flush(synchronously: Bool) {
        stream?.flush(synchronously: synchronously)
    }
}

#endif
