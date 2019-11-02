//
// Copyright (c) Vatsal Manot
//

import Swift

extension String {
    public init(path: FilePath) {
        self = path.stringValue
    }
}
