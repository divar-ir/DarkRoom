//
//  ImageSliderCell.swift
//  
//
//  Created by Kiarash Vosough on 7/9/22.
//

import UIKit

class MediaSliderImageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
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
    
    var imageContentMode: ContentMode = .scaleAspectFill {
        didSet {
            imageView.contentMode = imageContentMode
            imageView.setNeedsDisplay(frame)
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
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.loaders.cancelAllImageLoading()
        self.imageView.image = nil
        self.image = nil
    }
}
