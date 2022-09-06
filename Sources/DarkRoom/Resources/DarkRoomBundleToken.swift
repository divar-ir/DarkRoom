//
//  DarkRoomBundleToken.swift
//  
//
//  Created by Kiarash Vosough on 7/9/22.
//

import Foundation

internal final class DarkRoomBundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}
