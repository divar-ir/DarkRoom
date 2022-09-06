//
//  DarkRoomPlayerStates.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import Foundation

public enum DarkRoomPlayerStates: String {
    case buffering
    case failed
    case initialization
    case loaded
    case loading
    case paused
    case playing
    case stopped
    case waitingForNetwork
}

extension DarkRoomPlayerStates: CustomStringConvertible {
    public var description: String {
        switch self {
        case .waitingForNetwork:
            return "Waiting For Network"
        default:
            return rawValue.capitalized
        }
    }
}
