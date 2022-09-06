//
//  DarkRoomPlayerItemInitService.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
//

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
