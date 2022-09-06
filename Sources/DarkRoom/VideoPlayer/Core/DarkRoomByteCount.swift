//
//  DarkRoomByteCount.swift
//  
//
//  Created by Kiarash Vosough on 7/15/22.
//

import Foundation

/// Representing count of bytes in several scales
public enum DarkRoomByteCount: Equatable {

    case byte(Int)
    case kiloByte(Int)
    case megaByte(Int)
    case gigaByte(Int)

    public var byteCount: Int {
        switch self {
        case .byte(let count):
            return count
        case .kiloByte(let count):
            return count * 1024
        case .megaByte(let count):
            return count * 1024 * 1024
        case .gigaByte(let count):
            return count * 1024 * 1024 * 1024
        }
    }
}
