//
//  DarkRoomCarouselDataSource.swift
//  
//
//  Created by Kiarash Vosough on 7/31/22.
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

import UIKit

/// DataSource for ``DarkRoomCarouselViewController``
public protocol DarkRoomCarouselDataSource: AnyObject {
    
    /// Indicates the number of media which ``DarkRoomCarouselViewController`` should display
    func numberOfAssets() -> Int
    
    func assetData(at index: Int) -> DarkRoomCarouselData
    
    /// In case of using transition between controller and ``DarkRoomCarouselViewController``
    ///  the source imageview is needed to perform transition animations
    /// - Parameter index: The index of the media which is about to load and need to be animated on transition
    /// - Returns: The ImageView which will be animated to show on the carousel
    func imageView(at index: Int) -> UIImageView?
    
    /// In case of using transition between controller and ``DarkRoomCarouselViewController``
    ///  the source overlayimageview is needed to perform transition animations
    /// This feature is now work just with video media
    /// Overlays are not mandatory to provide, it will be placed on the source ImageView as a complementary view
    /// - Parameter index: The index of the media which is about to load and need to be animated on transition
    /// - Returns: The overlayImageView which will be animated to show on the carousel
    func overlayImageView(at index: Int) -> UIImageView?
}

/// Optional methods
extension DarkRoomCarouselDataSource {

    func overlayImageView(at index: Int) -> UIImageView? { nil }
}
