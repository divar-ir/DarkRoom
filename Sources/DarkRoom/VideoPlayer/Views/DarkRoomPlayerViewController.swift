
//  DarkRoomPlayerViewController.swift
//
//
//  Created by Kiarash Vosough on 7/8/22.
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
import AVFoundation
import Combine

// MARK: - Implementation

internal final class DarkRoomPlayerViewController: UIViewController, DarkRoomMediaController, UIGestureRecognizerDelegate {
    
    // MARK: - Transition Views
    
    // This image view is used when the transition is about to be performed
    internal var imageView: UIImageView { videoImageView }
    
    internal var imageOverlayView: UIImageView? { videoImageOverlayView }
    
    private var backgroundView: UIView? {
        guard let parent = parent as? DarkRoomCarouselViewController else { return nil }
        return parent.backgroundView
    }
    
    private var navBar: UINavigationBar? {
        guard let parent = parent as? DarkRoomCarouselViewController else { return nil }
        return parent.navBar
    }
    
    // MARK: - Views
    
    private lazy var loadingView: DarkRoomLoadingView = {
        let config = configuration.loadingViewConfiguration
        let view = DarkRoomLoadingView(colors: config.loadingViewColors, lineWidth: 10)
        view.backgroundColor = config.loadingViewBackgroundColor
        return view
    }()
    
    private lazy var videoView: DarkRoomPlayerView = DarkRoomPlayerView()
    
    private lazy var controlView: DarkRoomPlayerControlView = DarkRoomPlayerControlView(configuration: configuration.controlViewConfiguration)
    
    private lazy var videoImageView: UIImageView = UIImageView()
    
    private lazy var videoImageOverlayView: UIImageView = UIImageView()
    
    private lazy var gradientView: UIView = UIView()
    
    private var dismissPropertyAnimator: UIViewPropertyAnimator!
    
    private var controlViewBottomLayout: NSLayoutConstraint!

    private var stateBeforePan: DarkRoomPlayerStates?

    private var lastLocation: CGPoint

    private var panningViews: [UIView] {
        view.subviews.filter {
            $0 !== controlView && $0 !== gradientView
        }
    }

    // MARK: - DataSources
    
    private var isShowingControls: Bool {
        didSet {
            guard oldValue != isShowingControls else { return }
            changeControlsVisibilty(with: oldValue)
        }
    }
    
    private var panGestureStartPoint: CGPoint
    
    private var isAnimating: Bool
    
    internal var showsPlaybackControls: Bool {
        didSet {
            self.controlView.isHidden = showsPlaybackControls
        }
    }
    
    internal var videoContentMode: AVLayerVideoGravity {
        didSet {
            guard let playerLayer = videoView.layer as? AVPlayerLayer else { return }
            playerLayer.videoGravity = videoContentMode
        }
    }
    
    private var cancelables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Inputs
    
    internal let index: Int

    private let player: DarkRoomPlayerExposable

    private let imageLoader: DarkRoomImageLoader

    private let imagePlaceholder: UIImage?
    
    private let videoImageOverlayURL: URL?

    private let videoImageURL: URL?
    
    private var isFirstLoad: Bool
    
    private var configuration: DarkRoomVideoPlayerControllerConfiguration
    
    private var isViewOnScreen: Bool
    
    // MARK: - LifeCycle

    internal init(
        index: Int,
        videoImageURL: URL?,
        videoImageOverlayURL: URL?,
        imagePlaceholder: UIImage,
        imageLoader: DarkRoomImageLoader,
        player: DarkRoomPlayerExposable? = nil,
        configuration: DarkRoomVideoPlayerControllerConfiguration
    ) {
        self.index = index
        self.player = player != nil ? player! : DarkRoomPlayer()
        self.videoImageURL = videoImageURL
        self.videoImageOverlayURL = videoImageOverlayURL
        self.imagePlaceholder = imagePlaceholder
        self.imageLoader = imageLoader
        self.configuration = configuration
        self.panGestureStartPoint = .zero
        self.isAnimating = false
        self.showsPlaybackControls = true
        self.isShowingControls = true
        self.videoContentMode = .resizeAspect
        self.isFirstLoad = true
        self.isViewOnScreen = false
        self.lastLocation = .zero
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        player.pause()
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareImages()
        prepareControlView()
        prepareImageView()
        prepareVideoImageOverlayView()
        prepareVideoView()
        prepareActivityIndicator()
        setupBindigs()
        addGestureRecognizers()
        view.bringSubviewToFront(controlView)
        if configuration.isBottomShadowEnabled { setGradientView() }
    }

    internal override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isViewOnScreen = false
        if !isFirstLoad && player.state != .waitingForNetwork && player.state != .failed { player.pause() }
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isViewOnScreen = true
        if !isFirstLoad && player.state != .waitingForNetwork && player.state != .failed { player.play() }
    }
    
    internal override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLoad {
            self.loadingView.animateStroke()
            self.loadingView.animateRotation()
            isFirstLoad = false
        }
    }

    // MARK: - Prepare Views

    private func prepareView() {
        view.backgroundColor = .clear
    }

    func setGradientView(){
        view.addSubview(gradientView)
        gradientView.isUserInteractionEnabled = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "SmoothGradient"
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.3024).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        
        let bound = CGRect(
            origin: CGPoint(
                x: 0,
                y: view.bounds.maxY - 200
            ),
            size: CGSize(
                width: view.bounds.width,
                height: 200
            )
        )
        gradientLayer.frame = bound
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        view.bringSubviewToFront(gradientView)
    }

    private func prepareImages() {
        if let videoImageURL = videoImageURL {
            imageLoader.loadImage(videoImageURL, placeholder: self.imagePlaceholder, imageView: videoImageView) { [weak self] image in
                guard let self = self, let videoImageOverlayURL = self.videoImageOverlayURL, image != nil else { return }
                self.imageLoader.loadImage(videoImageOverlayURL, placeholder: nil, imageView: self.videoImageOverlayView) { _ in }
            }
        }
    }

    private func prepareVideoImageOverlayView() {
        videoImageOverlayView.contentMode = .scaleAspectFit
        videoImageOverlayView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.addSubview(videoImageOverlayView)
        
        NSLayoutConstraint.activate([
            videoImageOverlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoImageOverlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            videoImageOverlayView.widthAnchor.constraint(equalToConstant: 60),
            videoImageOverlayView.heightAnchor.constraint(equalTo: videoImageOverlayView.widthAnchor),
        ])
    }
    
    private func prepareImageView() {
        videoImageView.contentMode = .scaleAspectFit
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoImageView)
        
        NSLayoutConstraint.activate([
            videoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoImageView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    private func prepareControlView() {
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.isHidden = !showsPlaybackControls
        view.addSubview(controlView)

        controlViewBottomLayout = controlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        NSLayoutConstraint.activate([
            controlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            controlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            controlViewBottomLayout,
            controlView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func prepareActivityIndicator() {
        self.loadingView.isHidden = false
        self.loadingView.backgroundColor = configuration.loadingViewConfiguration.loadingViewBackgroundColor
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loadingView)

        NSLayoutConstraint.activate([
            self.loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.loadingView.widthAnchor.constraint(equalToConstant: 60),
            self.loadingView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func prepareVideoView() {
        videoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoView)
        
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        guard let videoLayer = videoView.layer as? AVPlayerLayer else { return }
        videoLayer.videoGravity = self.videoContentMode
        videoLayer.player = player.player
    }
    
    // MARK: - Bindings
    
    private func setupBindigs() {

        player.didItemPlayToEndTime
            .receiveOnMainQueue()
            .map { _ in self.configuration.controlViewConfiguration.playImage }
            .assign(to: \.buttonImage, on: self.controlView)
            .store(in: &self.cancelables)

        player.stateDidChange
            .receiveOnMainQueue()
            .filter { !self.isViewOnScreen && ($0 == .buffering || $0 == .playing) }
            .sink { _ in self.player.pause() }
            .store(in: &self.cancelables)

        player.stateDidChange
            .receiveOnMainQueue()
            .filter { state in state == .playing || state == .buffering  }
            .map { _ in self.configuration.controlViewConfiguration.pauseImage }
            .assign(to: \.buttonImage, on: self.controlView)
            .store(in: &self.cancelables)
        
        player.stateDidChange
            .receiveOnMainQueue()
            .filter { state in state != .playing && state != .buffering }
            .map { _ in self.configuration.controlViewConfiguration.playImage }
            .assign(to: \.buttonImage, on: self.controlView)
            .store(in: &self.cancelables)
        
        player.stateDidChange
            .receiveOnMainQueue()
            .filter { state in state == .playing }
            .filter { _ in self.videoImageView.isHidden == false }
            .sink { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.player.pause()
                strongSelf.videoImageOverlayView.isHidden = true
                
                UIView.animate(
                    withDuration: 0.20,
                    delay: 0,
                    options: [.curveEaseInOut]
                ) {
                    strongSelf.imageOverlayView?.alpha = 0
                }
                UIView.transition(
                    from: strongSelf.videoImageView,
                    to: strongSelf.videoView,
                    duration: 0.25,
                    options: [.transitionCrossDissolve, .curveLinear, .showHideTransitionViews]
                ) { [weak self] finished in
                    guard let strongSelf = self else { return }
                    if finished {
                        strongSelf.videoImageView.alpha = 0
                        strongSelf.view.bringSubviewToFront(strongSelf.controlView)
                        strongSelf.player.play()
                    }
                }
            }
            .store(in: &self.cancelables)
        
        player.stateDidChange
            .receiveOnMainQueue()
            .filter { $0 != .buffering && $0 != .playing && $0 != .paused && $0 != .stopped && self.loadingView.superview == nil }
            .sink { [weak self] showing in
                guard let strongSelf = self else { return }
                strongSelf.prepareActivityIndicator()
                strongSelf.loadingView.animateStroke()
                strongSelf.loadingView.animateRotation()
            }
            .store(in: &self.cancelables)
        
        player.stateDidChange
            .receiveOnMainQueue()
            .filter { $0 == .buffering && self.loadingView.superview == nil && self.player.bufferDuration < 5 }
            .receiveOnMainQueue()
            .sink { [weak self] showing in
                guard let strongSelf = self else { return }
                strongSelf.prepareActivityIndicator()
                strongSelf.loadingView.animateStroke()
                strongSelf.loadingView.animateRotation()
            }
            .store(in: &self.cancelables)
        
        player.stateDidChange
            .receiveOnMainQueue()
            .filter { $0 == .playing && self.loadingView.superview != nil  }
            .sink { [weak self] showing in
                guard let strongSelf = self else { return }
                strongSelf.loadingView.isHidden = false
                strongSelf.loadingView.removeFromSuperview()
                strongSelf.loadingView.removeAnimations()
            }
            .store(in: &self.cancelables)
        
        player.currentTimeDidChange
            .receiveOnMainQueue()
            .drop { _ in !self.isShowingControls }
            .map { (self.player.totalTime, $0) }
            .map { (totalTime, currentTime) in
                self.configuration.controlViewConfiguration.timeStatusConfiguration.timeFormatter.format(currentTime: currentTime, totalTime: totalTime)
            }
            .assign(to: \.timeLabelText, on: self.controlView)
            .store(in: &self.cancelables)

        player.currentTimeProgressDidChange
            .receiveOnMainQueue()
            .drop { _ in self.controlView.slider.isOnSliding || !self.isShowingControls }
            .assign(to: \.primaryProgressValue, on: self.controlView.slider)
            .store(in: &self.cancelables)

        player.itemBufferProgressDidChange
            .receiveOnMainQueue()
            .drop { _ in self.controlView.slider.isOnSliding || !self.isShowingControls }
            .assign(to: \.secondaryProgressValue, on: self.controlView.slider)
            .store(in: &self.cancelables)
        
        controlView.didPlayPauseButtonDidTouchUpInside
            .receiveOnMainQueue()
            .map { _ in self.player.isPlaying }
            .sink { [weak self] isPlaying in
                guard let strongSelf = self else { return }
                if isPlaying { strongSelf.player.pause() }
                else { strongSelf.player.play() }
            }
            .store(in: &self.cancelables)
        
        controlView
            .slider
            .sliderDidStartTrackingChanges
            .receiveOnMainQueue()
            .filter { _ in self.controlView.isSlidingEnabled }
            .sink { [weak self] sofarProgress in
                guard let strongSelf = self else { return }
                strongSelf.player.pause()
            }
            .store(in: &self.cancelables)
        
        player.stateDidChange
            .map { $0 == .waitingForNetwork || $0 == .failed ? false : true }
            .assign(to: \.isSlidingEnabled, on: controlView)
            .store(in: &self.cancelables)

        player.stateDidChange
            .map { $0 == .waitingForNetwork || $0 == .failed ? true : false }
            .sink { self.controlView.updateView(shouldRepresentError:  $0) }
            .store(in: &self.cancelables)
        
        controlView
            .slider
            .sliderDidEndTrackingChanges
            .receiveOnMainQueue()
            .filter { _ in self.controlView.isSlidingEnabled }
            .sink { [weak self] progress in
                guard let strongSelf = self else { return }
                let value = strongSelf.player.totalTime * progress
                strongSelf.player.seek(position: value)
                strongSelf.player.play()
            }
            .store(in: &self.cancelables)
    }
    
    private func getTimeString(seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
    internal func prepareForDismiss() {}
    
    // MARK: Gesture Recognizers
    
    private func addGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(didPan(_:))
        )
        panGesture.delegate = self
        panGesture.cancelsTouchesInView = false
        videoView.addGestureRecognizer(panGesture)

        let singleTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didSingleTap(_:))
        )
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        videoView.addGestureRecognizer(singleTapGesture)
    }
    
    private func prepareDismissPropertyAnimator() {
        dismissPropertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.videoImageView.alpha = 1
            self.videoImageOverlayView.alpha = 1
            self.videoView.alpha = 1
            self.backgroundView?.alpha = 0
            self.controlView.alpha = 0
            self.gradientView.alpha = 0
        }
    }
    
    @objc
    private func didSingleTap(_ recognizer: UITapGestureRecognizer) {
        self.isShowingControls.toggle()
    }
    
    private func changeControlsVisibilty(with isShowingControls: Bool) {
        UIView.animate(withDuration: 0.235, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.controlViewBottomLayout.constant = isShowingControls ? 100 : -10
            strongSelf.view.layoutIfNeeded()
            strongSelf.navBar?.alpha = isShowingControls ? 0.0 : 1.0
        }
    }
    
    private func calculateDismissAnimatorFraction(from startPoint: CGPoint, current point: CGPoint) -> CGFloat {
        let panAmunt = configuration.dismissPanAmount
        let diffY = startPoint.y - point.y
        return CGFloat(abs(diffY/panAmunt) <= 1 ? abs(diffY/70) : 1)
    }
    
    private func prepareImageViewsForDismssAnimation() {
        /// views become hidden when we perform transition
        self.videoImageOverlayView.isHidden = false
        self.videoImageView.isHidden = false
        self.view.bringSubviewToFront(self.videoImageView)
        self.videoImageView.bringSubviewToFront(self.videoImageOverlayView)
    }
    
    @objc
    private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard isAnimating == false else { return }

        if gestureRecognizer.state == .began {
            stateBeforePan = player.state
            player.pause()
            panGestureStartPoint = gestureRecognizer.translation(in: view)
            lastLocation = view.center
            prepareDismissPropertyAnimator()
        }

        if gestureRecognizer.state == .cancelled {
            panningViews.forEach {
                $0.center = lastLocation
            }
            panGestureStartPoint = .zero
            dismissPropertyAnimator.stopAnimation(false)
            dismissPropertyAnimator.finishAnimation(at: .start)
        }

        let translationInView: CGPoint = gestureRecognizer.translation(in: view)
        panningViews.forEach {
            $0.center = .init(
                x: lastLocation.x + translationInView.x,
                y: lastLocation.y + translationInView.y
            )
        }

        dismissPropertyAnimator.fractionComplete = calculateDismissAnimatorFraction(from: panGestureStartPoint, current: translationInView)

        if gestureRecognizer.state == .ended {
            if dismissPropertyAnimator.fractionComplete == 1 {
                self.player.pause()
                self.dismiss(animated: true)
            } else {
                panningViews.forEach {
                    $0.center = lastLocation
                }
                panGestureStartPoint = .zero
                dismissPropertyAnimator.stopAnimation(false)
                dismissPropertyAnimator.finishAnimation(at: .start)
                executeCancelAnimation()
            }
        }
    }

    internal func gestureRecognizerShouldBegin( _ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let velocity = panGesture.velocity(in: videoView)
        return abs(velocity.y) > abs(velocity.x)
    }

    private func executeCancelAnimation() {
        self.isAnimating = true
        UIView.animate(
            withDuration: 0.237,
            animations: {
                self.imageView.center = self.view.center
                self.backgroundView?.alpha = 1.0
            }
        ) { [weak self] _ in
            guard let strongSelf = self else { return }
            if strongSelf.stateBeforePan != .paused {
                strongSelf.player.play()
            }
            strongSelf.stateBeforePan = nil
            strongSelf.isAnimating = false
        }
    }
}
