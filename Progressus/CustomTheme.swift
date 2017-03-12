//
//  Constant.swift
//  Up
//
//  Created by Choong Kai Wern on 04/02/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation
import UIKit

enum Theme: String {
    case blue = "Blue"
    case dark = "Dark"
}

struct CustomTheme {
    
    private struct Colors {
        static var white = UIColor.init(white: 0.98, alpha: 1)
        static var black = UIColor.init(white: 0.02, alpha: 1)
        static var lightGray = UIColor.init(white: 0.90, alpha: 1)
        static var gray = UIColor.init(white: 0.60, alpha: 1)
        static var darkGray = UIColor.init(white: 0.20, alpha: 1)
        // #283440
        static var gunmetal = UIColor.init(red: 0.157, green: 0.204, blue: 0.251, alpha: 1)
        // #344250
        static var charchoal = UIColor.init(red: 0.204, green: 0.259, blue: 0.314, alpha: 1)
        // #427dd6
        static var blue = UIColor.init(red: 0.247, green: 0.482, blue: 0.851, alpha: 1)
        // #42a2d6
        static var moderateBlue = UIColor.init(red: 0.259, green: 0.635, blue: 0.839, alpha: 1)
        // #42c7d6
        static var moderateCyan = UIColor.init(red: 0.259, green: 0.78, blue: 0.839, alpha: 1)
    }
    
    static func borderColor() -> UIColor {
        if Settings.theme == .blue {
            return Colors.darkGray
        }
        return Colors.lightGray
    }
    
    static func cellBackgroundColor() -> UIColor {
        if Settings.theme == .blue {
            return Colors.white
        }
        return Colors.charchoal
    }
    
    static func cellSelectedView() -> UIView {
        let view = UIView()
        if Settings.theme == .blue {
            view.backgroundColor = Colors.lightGray
        } else {
            view.backgroundColor = Colors.darkGray
        }
        return view
    }
    
    static func backgroundColor() -> UIColor {
        if Settings.theme == .blue {
            return Colors.white
        }
        return Colors.gunmetal
    }
    
    static func barStyle() -> UIBarStyle {
        if Settings.theme == .blue {
            return UIBarStyle.default
        }
        return UIBarStyle.black
    }
    
    static func textColor() -> UIColor {
        if Settings.theme == .blue {
            return Colors.black
        }
        return Colors.white
    }
    
    static func placeholderColor() -> UIColor {
        return Colors.gray
    }
    
    static func primaryColor() -> UIColor {
        if Settings.theme == .blue {
            return Colors.blue
        }
        return Colors.moderateBlue
    }
    
    static func lighterPrimaryColor() -> UIColor {
        if Settings.theme == .blue {
            return Colors.blue.withAlphaComponent(0.5)
        }
        return Colors.moderateBlue.withAlphaComponent(0.5)
    }
}
