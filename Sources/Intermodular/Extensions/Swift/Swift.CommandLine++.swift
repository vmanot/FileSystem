//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension CommandLine {
    public static var workingPath: FilePath {
        get {
            return FilePath.currentDirectory
        } set {
            FilePath.currentDirectory = newValue
        }
    }
}
