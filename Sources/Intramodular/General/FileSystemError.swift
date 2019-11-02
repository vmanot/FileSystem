//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

public enum FilesystemError: Error {
    case couldNotAccessWithSecureScope(URL)
    case fileNotFound(URL)
    case invalidPathAppend(FilePath)
    case isNotFileURL(URL)
}
