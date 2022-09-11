//
//  DarkRoomPlayerSliderThumbView.swift
//
//
//  Created by Kiarash Vosough on 7/2/22.
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

public enum DarkRoomPlayerSliderThumbViewStyle {

    case image(image: UIImage)
    case circleShape(radius: CGFloat, color: UIColor)

    public var size: CGSize {
        switch self {
        case .image(let image):
            return image.size
        case .circleShape(let radius, _):
            return CGSize(width: radius, height: radius)
        }
    }
}

internal enum DarkRoomPlayerSliderThumbViewState {
    case normal
    case highlighted
}

fileprivate struct AssociatedInstance {
    
    var style: DarkRoomPlayerSliderThumbViewStyle
    
    var originalStyle: DarkRoomPlayerSliderThumbViewStyle?

    var state: DarkRoomPlayerSliderThumbViewState
    
    fileprivate init(
        style: DarkRoomPlayerSliderThumbViewStyle = .circleShape(radius: 30, color: .white),
        state: DarkRoomPlayerSliderThumbViewState = .normal
    ) {
        self.style = style
        self.state = state
    }
    
}

internal final class DarkRoomPlayerSliderThumbView: UIView, DarkRoomFailureRepresentableView {
    
    fileprivate var associatedInstance: AssociatedInstance
    
    // MARK: - Views
    
    private var imageView: UIImageView!
    
    // MARK: - Getters
    
    internal var image: UIImage? { imageView?.image }
    
    internal var style: DarkRoomPlayerSliderThumbViewStyle {
        get {
            associatedInstance.style
        } set {
            associatedInstance.style = newValue
            setStyle()
        }
    }
    
    internal var styledSize: CGSize { associatedInstance.style.size }
    
    internal var state: DarkRoomPlayerSliderThumbViewState {
        get {
            associatedInstance.state
        } set {
            associatedInstance.state = newValue
        }
    }
    
    // MARK: - Inputs
    
    private let configuration: DarkRoomThumbViewConfiguration
    
    // MARK: - LifeCycle
    
    internal init(frame: CGRect, configuration: DarkRoomThumbViewConfiguration) {
        self.configuration = configuration
        self.associatedInstance = AssociatedInstance(style: configuration.thumbStyle)
        super.init(frame: frame)
        setStyle()
    }
    
    internal convenience init(configuration: DarkRoomThumbViewConfiguration) {
        self.init(frame: .zero, configuration: configuration)
    }
    
    internal required init?(coder: NSCoder) {
        self.associatedInstance = AssociatedInstance()
        self.configuration = DarkRoomThumbViewDefaultConfiguration()
        super.init(coder: coder)
        setStyle()
    }
    
    func updateView(shouldRepresentError: Bool) {
        if shouldRepresentError == true {
            associatedInstance.originalStyle = associatedInstance.style
            switch associatedInstance.style {
            case let .circleShape(radius, _):
                self.style = .circleShape(radius: radius, color: configuration.errorColor)
            case let .image(image):
                self.style = .image(image: image)
            }
        } else if let originalStyle = associatedInstance.originalStyle, shouldRepresentError == false {
            self.style = originalStyle
            associatedInstance.originalStyle = nil
        }
        setNeedsDisplay()
        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Preparing Views
    
    private func setStyle() {
        switch associatedInstance.style {
        case let .circleShape(radius, color):
            self.drawCircleShape(with: radius, color: color)
        case let .image(image):
            self.setupImageView(with: image)
        }
    }
    
    private func setupImageView(with image: UIImage, with errorColor: UIColor? = nil) {
        imageView = UIImageView(image: image)
        imageView.tintColor = errorColor
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func drawCircleShape(with radius: CGFloat, color: UIColor) {
        backgroundColor = color
        layer.cornerRadius = radius / 2
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: radius),
            widthAnchor.constraint(equalToConstant: radius)
        ])
    }
}
