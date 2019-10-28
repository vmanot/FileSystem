//
// Copyright (c) Vatsal Manot
//

import Concurrency
import Foundation
import POSIX
import Runtime
import Swallow
import Swift

open class InputOutputResource: AnyProtocol {
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

// MARK: - Protocol Implementations -

extension InputOutputResource: CustomStringConvertible {
    open var description: String {
        return "I/O Resource"
    }
}
