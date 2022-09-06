//
//  DarkRoomAssetResourceLoaderRequest.swift
//  
//
//  Created by Kiarash Vosough on 7/14/22.
//

import Foundation
import AVFoundation

/*
 Usage of AssetResourceLoading is suspended for now,
 but the abstraction and support for using it is stil retained.
 users can implement their own way of handling request by the API we provided
 */

// MARK: - Abstraction

/// abstraction for ``AVAssetResourceLoadingRequest`` componnent to process it in isolation and have full control of start responding to ``AVAssetResourceLoadingRequest`` or finish it.
public protocol DarkRoomAssetResourceLoaderRequest: AnyObject {
    
    var request: AVAssetResourceLoadingRequest { get }

    func prepareForRetry() throws
    
    func start()
    
    func cancel()
    
    func finish()
}

// MARK: - Delegate

public protocol DarkRoomVideoLoadingRequestDelegate: AnyObject {
    
    func videoRequest(
        _ request: DarkRoomAssetResourceLoaderRequest,
        didFinish loadingRequest: AVAssetResourceLoadingRequest,
        with error: Error?
    )
}
