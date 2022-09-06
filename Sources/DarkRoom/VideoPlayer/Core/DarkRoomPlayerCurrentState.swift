//
//  DarkRoomPlayerCurrentState.swift
//  
//
//  Created by Kiarash Vosough on 7/13/22.
//

import Foundation

// MARK: - Abstraction

public protocol DarkRoomPlayerCurrentState: AnyObject {
    var state: DarkRoomPlayerStates { get }
}
