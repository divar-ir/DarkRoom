//
//  DarkRoomPlayerItemInitService.swift
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

public protocol DarkRoomPlayerItemInitService {
    func getItem(
        media: DarkRoomPlayerMedia,
        assetResourceLoaderDelegate: AVAssetResourceLoaderDelegate?,
        loadedAssetKeys: [String]
    ) -> AVPlayerItem
}

// MARK: - Implementation

internal struct DarkRoomPlayerItemInitServiceImpl: DarkRoomPlayerItemInitService {

    internal init() {}
    
    // MARK: - Output

    internal func getItem(
        media: DarkRoomPlayerMedia,
        assetResourceLoaderDelegate: AVAssetResourceLoaderDelegate?,
        loadedAssetKeys: [String]
    ) -> AVPlayerItem {

        if let mediaItem = media as? DarkRoomPlayerMediaItem {
            setResourceLoaderDelegateIfPossible(on: mediaItem.item.asset, delegate: assetResourceLoaderDelegate)
            return mediaItem.item
        } else {

            let asset = AVURLAsset(url: media.url, options: media.assetOptions)
            setResourceLoaderDelegateIfPossible(on: asset, delegate: assetResourceLoaderDelegate)
            return AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: loadedAssetKeys)
        }
    }
    
    private func setResourceLoaderDelegateIfPossible(on asset: AVAsset, delegate: AVAssetResourceLoaderDelegate?) {
        guard let asset = asset as? AVURLAsset,
           let delegate = delegate,
           self.canUseInternalAssetLoader(on: asset),
           self.canUseAssetLoader(for: asset)
        else { return }
        asset.resourceLoader.setDelegate(delegate, queue: .main)
    }
    
    private func canUseInternalAssetLoader(on asset: AVURLAsset) -> Bool {
        return asset.resourceLoader.delegate == nil
    }
    
    private func canUseAssetLoader(for asset: AVURLAsset) -> Bool {
        return asset.url.isFileURL || asset.url.pathExtension == "m3u8" ? false : true
    }
}
