//
//  DarkRoom++Colors.swift
//  
//
//  Created by Kiarash Vosough on 7/19/22.
//

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
