//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public enum FilesystemError: Error {
    case couldNotAccessWithSecureScope(URL)
    case fileNotFound(URL)
    case invalidPathAppend(Path)
    case isNotFileURL(URL)
}
