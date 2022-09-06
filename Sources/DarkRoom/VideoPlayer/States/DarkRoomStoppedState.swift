//
//  DarkRoomStoppedState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation

// MARK: - Implementation

internal final class DarkRoomStoppedState: DarkRoomPausedState {

    // MARK: Init

    internal init(context: DarkRoomPlayerContext) {
        super.init(context: context, type: .stopped)
        seek(position: 0)
    }

    internal override func contextUpdated() {}

    // MARK: - Shared actions

    internal override func pause() {
        context.changeState(state: DarkRoomPausedState(context: context))
    }

    internal override func stop() {
        context.delegate?.playerContext(
            catched: DarkRoomError.playerUnavailableActionReason(
                reason: .alreadyStopped
            )
        )
    }
}
