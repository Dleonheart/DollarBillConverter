//
//  NumberPicker.swift
//  dollarbillconverter
//
//  Created by Diego Castaño on 8/25/16.
//  Copyright © 2016 Diego Castaño. All rights reserved.
//

import UIKit
import SnapKit

class NumberPicker: UIView {
    

    private var increment = ForceButton()
    private var decrement = ForceButton()
    private var pickingNumber = 0
    private var direction: Direction = .Incrementing
    private var timer = NSTimer()
    private var counterInterval = 0.22
    private var minCounterInterval = 0.1
    private var maxCounterInterval = 0.22
    private var maxForceValue = 6.66
    private var currentForceValue: CGFloat = 0.0
    private let forcePress = ForceGestureRecognizer()

    
    var delegate : NumberPickerDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        
    }
    
    init() {
        super.init(frame: CGRectZero)
        setupViews()
    }
    
    
    private func setupViews() {
        
        /// force gesture recognizer
        
        self.addGestureRecognizer(forcePress)
        forcePress.cancelsTouchesInView = false
        forcePress.addTarget(self, action: #selector(pickerPressed))
        
        // appearance
        
        increment.setTitle("+", forState: .Normal)
        decrement.setTitle("-", forState: .Normal)
        increment.setTitleColor(AppColors.UIColorFromTag(.White), forState: .Normal)
        decrement.setTitleColor(AppColors.UIColorFromTag(.White), forState: .Normal)
        increment.backgroundColor = AppColors.UIColorFromTag(.BlackPanel)
        decrement.backgroundColor = AppColors.UIColorFromTag(.BlackPanel)
        
        // event binding
        
        increment.addTarget(self, action: #selector(incrementPressed), forControlEvents: .TouchDown)
        increment.addTarget(self, action: #selector(incrementReleased), forControlEvents: .TouchUpInside)
        increment.addTarget(self, action: #selector(incrementReleased), forControlEvents: .TouchDragOutside)
        decrement.addTarget(self, action: #selector(decrementPressed), forControlEvents: .TouchDown)
        decrement.addTarget(self, action: #selector(decrementReleased), forControlEvents: .TouchUpInside)
        decrement.addTarget(self, action: #selector(decrementReleased), forControlEvents: .TouchDragOutside)
        
        addSubview(increment)
        addSubview(decrement)
        
        // autolayout
        
        increment.snp_makeConstraints { make in
            make.top.bottom.right.equalTo(self)
            make.width.equalTo(self).dividedBy(2.1)
        }
        
        decrement.snp_makeConstraints { make in
            make.top.bottom.left.equalTo(self)
            make.width.equalTo(self).dividedBy(2.1)
        }
    }
    
    private func resetInterval() {
        counterInterval = maxCounterInterval
    }
    
    private func updateTimeIntervalWithForce(force: CGFloat) {
        currentForceValue = force
        let slope = (maxCounterInterval - minCounterInterval) / -maxForceValue
        counterInterval = slope * Double(force) + maxCounterInterval
        updateTimer()
    }
    
    private func updateTimer() {
        timer.invalidate()
        
        switch direction {
            
        case .Incrementing:
            timer = NSTimer.scheduledTimerWithTimeInterval(counterInterval, target: self, selector: #selector(incrementNumber), userInfo: nil, repeats: true)
        
        case .Decrementing:
            timer = NSTimer.scheduledTimerWithTimeInterval(counterInterval, target: self, selector: #selector(decrementNumber), userInfo: nil, repeats: true)

        }
    }
    
    
    /**
     sets internal counting vañue
     - Parameter number: the new internal number value
     
     */
    func setNumber(number: Int) {
        pickingNumber = number
    }
    
    /**
     Signal to increment Number
     
     - Notifies delegate of number increment
     
    */
    func incrementNumber() {
        pickingNumber += 1
        if let delegate = delegate {
            delegate.numberDidChange(pickingNumber)
        }
    }
    
    /**
     Signal to decrement Number
     
     - Notifies delegate of number increment
     
     */
    func decrementNumber() {
        if(pickingNumber <= 0) {
            return
        }
        pickingNumber -= 1
        if let delegate = delegate {
            delegate.numberDidChange(pickingNumber)
        }
        
    }
    
    func incrementPressed() {
        direction = .Incrementing
        updateTimer()
        timer.fire()
    }
    
    func incrementReleased() {
        timer.invalidate()
        resetInterval()
        delegate?.touchesDidEnd()
    }
    
    
    func decrementPressed() {
        direction = .Decrementing
        updateTimer()
        timer.fire()
    }
    
    func decrementReleased() {
        timer.invalidate()
        resetInterval()
        delegate?.touchesDidEnd()
    }
    
    /**
     Handles force gesture event
     
     - Decreases/Increases timer interval based on the force received by the gesture
     
     */
    func pickerPressed(sender : ForceGestureRecognizer) {
        if(abs(currentForceValue - sender.forceValue) >= 0.1) {
            updateTimeIntervalWithForce(sender.forceValue)
        }
    }

}

private enum Direction {
    case Incrementing
    case Decrementing
}

protocol NumberPickerDelegate {
    func numberDidChange(number: Int)
    func touchesDidEnd()
}
