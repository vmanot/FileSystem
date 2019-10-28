//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension Bundle {
    public convenience init?(path: Path) {
        self.init(path: path.stringValue)
    }
}

extension InputStream {
    public convenience init?(path: Path) {
        self.init(fileAtPath: path.stringValue)
    }
}

extension OutputStream {
    public convenience init?(path: Path) {
        self.init(path: path, append: false)
    }
    
    public convenience init?(path: Path, append shouldAppend: Bool) {
        self.init(toFileAtPath: path.stringValue, append: shouldAppend)
    }
}

extension URL {
    public init(path: Path) {
        self.init(fileURLWithPath: path.cocoaFilePath)
    }
}
