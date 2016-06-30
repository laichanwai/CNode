//
//  UIKit+Extension.swift
//  CNode
//
//  Created by Ivy on 16/6/4.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit

// MARK: - Navigation
private var _nav_background_image: UIImage?
private var _nav_shadow_image: UIImage?
private var _nav_hidden: Bool = false
extension UINavigationController {
    
    func showNavigationBar() {
        guard _nav_hidden else {
            return
        }
        
        navigationBar.setBackgroundImage(_nav_background_image, forBarMetrics: .Default)
        navigationBar.shadowImage = _nav_shadow_image
        _nav_hidden = !_nav_hidden
    }
    
    func hideNavigationBar() {
        guard !_nav_hidden else {
            return
        }
        _nav_background_image = navigationBar.backgroundImageForBarMetrics(.Default)
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        _nav_shadow_image = navigationBar.shadowImage
        navigationBar.shadowImage = UIImage()
        _nav_hidden = !_nav_hidden
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    func addNotification(name: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: name, object: nil);
    }
}

// MARK: - UIView
extension UIView {
    var x: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    var width: CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    var height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    var top: CGFloat {
        get { return self.y }
        set { self.y = newValue }
    }
    var bottom: CGFloat {
        get { return self.y + self.height }
        set { self.y = newValue - self.height }
    }
    var left: CGFloat {
        get { return self.x }
        set { self.x = newValue }
    }
    var right: CGFloat {
        get { return self.x + self.width }
        set { self.x = newValue - self.width }
    }
}