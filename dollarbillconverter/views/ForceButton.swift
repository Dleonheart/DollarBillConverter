//
//  ForceButton.swift
//  ForceTest
//
//  Created by Victor Baro on 17/10/2015.
//  Copyright © 2015 Produkt. All rights reserved.
//

import UIKit


class ForceButton: UIButton {
    
    private let maxForceValue: CGFloat = 6.6
    
    var shadowColor: UIColor = UIColor.blackColor()
    var shadowOpacity: Float = 0.7
    var maxShadowOffset: CGSize = CGSize(width: 0.0, height: 6.6)
    var maxShadowRadius: CGFloat = 13.0
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        shadowWithAmount(0.0)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        handleForceWithTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        handleForceWithTouches(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        shadowWithAmount(0.0)
    }
    
    func handleForceWithTouches(touches: Set<UITouch>) {
        if touches.count != 1 {
            return
        }
        guard let touch = touches.first else {
            return
        }
        
        shadowWithAmount(touch.force)
        
    }
    
    func shadowWithAmount(amount: CGFloat) {
        layer.shadowColor = shadowColor.CGColor
        layer.shadowOpacity = shadowOpacity
        let widthFactor = maxShadowOffset.width/maxForceValue
        let heightFactor = maxShadowOffset.height/maxForceValue
        layer.shadowOffset = CGSize(width: maxShadowOffset.width - amount * widthFactor,
                                    height: maxShadowOffset.height - amount * heightFactor)
        layer.shadowRadius = maxShadowRadius - amount
        layer.transform = CATransform3DMakeScale(1 + amount/80, 1 + amount/80, 1)
    }
}
