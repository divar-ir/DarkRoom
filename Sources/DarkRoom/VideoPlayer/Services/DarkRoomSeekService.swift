//
//  DarkRoomSeekService.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import AVFoundation
import Foundation

// MARK: - Abstraction

public protocol DarkRoomSeekService {
    func boundedPosition(
        _ position: Double,
        item: AVPlayerItem
    ) throws -> Double
}

// MARK: - Implementation

internal struct DarkRoomSeekServiceImpl: DarkRoomSeekService {

    private let preferredTimescale: CMTimeScale

    internal init(preferredTimescale: CMTimeScale) {
        self.preferredTimescale = preferredTimescale
    }

    private func isPositionInRanges(_ position: Double, _ ranges: [CMTimeRange]) -> Bool {
        let time = CMTime(seconds: position, preferredTimescale: preferredTimescale)
        return !ranges.filter { $0.containsTime(time) }.isEmpty
    }

    private func getItemRangesAvailable(_ item: AVPlayerItem) -> [CMTimeRange] {
        let ranges = item.seekableTimeRanges + item.loadedTimeRanges
        return ranges.map { $0.timeRangeValue }
    }

    internal func boundedPosition(_ position: Double, item: AVPlayerItem) throws -> Double {

        guard position > 0 else { return .zero }

        let duration = item.duration.seconds
        guard duration.isNormal else {
            let ranges = getItemRangesAvailable(item)
            if isPositionInRanges(position, ranges) { return position }
            else { throw DarkRoomError.playerUnavailableActionReason(reason: .seekPositionNotAvailable) }
        }

        guard position < duration else { throw DarkRoomError.playerUnavailableActionReason(reason: .seekOverstepPosition) }

        return position
    }
}
