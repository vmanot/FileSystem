//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension Path {
    public static func paths(inDomains directory: FileManager.SearchPathDirectory, mask: FileManager.SearchPathDomainMask) -> [Path] {
        return NSSearchPathForDirectoriesInDomains(directory, mask, true).map({ Path(stringValue: $0) })
    }
    
    public static func path(inUserDomain directory: FileManager.SearchPathDirectory) -> Path {
        return paths(inDomains: directory, mask: .userDomainMask).first!
    }
    
    public static func path(inSystemDomain directory: FileManager.SearchPathDirectory) -> Path {
        return paths(inDomains: directory, mask: .systemDomainMask).first!
    }
}
