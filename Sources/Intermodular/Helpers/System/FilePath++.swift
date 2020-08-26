//
// Copyright (c) Vatsal Manot
//

import Foundation
import System

extension FilePath {
    public static func + (lhs: Self, rhs: String) -> Self {
        FilePath(URL(lhs)!.appendingPathComponent(String(rhs.dropPrefixIfPresent("/"))))!
    }
}
