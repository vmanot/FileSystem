//
// Copyright (c) Vatsal Manot
//

import Combine
import Foundation
import Merge
import Swallow

extension NSItemProvider {
    public func loadItem(
        forTypeIdentifier typeIdentifier: UniformTypeIdentifier,
        options: [AnyHashable: Any]? = nil
    ) -> Future<NSSecureCoding, Error> {
        .init { attemptToFulfill in
            TODO.whole(.modernize, note: "Use Task over Future")
            
            _ = self.loadItem(forTypeIdentifier: typeIdentifier.value, options: options) { item, error in
                attemptToFulfill(Result(item, error: error)!)
            }
        }
    }
    
    public final func loadObject<T: _ObjectiveCBridgeable>(
        ofClass aClass: T.Type,
        completionHandler: @escaping (T?, Error?) -> Void
    ) -> Future<T, Error> {
        .init { attemptToFulfill in
            TODO.whole(.modernize, note: "Use Task over Future")
            
            _ = self.loadObject(ofClass: T.self) { item, error in
                attemptToFulfill(Result(item, error: error)!)
            }
        }
    }
    
    public func loadURL(relativeTo url: URL? = nil) -> AnyPublisher<URL, Error> {
        loadItem(forTypeIdentifier: .url)
            .tryMap({ try cast($0, to: Data.self) })
            .map({ URL(dataRepresentation: $0, relativeTo: url) })
            .unwrap()
            .eraseToAnyPublisher()
    }
    
    public func loadFileURL(relativeTo url: URL? = nil) -> AnyPublisher<URL, Error> {
        loadItem(forTypeIdentifier: .fileURL)
            .tryMap({ try cast($0, to: Data.self) })
            .map({ URL(dataRepresentation: $0, relativeTo: url) })
            .unwrap()
            .eraseToAnyPublisher()
    }
}
