//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift
import System

public protocol FileLocationInitiable {
    init(_: FileLocation)
}

extension FileLocationInitiable {
    public init?(url: URL) {
        guard let location = FileLocation(url: url) else {
            return nil
        }
        
        self.init(location)
    }
}
