//
//  CGRect++Extensions.swift
//  
//
//  Created by Kiarash Vosough on 8/1/22.
//

import UIKit

extension CGRect {
    
    internal var containsNaNValuesInRect: Bool {
        origin.x.isNaN || origin.y.isNaN || size.width.isNaN || size.height.isNaN
    }
}
