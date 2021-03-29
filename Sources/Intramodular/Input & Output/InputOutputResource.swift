//
// Copyright (c) Vatsal Manot
//

import Foundation
import Merge
import POSIX
import Runtime
import Swallow

open class InputOutputResource {
    var descriptor: POSIXIOResourceDescriptor
    var descriptorIsOwned: Bool
    
    public init(
        descriptor: POSIXIOResourceDescriptor,
        transferOwnership: Bool = true
    ) throws {
        self.descriptor = descriptor
        self.descriptorIsOwned = transferOwnership
    }
    
    deinit {
        if descriptorIsOwned {
            evaluateWithProcessCriticalScope {
                try descriptor.close()
            }
        }
    }
}

// MARK: - Conformances -

extension InputOutputResource: CustomStringConvertible {
    open var description: String {
        return "I/O Resource"
    }
}
