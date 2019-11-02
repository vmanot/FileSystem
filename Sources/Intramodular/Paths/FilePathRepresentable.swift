//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public protocol FilePathRepresentable {
    var path: FilePath { get }
    
    init?(path: FilePath)
}
