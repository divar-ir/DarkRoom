//
//  DarkRoomPlayerState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import Foundation

// MARK: - Abstraction

/// abstraction for states of the player
public protocol DarkRoomPlayerState: DarkRoomPlayerCommand {
    
    /// refrence to the context of states
    var context: DarkRoomPlayerContext { get }

    /// determines the type of state
    var type: DarkRoomPlayerStates { get }

    /// determines whether teh seek action is enabled on the state or not
    var isSeekingEnabled: Bool { get }

    /// notify the state that context was updated
    /// states can be refreshed or change to another state if needed
    func contextUpdated()
}
