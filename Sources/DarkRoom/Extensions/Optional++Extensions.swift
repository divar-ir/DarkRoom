//
//  Optional++Extensions.swift
//  
//
//  Created by Kiarash Vosough on 7/21/22.
//

import Foundation

internal extension Optional {
    
    func onValuePresent(_ action: (Wrapped) throws -> Void) rethrows {
        if self != nil { try action(self!) }
    }
    
    func combine<T>(_ keyPath: KeyPath<Wrapped,T?>) -> (Wrapped,T)? {
        guard let self = self, let value = self[keyPath: keyPath] else { return nil }
        return (self,value)
    }
}
