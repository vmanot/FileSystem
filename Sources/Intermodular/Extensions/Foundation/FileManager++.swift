//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension FileManager {
    public func suburls(at url: URL) throws -> [URL] {
        try contentsOfDirectory(atPath: url.path).map({ url.appendingPathComponent($0) })
    }
}
