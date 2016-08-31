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
    private var direction: AmountDirection = .Incrementing
    private var timer = NSTimer()
    private var counterInterval = 0.22
    private var minCounterInterval = 0.1
    private var maxCounterInterval = 0.22
    private var maxForceValue = 6.66
    private var currentForceValue: CGFloat = 0.0
    private let forcePress = ForceGestureRecognizer()
    
    var delegate : NumberPickerProtocol?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        
    }
    
    init() {
        super.init(frame: CGRectZero)
        setupViews()
    }
    
    
    private func setupViews() {
        
        self.addGestureRecognizer(forcePress)
        forcePress.cancelsTouchesInView = false
        forcePress.addTarget(self, action: #selector(pickerPressed))
        
        increment  = ForceButton()
        decrement = ForceButton()
        increment.setTitle("+", forState: .Normal)
        decrement.setTitle("-", forState: .Normal)
        increment.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        decrement.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        increment.backgroundColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 100)
        decrement.backgroundColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 100)
        
        increment.addTarget(self, action: #selector(incrementDown), forControlEvents: .TouchDown)
        increment.addTarget(self, action: #selector(incrementUp), forControlEvents: .TouchUpInside)
        increment.addTarget(self, action: #selector(incrementUp), forControlEvents: .TouchDragOutside)
        decrement.addTarget(self, action: #selector(decrementDown), forControlEvents: .TouchDown)
        decrement.addTarget(self, action: #selector(decrementUp), forControlEvents: .TouchUpInside)
        decrement.addTarget(self, action: #selector(decrementUp), forControlEvents: .TouchDragOutside)
        
        addSubview(increment)
        addSubview(decrement)
        
        increment.snp_makeConstraints { make in
            make.top.bottom.right.equalTo(self)
            make.width.equalTo(self).dividedBy(2.1)
        }
        
        decrement.snp_makeConstraints { make in
            make.top.bottom.left.equalTo(self)
            make.width.equalTo(self).dividedBy(2.1)
        }
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
    
    func incrementNumber() {
        pickingNumber += 1
        if let delegate = delegate {
            delegate.numberDidChange(pickingNumber)
        }
    }
    
    func incrementDown() {
        direction = .Incrementing
        updateTimer()
        timer.fire()
    }
    
    func incrementUp() {
        timer.invalidate()
        counterInterval = 0.2
    }
    
    func decrementNumber() {
        pickingNumber -= 1
        if let delegate = delegate {
            delegate.numberDidChange(pickingNumber)
        }

    }
    
    func decrementDown() {
        direction = .Decrementing
        updateTimer()
        timer.fire()
    }
    
    func decrementUp() {
        timer.invalidate()
        counterInterval = 0.2
    }
    
    func pickerPressed(sender : ForceGestureRecognizer) {
        if(abs(currentForceValue - sender.forceValue) >= 0.1) {
            updateTimeIntervalWithForce(sender.forceValue)
        }
    }

}

enum AmountDirection {
    case Incrementing
    case Decrementing
}

protocol NumberPickerProtocol {
    func numberDidChange(number: Int)
}
