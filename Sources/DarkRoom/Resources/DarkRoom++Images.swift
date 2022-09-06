//
//  DarkRoom++Images.swift
//  
//
//  Created by Kiarash Vosough on 7/19/22.
//

import Foundation
import UIKit

extension DarkRoomAsset {
    
    public enum Images: String, CaseIterable {
        case play = "ic_play"
        case pause = "ic_pause"
        case close = "close"
        
        public var image: UIImage? {
            let bundle = DarkRoomBundleToken.bundle
            return UIImage(named: rawValue, in: bundle, compatibleWith: nil)
        }
    }
}
