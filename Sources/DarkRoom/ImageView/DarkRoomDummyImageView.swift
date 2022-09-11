//
//  DummyImageView.swift
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

internal final class DarkRoomDummyImageView: UIView {

    internal var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    internal var overlayImage: UIImage? {
        get { return overlayImageView?.image }
        set { overlayImageView?.image = newValue }
    }

    internal var highlightedImage: UIImage? {
        get { return imageView.highlightedImage }
        set { imageView.highlightedImage = newValue }
    }

    internal var isHighlighted: Bool {
        get { return imageView.isHighlighted }
        set { imageView.isHighlighted = newValue }
    }

    internal var animationImages: [UIImage]? {
        get { return imageView.animationImages }
        set { imageView.animationImages = newValue }
    }

    internal var highlightedAnimationImages: [UIImage]? {
        get { return imageView.highlightedAnimationImages }
        set { imageView.highlightedAnimationImages = newValue }
    }

    internal var animationDuration: TimeInterval {
        get { return imageView.animationDuration }
        set { imageView.animationDuration = newValue }
    }

    internal var animationRepeatCount: Int {
        get { return imageView.animationRepeatCount }
        set { imageView.animationRepeatCount = newValue }
    }

    internal override var tintColor: UIColor! {
        get { return imageView.tintColor }
        set { imageView.tintColor = newValue }
    }

    internal func startAnimating() {
        imageView.startAnimating()
    }

    internal func stopAnimating() {
        imageView.stopAnimating()
    }

    internal var isAnimating: Bool {
        return imageView.isAnimating
    }

    private let imageView: UIImageView

    private let overlayImageView: UIImageView?
    
    internal init(image: UIImage?, overlayImage: UIImage? = nil) {
        imageView = UIImageView(image: image)
        overlayImageView = overlayImage != nil ? UIImageView(image: overlayImage) : nil
        super.init(frame: .zero)
        addSubview(imageView)
        overlayImageView.onValuePresent { addSubview($0) }
    }

    internal init(image: UIImage?, highlightedImage: UIImage?, overlayImage: UIImage? = nil) {
        imageView = UIImageView(image: image, highlightedImage: highlightedImage)
        overlayImageView = overlayImage != nil ? UIImageView(image: overlayImage) : nil
        super.init(frame: .zero)
        addSubview(imageView)
        overlayImageView.onValuePresent { addSubview($0) }
    }

    internal required init?(coder aDecoder: NSCoder) {
        imageView = UIImageView(image: nil)
        overlayImageView = UIImageView(image: nil)
        super.init(coder: aDecoder)
        addSubview(imageView)
    }

    internal override func layoutSubviews() {
        super.layoutSubviews()
        layoutImageView()
    }

    internal override var contentMode: UIView.ContentMode {
        didSet { layoutImageView() }
    }

    private func layoutImageView() {

        guard let image = imageView.image else { return }

        // MARK: - Layout Helpers
        func imageToBoundsWidthRatio(image: UIImage) -> CGFloat             { image.size.width / bounds.size.width }
        func imageToBoundsHeightRatio(image: UIImage) -> CGFloat            { image.size.height / bounds.size.height }
        func centerImageViewToPoint(imageView: UIImageView, point: CGPoint) { imageView.center = point }
        func imageViewBoundsToImageSize(imageView: UIImageView)             { imageViewBoundsToSize(imageView: imageView, size: image.size) }
        func imageViewBoundsToSize(imageView: UIImageView, size: CGSize)    { imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height) }
        func centerImageView(imageView: UIImageView)                        { imageView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2) }

        // MARK: - Layouts
        func layoutAspectFit() {
            let widthRatio = imageToBoundsWidthRatio(image: image)
            let heightRatio = imageToBoundsHeightRatio(image: image)
            imageViewBoundsToSize(
                imageView: imageView,
                size: CGSize(
                    width: image.size.width / max(widthRatio, heightRatio),
                    height: image.size.height / max(widthRatio, heightRatio)
                )
            )
            centerImageView(imageView: imageView)
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutAspectFill() {
            let widthRatio = imageToBoundsWidthRatio(image: image)
            let heightRatio = imageToBoundsHeightRatio(image: image)
            imageViewBoundsToSize(
                imageView: imageView,
                size: CGSize(
                    width: image.size.width /  min(widthRatio, heightRatio),
                    height: image.size.height / min(widthRatio, heightRatio)
                )
            )
            centerImageView(imageView: imageView)
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutFill() {
            imageViewBoundsToSize(imageView: imageView, size: CGSize(width: bounds.size.width, height: bounds.size.height))
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutCenter() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageView(imageView: imageView)
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutTop() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageViewToPoint(imageView: imageView, point: CGPoint(x: bounds.size.width / 2, y: image.size.height / 2))
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutBottom() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageViewToPoint(imageView: imageView, point: CGPoint(x: bounds.size.width / 2, y: bounds.size.height - image.size.height / 2))
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutLeft() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageViewToPoint(imageView: imageView, point: CGPoint(x: image.size.width / 2, y: bounds.size.height / 2))
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutRight() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageViewToPoint(imageView: imageView, point: CGPoint(x: bounds.size.width - image.size.width / 2, y: bounds.size.height / 2))
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutTopLeft() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageViewToPoint(imageView: imageView, point: CGPoint(x: image.size.width / 2, y: image.size.height / 2))
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutTopRight() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageViewToPoint(imageView: imageView, point: CGPoint(x: bounds.size.width - image.size.width / 2, y: image.size.height / 2))
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutBottomLeft() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageViewToPoint(imageView: imageView, point: CGPoint(x: image.size.width / 2, y: bounds.size.height - image.size.height / 2))
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        func layoutBottomRight() {
            imageViewBoundsToImageSize(imageView: imageView)
            centerImageViewToPoint(
                imageView: imageView,
                point: CGPoint(
                    x: bounds.size.width - image.size.width / 2,
                    y: bounds.size.height - image.size.height / 2
                )
            )
            
            self.overlayImageView
                .combine(\.image)
                .onValuePresent { (imageView, image) in
                    imageViewBoundsToSize(
                        imageView: imageView,
                        size: CGSize(
                            width: 60,
                            height: 60
                        )
                    )
                    centerImageView(imageView: imageView)
                }
        }

        switch contentMode {
        case .scaleAspectFit:  layoutAspectFit()
        case .scaleAspectFill: layoutAspectFill()
        case .scaleToFill:     layoutFill()
        case .redraw:          break;
        case .center:          layoutCenter()
        case .top:             layoutTop()
        case .bottom:          layoutBottom()
        case .left:            layoutLeft()
        case .right:           layoutRight()
        case .topLeft:         layoutTopLeft()
        case .topRight:        layoutTopRight()
        case .bottomLeft:      layoutBottomLeft()
        case .bottomRight:     layoutBottomRight()
        @unknown default:
            layoutAspectFit()
        }
    }
}
