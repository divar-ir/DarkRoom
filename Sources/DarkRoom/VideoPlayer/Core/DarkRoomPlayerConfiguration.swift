//
//  DarkRoomPlayerConfiguration.swift
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

// MARK: - Abstraction

public protocol DarkRoomPlayerConfiguration {

    /// Rate Observing Service
    /// When buffering, a timer is set to observe current item rate:
    var rateObservingTimeout: TimeInterval { get }
    var rateObservingTickTime: TimeInterval { get }

    /// All `CMTime` created use the specific preferedTimeScale
    /// currentTime and control center elapsed playback time attributes are set in the periodic block.
    var preferredTimescale: CMTimeScale { get }
    var periodicPlayingTime: CMTime { get }

    /// Reachability Service
    /// When buffering or playing and playback stop unexpectedly, a timer is set to check connectivity via URLSession
    var reachabilityURLSessionTimeout: TimeInterval { get }
    var reachabilityNetworkTestingTickTime: TimeInterval { get }
    
    /// Set allowsExternalPlayback to false to avoid black screen when using AirPlay on Apple TV
    var allowsExternalPlayback: Bool { get }

    /// Use to feed `automaticallyLoadedAssetKeys` on `AVPlayerItem` initialization
    var itemLoadedAssetKeys: [String] { get }
    
    /// in second
    /// should be more than or equal to zero
    var enoughDurationForPlaying: Double { get }
}

extension DarkRoomPlayerConfiguration where Self == DarkRoomPlayerConfigurationImpl {
    
    public static var `default`: DarkRoomPlayerConfiguration { DarkRoomPlayerConfigurationImpl() }
}

// MARK: - Implementation

public struct DarkRoomPlayerConfigurationImpl: DarkRoomPlayerConfiguration {

    public var rateObservingTimeout: TimeInterval
    
    public var rateObservingTickTime: TimeInterval
    
    public var preferredTimescale: CMTimeScale
    
    public var periodicPlayingTime: CMTime
    
    public var reachabilityURLSessionTimeout: TimeInterval
    
    public var reachabilityNetworkTestingTickTime: TimeInterval
    
    public var allowsExternalPlayback: Bool
    
    public var itemLoadedAssetKeys: [String]
    
    public var enoughDurationForPlaying: Double
    
    public init(
        rateObservingTimeout: TimeInterval = 60,
        rateObservingTickTime: TimeInterval = 1,
        preferredTimescale: CMTimeScale = CMTimeScale(100_000),
        periodicPlayingTime: CMTime = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
        reachabilityURLSessionTimeout: TimeInterval = 60,
        reachabilityNetworkTestingTickTime: TimeInterval = 2,
        allowsExternalPlayback: Bool = false,
        itemLoadedAssetKeys: [String] = [],
        enoughDurationForPlaying: Double = 5
    ) {
        self.rateObservingTimeout = rateObservingTimeout
        self.rateObservingTickTime = rateObservingTickTime
        self.preferredTimescale = preferredTimescale
        self.periodicPlayingTime = periodicPlayingTime
        self.reachabilityURLSessionTimeout = reachabilityURLSessionTimeout
        self.reachabilityNetworkTestingTickTime = reachabilityNetworkTestingTickTime
        self.allowsExternalPlayback = allowsExternalPlayback
        self.itemLoadedAssetKeys = itemLoadedAssetKeys
        self.enoughDurationForPlaying = enoughDurationForPlaying
    }
}
