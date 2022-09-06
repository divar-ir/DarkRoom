//
//  ImageLoader.swift
//  IOS-Example
//
//  Created by Kiarash Vosough on 7/26/22.
//

import UIKit
import DarkRoom

protocol ImageLoaderCancelable: AnyObject {
    func cancel()
}

class ImageLoaderImpl: DarkRoomImageLoader, ImageLoaderCancelable {

    var task: URLSessionDataTask?

    
    func loadImage(_ url: URL) -> UIImage? {
        guard url.isFileURL else { return nil }
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return nil }
        return image
    }
    
    
    func loadImage(_ url: URL, placeholder: UIImage?, imageView: UIImageView, completion: @escaping (UIImage?) -> Void) {
        if url.isFileURL {
            guard
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async { [weak imageView] in
                    imageView?.image = placeholder
                }
                return
            }
            DispatchQueue.main.async { [weak imageView] in
                imageView?.image = image
                completion(image)
            }
        } else {
            task = URLSession.shared.dataTask(with: url) { [weak imageView] data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async { [weak imageView] in
                        imageView?.image = placeholder
                    }
                    return
                    
                }
                DispatchQueue.main.async {
                    imageView?.image = image
                    completion(image)
                }
            }
            task?.resume()
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}

extension Array where Element == ImageLoaderCancelable {
    func cancelAllImageLoading() {
        self.forEach { $0.cancel() }
    }
}
