//
//  MediaSliderVideoCell.swift
//  
//
//  Created by Kiarash Vosough on 7/9/22.
//

import UIKit

class MediaSliderVideoCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var playImageView: UIImageView!
    
    var loaders: [ImageLoaderCancelable] = []
    
    var image: URL? = nil {
        didSet {
            guard let image = image else { return }
            let loader = ImageLoaderImpl()
            loader.loadImage(image, placeholder: UIImage(named: "no_thumb_high_res"), imageView: imageView, completion: { _ in })
            loaders.append(
                loader
            )
        }
    }
    
    var playImage: URL? = nil {
        didSet {
            guard let playImage = playImage else { return }
            let loader = ImageLoaderImpl()
            loader.loadImage(playImage, placeholder: UIImage(named: "no_thumb_high_res"), imageView: playImageView, completion: { _ in })
            loaders.append(
                loader
            )
        }
    }
    
    var imageContentMode: ContentMode = .scaleAspectFill {
        didSet {
            imageView.contentMode = imageContentMode
            imageView.setNeedsDisplay(frame)
            
            playImageView.contentMode = imageContentMode
            playImageView.setNeedsDisplay(frame)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        setupImageView()
        setupPlayImageView()
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "no_thumb_high_res")
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupPlayImageView() {
        playImageView = UIImageView(frame: frame)
        playImageView.translatesAutoresizingMaskIntoConstraints = false
        
        playImageView.image = UIImage(named: "play_button")
        
        addSubview(playImageView)
        
        NSLayoutConstraint.activate([
            playImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            playImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            playImageView.widthAnchor.constraint(equalToConstant: 60),
            playImageView.heightAnchor.constraint(equalTo: playImageView.widthAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.loaders.cancelAllImageLoading()
        imageView.image = nil
        playImageView.image = nil
        image = nil
        playImage = nil
    }
}
