//
//  DarkRoomConfiguration.swift
//  
//
//  Created by Kiarash Vosough on 8/2/22.
//

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
