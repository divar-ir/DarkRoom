//
//  DarkRoomAssetResourceLoaderService.swift
//  
//
//  Created by Kiarash Vosough on 7/15/22.
//

import AVFoundation

/*
 Usage of AssetResourceLoading is suspended for now,
 but the abstraction and support for using it is stil retained.
 users can implement their own way of handling request by the API we provided
 */

// MARK: - Abstraction

public protocol DarkRoomAssetResourceLoaderService {
    
    func startLoadingResources(for media: DarkRoomPlayerMedia) throws
    
    func shouldWaitForLoading(of request: AVAssetResourceLoadingRequest) -> Bool
    
    func cancel(loadingRequest: AVAssetResourceLoadingRequest)
}
