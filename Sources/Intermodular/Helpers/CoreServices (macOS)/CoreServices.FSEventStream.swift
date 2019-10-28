//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

#if os(macOS)

public struct FSEventStream: MutableRawRepresentable {
    public typealias RawValue = FSEventStreamRef

    public var rawValue: RawValue

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

#else

public struct FSEventStream {

}

#endif

#if os(macOS)

extension FSEventStream {

    public var dispatchQueue: DispatchQueue {
        get {
            impossible()
        }

        nonmutating set {
            FSEventStreamSetDispatchQueue(rawValue, newValue)
        }
    }

    public var deviceBeingWatched: dev_t {
        return FSEventStreamGetDeviceBeingWatched(rawValue)
    }

    public var lastEventId: FSEventStreamEventId {
        return FSEventStreamGetLatestEventId(rawValue)
    }
}

#endif

#if os(macOS)

extension FSEventStream {
    public func schedule(with runLoop: CFRunLoop, runLoopMode: CFRunLoopMode) {
        FSEventStreamScheduleWithRunLoop(rawValue, runLoop, runLoopMode.rawValue)
    }

    public func unschedule(from runLoop: CFRunLoop, runLoopMode: CFString) {
        FSEventStreamUnscheduleFromRunLoop(rawValue, runLoop, runLoopMode)
    }
}

#endif

#if os(macOS)

extension FSEventStream {
    public func flush(synchronously: Bool) {
        if synchronously {
            FSEventStreamFlushSync(rawValue)
        } else {
            FSEventStreamFlushAsync(rawValue)
        }
    }

    public func invalidate() {
        FSEventStreamInvalidate(rawValue)
    }

    public func release() {
        FSEventStreamRelease(rawValue)
    }

    public func show() {
        FSEventStreamShow(rawValue)
    }

    public func start() {
        FSEventStreamStart(rawValue)
    }

    public func stop() {
        FSEventStreamStop(rawValue)
    }
}

#endif
