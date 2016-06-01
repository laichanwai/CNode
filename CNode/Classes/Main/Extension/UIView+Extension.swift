//
//  UIView+Ivy.swift
//  CNode
//
//  Created by Ivy on 16/5/10.
//  Copyright © 2016年 Ivy. All rights reserved.
//

import UIKit

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