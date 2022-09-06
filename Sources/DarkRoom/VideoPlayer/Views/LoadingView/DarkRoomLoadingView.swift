//
//  DarkRoomProgressView.swift
//
//
//  Created by Kiarash Vosough on 7/8/22.
//

import UIKit

internal final class DarkRoomLoadingView: UIView {

    private let animateStrokeKey = "AnimateStrokeKey"
    private let animateRotationKey = "AnimateRotationKey"

    // MARK: - Views

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var LoadingView: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shapeLayer: DarkRoomLoadingShapeLayer = {
        return DarkRoomLoadingShapeLayer(strokeColor: colors.first!, lineWidth: lineWidth)
    }()

    // MARK: - Inputs

    internal let colors: [UIColor]

    internal let lineWidth: CGFloat
    
    internal var messageText: String? {
        get {
            messageLabel.text
        }
        set {
            messageLabel.text = newValue
        }
    }
    
    internal var isMessageHidden: Bool {
        get {
            messageLabel.isHidden
        }
        set {
            messageLabel.isHidden = newValue
        }
    }
    
    internal var messageFont: UIFont {
        get {
            messageLabel.font
        }
        set {
            messageLabel.font = newValue
        }
    }

    // MARK: - Lifecycle

    internal init(
        frame: CGRect,
        colors: [UIColor],
        lineWidth: CGFloat
    ) {
        precondition(colors.isEmpty == false, "Should Provide At Least One Color")
        self.colors = colors
        self.lineWidth = lineWidth
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.prepareMessageLabel()
        self.prepareLoadingView()
    }

    internal convenience init(colors: [UIColor], lineWidth: CGFloat) {
        self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
    }
    
    internal convenience init(configuration: DarkRoomLoadingViewConfiguration) {
        self.init(frame: .zero, colors: configuration.loadingViewColors, lineWidth: configuration.loadingViewLineWidth)
        self.backgroundColor = configuration.loadingViewBackgroundColor
    }
    
    internal required init?(coder: NSCoder) {
        self.colors = []
        self.lineWidth = 10
        super.init(coder: coder)
        self.prepareMessageLabel()
        self.prepareLoadingView()
    }

    internal override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.width / 2
        LoadingView.layer.cornerRadius = LoadingView.frame.width / 2

        let path = UIBezierPath(
            ovalIn: CGRect(
                x: 0,
                y: 0,
                width: self.bounds.width,
                height: self.bounds.width
            )
        )

        shapeLayer.path = path.cgPath
    }
    
    fileprivate func prepareMessageLabel() {
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 10)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)

        let distance = lineWidth + 2
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: distance),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: distance),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -distance),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -distance)
        ])
    }
    
    fileprivate func prepareLoadingView() {
        addSubview(LoadingView)
        
        NSLayoutConstraint.activate([
            LoadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            LoadingView.topAnchor.constraint(equalTo: topAnchor),
            LoadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            LoadingView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    internal func removeAnimations() {
        LoadingView.layer.removeAnimation(forKey: animateStrokeKey)
        LoadingView.layer.removeAnimation(forKey: animateRotationKey)
    }
    
    internal func animateStroke() {

        let startAnimation = DarkRoomStrokeAnimation(
            type: .start,
            beginTime: 0.25,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )

        let endAnimation = DarkRoomStrokeAnimation(
            type: .end,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )

        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = [startAnimation, endAnimation]

        shapeLayer.add(strokeAnimationGroup, forKey: animateStrokeKey)

        LoadingView.layer.addSublayer(shapeLayer)
    }
    
    internal func animateRotation() {
        let rotationAnimation = DarkRoomRotationAnimation(
            direction: .z,
            fromValue: 0,
            toValue: CGFloat.pi * 2,
            duration: 2,
            repeatCount: .greatestFiniteMagnitude
        )

        LoadingView.layer.add(rotationAnimation, forKey: animateRotationKey)
    }
}
