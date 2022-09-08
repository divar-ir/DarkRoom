//
//  DarkRoomCarouselViewController.swift
//
//
//  Created by Karo Sahafi on 11/15/21.
//
//  Copyright (c) 2022 Divar
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// A PageController class which is able to show image or video
public final class DarkRoomCarouselViewController: UIPageViewController {

    // MARK: - Dependencies

    /// Loading service for images
    private let imageLoader: DarkRoomImageLoader
    
    // MARK: - Delegates & DataSource
    
    public weak var mediaDatasource: DarkRoomCarouselDataSource?
    
    public weak var mediaDelegate: DarkRoomCarouselDelegate?

    // MARK: - Variables
    
    private let initialIndex: Int
    
    private var displayedIndex: Int {
        didSet {
            guard oldValue != displayedIndex else { return }
            let oldSourceView = mediaDatasource?.imageView(at: oldValue)
            oldSourceView?.alpha = 1.0
            mediaDelegate?.carousel(didSlideToIndex: displayedIndex)
            sourceView?.alpha = 0.0
        }
    }
    
    // MARK: - Views
    
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    internal private(set) lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar(frame: .zero)
        navBar.overrideUserInterfaceStyle = .dark
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.isTranslucent = true
        navBar.barTintColor = .clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        return navBar
    }()
    
    internal private(set) lazy var backgroundView: UIView? = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 1.0
        return view
    }()
    
    private lazy var navItem: UINavigationItem = UINavigationItem()
    
    private lazy var imageViewerPresentationDelegate: DarkRoomTransitionPresentationManager = DarkRoomTransitionPresentationManager()
    
    // MARK: - Inputs
    
    private var configuration: DarkRoomCarouselConfiguration
    
    // MARK: - LifeCycle
    
    public init(
        imageDataSource: DarkRoomCarouselDataSource? = nil,
        imageDelegate: DarkRoomCarouselDelegate? = nil,
        imageLoader: DarkRoomImageLoader,
        initialIndex: Int = 0,
        configuration: DarkRoomCarouselConfiguration = DarkRoomCarouselDefaultConfiguration()
    ) {
        self.initialIndex = initialIndex
        self.displayedIndex = initialIndex
        self.mediaDatasource = imageDataSource
        self.mediaDelegate = imageDelegate
        self.imageLoader = imageLoader
        self.configuration = configuration
        let pageOptions = [UIPageViewController.OptionsKey.interPageSpacing: 20]

        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: pageOptions)
        
        transitioningDelegate = imageViewerPresentationDelegate
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        sourceView?.alpha = 1.0
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackgroundView()
        prepareNavBar()
        applyOptions()
        setupPagingController()
        setupInitialDataSource()
    }
    
    // MARK: - Prepare Views
    
    private func prepareNavBar() {
        let closeBarButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        closeBarButton.backgroundColor = .black.withAlphaComponent(0.5)
        closeBarButton.layer.cornerRadius = closeBarButton.bounds.width/2
        closeBarButton.setImage(DarkRoomAsset.Images.close.image, for: .normal)
        closeBarButton.tintColor = .white
        closeBarButton.addTarget(self, action: #selector(self.dismissCarousel), for: .primaryActionTriggered)
        
        navItem.leftBarButtonItem = UIBarButtonItem(customView: closeBarButton)
        navBar.alpha = 1.0
        navBar.items = [navItem]
        navBar.insert(to: view)
    }
    
    private func prepareBackgroundView() {
        guard let backgroundView = backgroundView else { return }
        view.addSubview(backgroundView)
        backgroundView.bindFrameToSuperview()
        view.sendSubviewToBack(backgroundView)
    }
    
    private func applyOptions() {
        configuration.navigationItemOptions.forEach {
            switch $0 {
            case .closeIcon(let icon):
                navItem.leftBarButtonItem?.image = icon
            case .rightNavItemTitle(let title):
                navItem.rightBarButtonItem = UIBarButtonItem(
                    title: title,
                    style: .plain,
                    target: self,
                    action: #selector(didTapRightNavBarItem(_:)))
            case .rightNavItemIcon(let icon):
                navItem.rightBarButtonItem = UIBarButtonItem(
                    image: icon,
                    style: .plain,
                    target: self,
                    action: #selector(didTapRightNavBarItem(_:)))
            }
        }
    }
    
    private func setupPagingController() {
        dataSource = self
        delegate = self
    }
    
    private func setupInitialDataSource() {
        guard let mediaDatasource = mediaDatasource else { return }
        
        if case .video(let data) = mediaDatasource.assetData(at: initialIndex) {
            let initialVC = composePlayerViewController(with: initialIndex, data: data, imageLoader: imageLoader)
            setViewControllers([initialVC], direction: .forward, animated: true)
        } else if case .image(let data) = mediaDatasource.assetData(at: initialIndex) {
            let initialVC = composeImageViewerController(with: initialIndex, data: data, imageLoader: imageLoader)
            setViewControllers([initialVC], direction: .forward, animated: true)
        }
    }
    
    // MARK: - Targets

    @objc
    public func dismissCarousel() {
        let displaedViewController = viewControllers?.first as? DarkRoomMediaController
        displaedViewController?.prepareForDismiss()
        dismissMe(completion: nil)
    }
    
    private func dismissMe(completion: (() -> Void)? = nil) {
        sourceView?.alpha = 1.0
        UIView.animate(withDuration: 0.235, animations: {
            self.view.alpha = 0.0
        }) { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    @objc
    private func didTapRightNavBarItem(_ sender: UIBarButtonItem) {
        guard let firstVC = viewControllers?.first as? DarkRoomMediaController else { return }
        mediaDelegate?.carousel(didTapedBarButtonItem: sender, index: firstVC.index)
    }
}

// MARK: UIPageViewController DataSource

extension DarkRoomCarouselViewController: UIPageViewControllerDataSource {

    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard let vc = viewController as? DarkRoomMediaController else { return nil }
        guard let mediaDatasource = mediaDatasource else { return nil }
        guard vc.index > 0 else { return nil }
        
        let newIndex = vc.index - 1
        let imageLoader = self.imageLoader

        if case .video(let data) = mediaDatasource.assetData(at: newIndex) {
            return composePlayerViewController(with: newIndex, data: data, imageLoader: imageLoader)
        } else if case .image(let data) = mediaDatasource.assetData(at: newIndex) {
            return composeImageViewerController(with: newIndex, data: data, imageLoader: imageLoader)
        } else {
            return nil
        }
    }

    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard let vc = viewController as? DarkRoomMediaController else { return nil }
        guard let mediaDatasource = mediaDatasource else { return nil }
        guard vc.index <= (mediaDatasource.numberOfAssets() - 2) else { return nil }

        let newIndex = vc.index + 1
        let imageLoader = self.imageLoader

        if case .video(let data) = mediaDatasource.assetData(at: newIndex) {
            return composePlayerViewController(with: newIndex, data: data, imageLoader: imageLoader)
        } else if case .image(let data) = mediaDatasource.assetData(at: newIndex) {
            return composeImageViewerController(with: newIndex, data: data, imageLoader: imageLoader)
        } else {
            return nil
        }
    }
    
    private func composeImageViewerController(with index: Int, data: DarkRoomCarouselImageData, imageLoader: DarkRoomImageLoader) -> UIViewController  {
        return DarkRoomImageViewerController(
            index: index,
            imageURL: data.imageUrl,
            imagePlaceholder: data.imagePlaceholder,
            imageLoader: imageLoader
        )
    }
    
    private func composePlayerViewController(with index: Int, data: DarkRoomCarouselVideoData, imageLoader: DarkRoomImageLoader) -> UIViewController {
        let player = DarkRoomPlayer()
        let mediaItem = DarkRoomPlayerMediaImple(url: data.videoUrl)
        let initialVC = DarkRoomPlayerViewController(
            index: index,
            videoImageURL: data.videoImageUrl,
            videoImageOverlayURL: data.overlayURL,
            imagePlaceholder: data.imagePlaceholder,
            imageLoader: imageLoader,
            player: player,
            configuration: configuration.videoPlayerControllerConfiguration
        )

        player.load(media: mediaItem, autostart: true, position: 0)
        return initialVC
    }
}

// MARK: UIPageViewControllerDelegate

extension DarkRoomCarouselViewController: UIPageViewControllerDelegate {

    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed, let presentedViewController = self.viewControllers?.first as? DarkRoomMediaController {
            self.displayedIndex = presentedViewController.index
        }
    }
}

// MARK: - DarkRoomTransitionViewControllerConvertible

extension DarkRoomCarouselViewController: DarkRoomTransitionViewControllerConvertible {
    
    // MARK: - Transition Views
    
    public var sourceView: UIImageView? {
        return mediaDatasource?.imageView(at: displayedIndex)
    }
    
    public var sourceOverlayView: UIImageView? {
        mediaDatasource?.overlayImageView(at: displayedIndex)
    }

    public var targetView: UIImageView? {
        guard let vc = viewControllers?.first as? DarkRoomMediaController else {
            return nil
        }
        return vc.imageView
    }
    
    public var targetOverlayView: UIImageView? {
        guard let vc = viewControllers?.first as? DarkRoomMediaController else {
            return nil
        }
        return vc.imageOverlayView
    }
}

