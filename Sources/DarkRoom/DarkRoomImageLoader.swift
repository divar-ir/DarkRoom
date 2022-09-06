//
//  DarkRoomDummyImageCreator.swift
//
//
//  Created by Karo Sahafi on 11/15/21.
//

import UIKit

/// Abstracted service for loading images on Darkroom package
/// Users can define their own strategy for loading image's url
public protocol DarkRoomImageLoader {
    func loadImage(_ url: URL, placeholder: UIImage?, imageView: UIImageView, completion: @escaping (_ image: UIImage?) -> Void)
}
