//
//  ViewController.swift
//  IOS-Example
//
//  Created by Kiarash Vosough on 7/26/22.
//

import UIKit
import DarkRoom

final class ViewController: UIViewController {

    // MARK: - Views

    private lazy var mediaView: MediaSlider = {
        let view = MediaSlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - DataSource
    
    private let assetArray: [String: String] = [
        "video": "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-Video-File-For-Testing.mp4",
        "image1": "https://i.picsum.photos/id/1058/1200/900.jpg?hmac=cm8n-rQbkPLBiT-F9TWELkZj_RtJyQBEEhrKcBldtOI",
        "image2": "https://i.picsum.photos/id/871/1200/900.jpg?hmac=z701z-qF0R8Mooo9zj1jQO84reyZXwXAFrwZkMiHKQ8",
        "image3": "https://i.picsum.photos/id/834/1200/600.jpg?hmac=AnIkKiZYE17bHrposiF5MuNjohZH4LseNGIEmDbmTso",
        "image4": "https://i.picsum.photos/id/1028/600/1200.jpg?hmac=j1jMjdpJttfEe3cj7Wa1LRKfFKJs6upd1nBnPDfa9kU",
    ]
    
    
    var assets: [MediaSliderData] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        setupOpenCarousellButten()
        loadAssets()
    }
    
    private func prepareView() {
        view.backgroundColor = .white
    }
    
    private func setupOpenCarousellButten() {
        view.addSubview(mediaView)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: mediaView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: mediaView.centerYAnchor),
            view.rightAnchor.constraint(equalTo: mediaView.rightAnchor),
            view.leftAnchor.constraint(equalTo: mediaView.leftAnchor),
            mediaView.heightAnchor.constraint(equalTo: mediaView.widthAnchor, multiplier: 1)
        ])
    }
    
    var placeholderImage: UIImage {
        let url = AssetExtractor.createLocalUrl(forImageNamed: "no_thumb_high_res")!
        return ImageLoaderImpl().loadImage(url)!
    }
    
    private func loadAssets() {
        mediaView.assets = assetArray.compactMap { key, value in
            if key.contains("image") {
                return .image(data:
                                
                                MediaSliderImageData(imagePlaceholder: placeholderImage,
                                                     imageUrl: URL(string: value)!,
                                                     imageBackgroundColor: .white,
                                                     imageDescription: "")
                )
            } else if key.contains("video") {
                return .video(data:
                                MediaSliderVideoData(overlayURL: AssetExtractor.createLocalUrl(forImageNamed: "play_button"),
                                                     imagePlaceholder: placeholderImage,
                                                     videoImageUrl: AssetExtractor.createLocalUrl(forImageNamed: "video_first_image")!,
                                                     videoUrl: URL(string: value)!,
                                                     imageBackgroundColor: .white,
                                                     imageDescription: "")
                )
            } else {
                return nil
            }
        }
    }
}
