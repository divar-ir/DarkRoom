//
//  DarkRoomPlayerMedia.swift
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
