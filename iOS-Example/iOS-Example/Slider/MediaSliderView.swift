//
//  MediaSliderView.swift
//  IOS-Example
//
//  Created by Kiarash Vosough on 7/26/22.
//

// MARK: - Implementation

import UIKit
import DarkRoom

final class MediaSlider: UIView {
    
    private var collectionView: UICollectionView!
    
    private var ratioConstraint: NSLayoutConstraint!
    
    private let ImageCellIdentifier = "MediaSliderImageCell"
    private let VideoCellIdentifier = "MediaSliderVideoCell"
    
    private var vc: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    var videoContentMode: ContentMode = .scaleAspectFill {
        didSet {
            collectionView
                .visibleCells
                .compactMap { $0 as? MediaSliderVideoCell }
                .forEach { cell in cell.contentMode = imageContentMode }
        }
    }
    
    var imageContentMode: ContentMode = .scaleAspectFill {
        didSet {
            collectionView
                .visibleCells
                .compactMap { $0 as? MediaSliderImageCell }
                .forEach { cell in cell.contentMode = imageContentMode }
        }
    }
    
    private var hasBadge: Bool {
        return assets.count >= 2
    }
    
    private var hasIndicator: Bool {
        return assets.count >= 2
    }
    
    var assets: [MediaSliderData] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero)
        prepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepare()
    }
    
    required  init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    private func prepare() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.register(MediaSliderImageCell.self, forCellWithReuseIdentifier: ImageCellIdentifier)
        collectionView.register(MediaSliderVideoCell.self, forCellWithReuseIdentifier: VideoCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.alwaysBounceHorizontal = assets.count > 1
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPrefetchingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.scrollIndicatorInsets = .zero
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension MediaSlider: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        max(assets.count, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if assets.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellIdentifier, for: indexPath) as! MediaSliderImageCell
            cell.image = AssetExtractor.createLocalUrl(forImageNamed: "no_thumb_high_res")
            return cell
        } else {
            let item = assets[indexPath.row]
            
            switch item {
            case let .image(data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellIdentifier, for: indexPath) as! MediaSliderImageCell
                cell.imageView.backgroundColor = data.imageBackgroundColor
                cell.backgroundColor = data.imageBackgroundColor
                cell.clipsToBounds = true
                cell.image = data.imageUrl
                cell.imageContentMode = imageContentMode
                return cell
            case let .video(data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCellIdentifier, for: indexPath) as! MediaSliderVideoCell
                cell.imageView.backgroundColor = data.imageBackgroundColor
                cell.backgroundColor = data.imageBackgroundColor
                cell.clipsToBounds = true
                cell.image = data.videoImageUrl
                cell.playImage = AssetExtractor.createLocalUrl(forImageNamed: "play_button")
                cell.imageContentMode = videoContentMode
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let carouselController = DarkRoomCarouselViewController(
            imageDataSource: self,
            imageDelegate: self,
            imageLoader: ImageLoaderImpl(),
            initialIndex: indexPath.row,
            configuration: DarkRoomCarouselDefaultConfiguration()
        )
        
        vc?.present(carouselController, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.width * 1)
    }
}

// MARK: - MediaViewer Delegate

extension MediaSlider: DarkRoomCarouselDelegate {
    func carousel(didSlideToIndex index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionView.isPagingEnabled = true
        collectionView.layoutIfNeeded()
    }
}

// MARK: - MediaViewer DataSource

extension MediaSlider: DarkRoomCarouselDataSource {
    
    func assetData(at index: Int) -> DarkRoomCarouselData {
        switch assets[index] {
        case let .image(data): return .image(data: data)
        case let .video(data): return .video(data: data)
        }
    }

    func numberOfAssets() -> Int {
        assets.count
    }

    func imageView(at index: Int) -> UIImageView? {
        var imageView: UIImageView!
        
        if let currentCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MediaSliderImageCell {
            imageView = currentCell.imageView
        } else if let currentCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MediaSliderVideoCell {
            imageView = currentCell.imageView
        }
        return imageView
    }
    
    func overlayImageView(at index: Int) -> UIImageView? {
        guard let currentCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MediaSliderVideoCell else { return nil }
        return currentCell.playImageView
    }
}
