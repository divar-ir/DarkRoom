//
//  DarkRoomPlayerSliderView.swift
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
import Combine

// MARK: - Publishers

internal protocol DarkRoomPlayerSliderViewDelegate: AnyObject {
    
    var sliderDidStartTrackingChanges: AnyPublisher<Double,Never> { get }
    
    var sliderIsTrackingChanges: AnyPublisher<Double,Never> { get }
    
    var sliderDidEndTrackingChanges: AnyPublisher<Double,Never> { get }
}

// MARK: - Implementation

internal final class DarkRoomPlayerSliderView: UIView, DarkRoomPlayerSliderViewDelegate, DarkRoomFailureRepresentableView {
    
    // MARK: - Variables
    
    private let sliderDidStartTrackingChangesSubject: PassthroughSubject<Double,Never>
    
    private let sliderIsTrackingChangesSubject: PassthroughSubject<Double,Never>
    
    private let sliderDidEndTrackingChangesSubject: PassthroughSubject<Double,Never>
    
    // MARK: - Output
    
    internal var sliderDidStartTrackingChanges: AnyPublisher<Double,Never> {
        sliderDidStartTrackingChangesSubject.share().eraseToAnyPublisher()
    }
    
    internal var sliderIsTrackingChanges: AnyPublisher<Double,Never> {
        sliderIsTrackingChangesSubject.share().eraseToAnyPublisher()
    }
    
    internal var sliderDidEndTrackingChanges: AnyPublisher<Double,Never> {
        sliderDidEndTrackingChangesSubject.share().eraseToAnyPublisher()
    }
    
    // MARK: - Views
    
    private lazy var thumbView = DarkRoomPlayerSliderThumbView(configuration: configuration.thumbViewConfiguration)
    
    private var progressBar = UIView()
    
    private var fractionBar = UIView()
    
    private var floatingAreaLayoutGuide = UILayoutGuide()
    
    private let primaryProgressLayer = CALayer()
    
    private let secondaryProgressLayer = CALayer()
    
    private var thumbConstraint: NSLayoutConstraint?

    private var barConstraint: NSLayoutConstraint?
    
    private var floatingLeading, floatingTrailing: NSLayoutConstraint?
    
    private let primaryProgressRedrawAnimationKey: String = "PrimaryProgressRedrawAnimation"

    private let secondaryProgressRedrawAnimationKey: String = "SecondaryProgressRedrawAnimation"
    
    // MARK: - View Properties
    
    internal var thumbSize: CGSize { thumbView.styledSize }
    
    internal var secondaryProgressValue: Double = 0.0 {
        didSet {
            if secondaryProgressValue != oldValue {
                updateSecondaryProgressLayer()
                setNeedsLayout()
            }
        }
    }

    internal var primaryProgressValue: Double = 0.0 {
        didSet {
            if primaryProgressValue != oldValue && primaryProgressValue <= 1 {
                updatePrimaryProgressLayer()
                setNeedsLayout()
            }
        }
    }
    
    internal var isOnSliding: Bool {
        self.thumbView.state == .highlighted
    }
    
    internal var isPrimaryProgressFinished: Bool {
        self.bounds.size.width * primaryProgressValue > self.bounds.size.width
    }
    
    internal var isSecondaryProgressFinished: Bool {
        self.bounds.size.width * secondaryProgressValue > self.bounds.size.width
    }
    
    internal var isSlidingEnabled: Bool = false
    
    // MARK: - Inputs
    
    internal let configuration: DarkRoomSliderViewConfiguration
    
    // MARK: - LifeCycle

    internal init(
        frame: CGRect,
        configuration: DarkRoomSliderViewConfiguration = DarkRoomSliderViewDefaultConfiguration()
    ) {
        self.sliderDidStartTrackingChangesSubject = PassthroughSubject<Double,Never>()
        self.sliderIsTrackingChangesSubject = PassthroughSubject<Double,Never>()
        self.sliderDidEndTrackingChangesSubject = PassthroughSubject<Double,Never>()
        self.configuration = configuration
        super.init(frame: frame)
        prepare()
    }
    
    internal convenience init(configuration: DarkRoomSliderViewConfiguration) {
        self.init(frame: .zero, configuration: configuration)
    }

    internal required init?(coder: NSCoder) {
        self.sliderDidStartTrackingChangesSubject = PassthroughSubject<Double,Never>()
        self.sliderIsTrackingChangesSubject = PassthroughSubject<Double,Never>()
        self.sliderDidEndTrackingChangesSubject = PassthroughSubject<Double,Never>()
        self.configuration = DarkRoomSliderViewDefaultConfiguration()
        super.init(coder: coder)
        prepare()
    }

    internal override func layoutSubviews() {
        super.layoutSubviews()
        floatingLeading?.constant = (thumbView.frame.width / 2)
        floatingTrailing?.constant = -(thumbView.frame.width) / 2
        setThumbConstraint()
        updatePrimaryProgressLayer()
        updateSecondaryProgressLayer()
    }

    // MARK: - Prepare Views

    private func prepare() {
        setupLayers()
        prepareBackgroundBar()
        prepareFloatingAreaLayoutGuide()
        prepareFractionBar()
        prepareThumbView()
        subviews.forEach { $0.isUserInteractionEnabled = false }
        self.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapOnProgressBar))
        )
        self.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(self.pans(_:)))
        )
    }

    private func prepareBackgroundBar() {
        progressBar.layer.cornerRadius = configuration.progressBarHeight / 2
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressBar)
        barConstraint = progressBar.heightAnchor.constraint(equalToConstant: configuration.progressBarHeight)
        NSLayoutConstraint.activate([
            progressBar.leftAnchor.constraint(equalTo: leftAnchor),
            progressBar.rightAnchor.constraint(equalTo: rightAnchor),
            progressBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            barConstraint!
        ])
    }

    private func prepareFractionBar() {
        fractionBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.addSubview(fractionBar)
        NSLayoutConstraint.activate([
            fractionBar.topAnchor.constraint(equalTo: progressBar.topAnchor),
            fractionBar.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor),
            fractionBar.rightAnchor.constraint(equalTo: progressBar.rightAnchor)
        ])
    }
    
    private func prepareThumbView() {
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thumbView)
        thumbConstraint = thumbView.centerXAnchor.constraint(equalTo: floatingAreaLayoutGuide.leftAnchor)
        NSLayoutConstraint.activate([
            thumbView.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            thumbView.centerXAnchor.constraint(equalTo: fractionBar.leftAnchor),
            thumbConstraint!
        ])
    }

    private func prepareFloatingAreaLayoutGuide() {
        addLayoutGuide(floatingAreaLayoutGuide)
        floatingLeading = floatingAreaLayoutGuide.leftAnchor.constraint(equalTo: progressBar.leftAnchor)
        floatingTrailing = floatingAreaLayoutGuide.rightAnchor.constraint(equalTo: progressBar.rightAnchor)
        NSLayoutConstraint.activate([
            floatingLeading!,
            floatingTrailing!,
            floatingAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            floatingAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setThumbConstraint() {
        progressBar.layoutIfNeeded()
        let constant = CGFloat(primaryProgressValue) * floatingAreaLayoutGuide.layoutFrame.width
        guard constant.isFinite && !constant.isNaN && constant < self.bounds.size.width else { return }
        thumbConstraint?.constant = constant
    }
    
    func updateView(shouldRepresentError: Bool) {
        self.isSlidingEnabled = shouldRepresentError == false
        self.thumbView.updateView(shouldRepresentError: shouldRepresentError)
        if isSlidingEnabled {
            self.progressBar.backgroundColor = configuration.progressBarBackgroundColor
            self.primaryProgressLayer.backgroundColor = configuration.primaryProgressColor?.cgColor
            self.secondaryProgressLayer.backgroundColor = self.configuration.secondaryProgressColor?.cgColor
        } else {
            self.progressBar.backgroundColor = configuration.errorColor
            self.primaryProgressLayer.backgroundColor = configuration.errorColor.cgColor
            self.secondaryProgressLayer.backgroundColor = configuration.errorColor.cgColor
        }
        setNeedsDisplay()
        layoutIfNeeded()
    }

    // MARK: - Control Tracking

    @objc private func didTapOnProgressBar(_ gestureRecognizer: UITapGestureRecognizer) {
        guard isSlidingEnabled else { return }
        self.sliderDidStartTrackingChangesSubject.send(primaryProgressValue)
        self.progressBar.layoutIfNeeded()
        let width = floatingAreaLayoutGuide.layoutFrame.width
        let newValue = gestureRecognizer.location(in: self).x / width
        self.primaryProgressValue = newValue
        self.sliderIsTrackingChangesSubject.send(newValue)
        self.sliderDidEndTrackingChangesSubject.send(primaryProgressValue)
    }

    private var previousPanGestureLocation: CGPoint?

    @objc private func pans(_ gesture: UIPanGestureRecognizer) {
        guard isSlidingEnabled else { return }
        switch gesture.state {
        case .began: self.handleBeginning(gesture)
        case .changed: self.handleChanging(gesture)
        case .ended: self.handleEnding(gesture)
        case .cancelled: self.handleCanceling(gesture)
        default: break
        }
    }
    
    private func handleBeginning(_ panGesture: UIPanGestureRecognizer) {
        let point = panGesture.location(in: self)
        guard self.thumbView.state == .normal, self.frame.contains(point) else { return }
        self.previousPanGestureLocation = panGesture.location(in: self)
        self.thumbView.state = .highlighted
        self.animateThumvViewTransform(to: CGAffineTransform(scaleX: 1.7, y: 1.7))
        self.sliderDidStartTrackingChangesSubject.send(primaryProgressValue)
    }
    
    private func handleChanging(_ panGesture: UIPanGestureRecognizer) {
        guard let previousPanGestureLocation = previousPanGestureLocation, thumbView.state == .highlighted else { return }
        progressBar.layoutIfNeeded()
        let width = floatingAreaLayoutGuide.layoutFrame.width
        let delta = -(previousPanGestureLocation.x - panGesture.location(in: self).x) / width
        let newValue = max(0, min(primaryProgressValue + delta, 1))
        self.primaryProgressValue = newValue
        self.sliderIsTrackingChangesSubject.send(newValue)
        self.previousPanGestureLocation = panGesture.location(in: self) // store location for next change
    }
    
    private func handleEnding(_ panGesture: UIPanGestureRecognizer) {
        guard self.thumbView.state == .highlighted else { return }
        self.thumbView.state = .normal
        self.updatePrimaryProgressLayer()
        self.animateThumvViewTransform(to: .identity)
        self.sliderDidEndTrackingChangesSubject.send(primaryProgressValue)
        self.previousPanGestureLocation = nil
    }
    
    private func animateThumvViewTransform(to transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut]) {
            self.thumbView.transform = transform
        } completion: { _ in }
    }
    
    private func handleCanceling(_ panGesture: UIPanGestureRecognizer) {
        guard self.thumbView.state == .highlighted else { return }
        self.thumbView.state = .normal
    }

    internal override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.thumbView.state == .highlighted { return false }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    // MARK: - Layers Configs

    private func setupLayers() {
        self.primaryProgressLayer.backgroundColor = configuration.primaryProgressColor?.cgColor
        self.secondaryProgressLayer.backgroundColor = self.configuration.secondaryProgressColor?.cgColor
        self.progressBar.backgroundColor = configuration.progressBarBackgroundColor
        self.secondaryProgressLayer.cornerRadius = configuration.progressBarHeight / 2
        self.primaryProgressLayer.cornerRadius = configuration.progressBarHeight / 2

        self.progressBar.layer.addSublayer(secondaryProgressLayer)
        self.progressBar.layer.addSublayer(primaryProgressLayer)
    }

    private func updatePrimaryProgressLayer() {
        guard !isPrimaryProgressFinished else { return }
    
        let progressbackgroundBarNewWidth = progressBar.bounds.size.width * primaryProgressValue

        let thumbAndLayerDelta = thumbView.frame.midX - progressbackgroundBarNewWidth

        let layerNewWidth = thumbAndLayerDelta > 0 ? progressbackgroundBarNewWidth + thumbAndLayerDelta : progressbackgroundBarNewWidth
        
        let progressRect = CGRect(
            origin: .zero,
            size: CGSize(
                width: layerNewWidth,
                height: progressBar.bounds.size.height
            )
        )
        
        guard !progressRect.containsNaNValuesInRect else { return }

        let redrawAnimation = CABasicAnimation(keyPath: "bounds")
        redrawAnimation.fromValue = primaryProgressLayer.bounds
        redrawAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        redrawAnimation.toValue = progressRect
        redrawAnimation.fillMode = .both
        redrawAnimation.isRemovedOnCompletion = false
        redrawAnimation.duration = 0.1

        self.primaryProgressLayer.bounds = progressRect
        self.primaryProgressLayer.position = CGPoint(x: 0, y: 0)
        self.primaryProgressLayer.anchorPoint = CGPoint(x: 0, y: 0)
        self.primaryProgressLayer.add(redrawAnimation, forKey: primaryProgressRedrawAnimationKey)

    }

    private func updateSecondaryProgressLayer() {
        guard !self.isSecondaryProgressFinished else { return }
        
        let progressbackgroundBarNewWidth = self.progressBar.bounds.size.width * self.secondaryProgressValue
        
        let progressRect = CGRect(
            origin: .zero,
            size: CGSize(
                width: progressbackgroundBarNewWidth,
                height: self.progressBar.bounds.size.height
            )
        )
        guard !progressRect.containsNaNValuesInRect else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            self.secondaryProgressLayer.bounds = progressRect
            self.secondaryProgressLayer.position = CGPoint(x: 0, y: 0)
            self.secondaryProgressLayer.anchorPoint = CGPoint(x: 0, y: 0)
        } completion: { _ in }
    }
}
