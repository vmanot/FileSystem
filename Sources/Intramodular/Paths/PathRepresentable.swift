//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public protocol PathRepresentable {    
    var path: Path { get }
    
    init?(path: Path)
}
