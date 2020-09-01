//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

public protocol URLConvertible: AnyProtocol {
    var url: URL { get }
}

public protocol URLRepresentable: URLConvertible {
    init?(url: URL)
}

// MARK: - Concrete Implementations -

extension URL: URLRepresentable {
    public var url: URL {
        return self
    }
    
    public init(url: URL) {
        self = url
    }
}