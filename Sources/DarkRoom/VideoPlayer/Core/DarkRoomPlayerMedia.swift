//
//  DarkRoomPlayerMedia.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

import Foundation

// MARK: - Abstraction

/// abstraction for media that player can load and play
/// player will compose an `AVPlayerItem` for this media automatically
public protocol DarkRoomPlayerMedia: CustomStringConvertible {

    /// URL set to the `AVURLAsset`
    var url: URL { get }
    
    /// Asset options use by `AVURLAsset`
    var assetOptions: [String: Any]? { get }
}

public extension DarkRoomPlayerMedia {

    var description: String {
        return "url: \(url.description))"
    }
}

// MARK: - Implementation

public struct DarkRoomPlayerMediaImple: DarkRoomPlayerMedia {

    public let url: URL
    public let assetOptions: [String: Any]?

    public init(url: URL, assetOptions: [String: Any]? = nil) {
        self.url = url
        self.assetOptions = assetOptions
    }
}
