//
//  DarkRoomAssetResourceLoaderConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 7/22/22.
//

import Foundation

/*
 Usage of AssetResourceLoading is suspended for now,
 but the abstraction and support for using it is stil retained.
 users can implement their own way of handling request by the API we provided
 */

// MARK: - Abstraction

public protocol DarkRoomAssetResourceLoaderConfiguration {
    var dataBufferSize: DarkRoomByteCount { get }
    var assetLoadingRequestTimeout: TimeInterval { get }
}
