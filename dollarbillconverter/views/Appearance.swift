//
//  Appearance.swift
//  dollarbillconverter
//
//  Created by Diego Castiblanco on 10/17/16.
//  Copyright © 2016 Diego Castaño. All rights reserved.
//

import Foundation
import UIKit

enum AppColors {
    
    case Salmon
    case BlackPanel
    case White
    case LightGray
    case Black
    
    static func UIColorFromTag(tag: AppColors) -> UIColor{
        
        switch tag {
            
        case .Salmon:
            return UIColor(red: 252/255, green: 105/255, blue: 105/255, alpha: 100)
            
        case .BlackPanel:
            return UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 100)
        
        case .LightGray:
            return UIColor(red: 142/255, green: 138/255, blue: 138/255, alpha: 1.0)
            
        case .Black:
            return UIColor.blackColor()
            
        case .White:
            return UIColor.whiteColor()

        }
        
    }
    
}

enum AppFonts {

    case Regular
    case Bold
    case Black
    case Light
    
    static func fontOfType (type : AppFonts, withSize : CGFloat) -> UIFont? {
    
        switch type {
        case .Black:
            return UIFont(name:"Aileron-Black", size: withSize)
        case .Bold:
             return UIFont(name:"Aileron-Bold", size: withSize)
        case .Regular:
            return UIFont(name:"Aileron-Regular", size: withSize)
        case .Light:
            return UIFont(name:"Aileron-Light", size: withSize)
    
        }
    }
}
