//
//  DarkRoom++Colors.swift
//  
//
//  Created by Kiarash Vosough on 7/19/22.
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

extension DarkRoomAsset {

    public enum Colors: String {

        case primaryWhite = "primary white"
        case primaryGray = "primary gray"
        case whiteHint = "white hint"
        case brandRed = "primary red"

        private func buildColor(color: Colors) -> UIColor {
            guard let color = UIColor(named: color.rawValue, in: DarkRoomBundleToken.bundle, compatibleWith: nil) else {
                fatalError("Unable to load color asset named \(color.rawValue).")
            }
            return color
        }

        public var color: UIColor {
            buildColor(color: self)
        }
    }
}
