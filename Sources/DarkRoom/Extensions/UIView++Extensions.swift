//
//  UIView++Extensions.swift
//
//
//  Created by Kiarash Vosough on 7/21/22.
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

extension UIView {

    func bindFrameToSuperview(top:CGFloat = 0, leading: CGFloat = 0, trailing:CGFloat = 0, bottom:CGFloat = 0) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        superview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: trailing).isActive = true
        superview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: bottom).isActive = true
    }

    func bindFrameToSuperview(margin:CGFloat) {
        bindFrameToSuperview(top: margin, leading: margin, trailing: margin, bottom: margin)
    }

    func frameRelativeToWindow() -> CGRect {
        return convert(bounds, to: nil)
    }
}
