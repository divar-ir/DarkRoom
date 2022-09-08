//
//  DarkRoomSeekService.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//
//  Copyright (c) 2022 Divar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
