//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension CommandLine {
    public static var workingPath: Path {
        get {
            return Path.currentDirectory
        } set {
            Path.currentDirectory = newValue
        }
    }
}
