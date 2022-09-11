//
//  DarkRoomConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
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

// MARK: - Abstraction

public protocol DarkRoomCarouselConfiguration {

    var transitionStyle: UIPageViewController.TransitionStyle { get }
    
    var navigationOrientation: UIPageViewController.NavigationOrientation { get }
    
    var options: [UIPageViewController.OptionsKey : Any]? { get }
    
    var navigationItemOptions: [DarkRoomCarouselOption] { get }
    
    var videoPlayerControllerConfiguration: DarkRoomVideoPlayerControllerConfiguration { get }
}

// MARK: - Implementation

public struct DarkRoomCarouselDefaultConfiguration: DarkRoomCarouselConfiguration {

    public var navigationItemOptions: [DarkRoomCarouselOption]
    
    public var transitionStyle: UIPageViewController.TransitionStyle
    
    public var navigationOrientation: UIPageViewController.NavigationOrientation
    
    public var options: [UIPageViewController.OptionsKey : Any]?
    
    public var videoPlayerControllerConfiguration: DarkRoomVideoPlayerControllerConfiguration
    
    public init(
        transitionStyle: UIPageViewController.TransitionStyle = .scroll,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        navigationItemOptions: [DarkRoomCarouselOption] = [],
        options: [UIPageViewController.OptionsKey : Any]? = [UIPageViewController.OptionsKey.interPageSpacing: 20],
        videoPlayerControllerConfiguration: DarkRoomVideoPlayerControllerConfiguration = DarkRoomVideoPlayerControllerDefaultConfiguration()
    ) {
        self.navigationItemOptions = navigationItemOptions
        self.videoPlayerControllerConfiguration = videoPlayerControllerConfiguration
        self.transitionStyle = transitionStyle
        self.navigationOrientation = navigationOrientation
        self.options = options
    }
    
}
