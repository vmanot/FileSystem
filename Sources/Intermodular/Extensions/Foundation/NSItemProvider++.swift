//
// Copyright (c) Vatsal Manot
//

import Combine
import Foundation
import Merge
import Swallow
import UniformTypeIdentifiers

extension NSItemProvider {
    public func loadItem(
        for type: UTType,
        options: [AnyHashable: Any]? = nil
    ) -> Future<NSSecureCoding, Error> {
        .init { attemptToFulfill in
            self.loadItem(forTypeIdentifier: type.identifier, options: options) { item, error in
                attemptToFulfill(Result(item, error: error)!)
            }
        }
    }
    
    public final func loadObject<T: _ObjectiveCBridgeable>(
        ofClass aClass: T.Type,
        completionHandler: @escaping (T?, Error?) -> Void
    ) -> Future<T, Error> {
        .init { attemptToFulfill in
            _ = self.loadObject(ofClass: T.self) { item, error in
                attemptToFulfill(Result(item, error: error)!)
            }
        }
    }
    
    public func loadURL(relativeTo url: URL? = nil) -> AnyPublisher<URL, Error> {
        loadItem(for: .url)
            .tryMap({ try cast($0, to: Data.self) })
            .map({ URL(dataRepresentation: $0, relativeTo: url) })
            .unwrap()
            .eraseToAnyPublisher()
    }
    
    public func loadFileURL(relativeTo url: URL? = nil) -> AnyPublisher<URL, Error> {
        loadItem(for: .fileURL)
            .tryMap({ try cast($0, to: Data.self) })
            .map({ URL(dataRepresentation: $0, relativeTo: url) })
            .unwrap()
            .eraseToAnyPublisher()
    }
}
