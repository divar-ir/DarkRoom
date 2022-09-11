//
//  DarkRoomPlayerState.swift
//  
//
//  Created by Kiarash Vosough on 7/12/22.
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

import Foundation

// MARK: - Abstraction

/// abstraction for states of the player
public protocol DarkRoomPlayerState: DarkRoomPlayerCommand {
    
    /// refrence to the context of states
    var context: DarkRoomPlayerContext { get }

    /// determines the type of state
    var type: DarkRoomPlayerStates { get }

    /// determines whether teh seek action is enabled on the state or not
    var isSeekingEnabled: Bool { get }

    /// notify the state that context was updated
    /// states can be refreshed or change to another state if needed
    func contextUpdated()
}
