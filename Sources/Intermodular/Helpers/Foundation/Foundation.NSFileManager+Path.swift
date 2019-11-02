//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow
import Swift

extension FilePath {
    public static func paths(inDomains directory: FileManager.SearchPathDirectory, mask: FileManager.SearchPathDomainMask) -> [FilePath] {
        return NSSearchPathForDirectoriesInDomains(directory, mask, true).map(FilePath.init(stringValue:))
    }
    
    public static func path(inUserDomain directory: FileManager.SearchPathDirectory) -> FilePath {
        return paths(inDomains: directory, mask: .userDomainMask).first!
    }
    
    public static func path(inSystemDomain directory: FileManager.SearchPathDirectory) -> FilePath {
        return paths(inDomains: directory, mask: .systemDomainMask).first!
    }
}
