//
//  SACountingLabel.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/13/15.
//
//

import Foundation
import UIKit

public class SACountingLabel: UILabel {
    
    let kCounterRate = 3.0
    
    public enum AnimationType {
        case Linear
        case EaseIn
        case EaseOut
        case EaseInOut
    }
    
    public enum CountingType {
        case Int
        case Float
        case Custom
    }
    
    var start = 0.0
    var end = 0.0
    var timer: NSTimer?
    var progress: NSTimeInterval!
    var lastUpdate: NSTimeInterval!
    var duration: NSTimeInterval!
    var countingType: CountingType!
    var animationType: AnimationType!
    public var format: String?
    
    var currentValue: Double {
        if (progress >= duration) {
            return end
        }
        let percent = (progress / duration)
        let update = updateCounter(percent)
        return start + (update * (end - start));
    }
    
    public func countFrom(fromValue: Double, to toValue: Double, withDuration duration: NSTimeInterval, andAnimationType aType: AnimationType, andCountingType cType: CountingType) {
        
        // Set values
        self.start = fromValue
        self.end = toValue
        self.duration = duration
        self.countingType = cType
        self.animationType = aType
        self.progress = 0.0
        self.lastUpdate = NSDate.timeIntervalSinceReferenceDate()
        
        // Invalidate and nullify timer
        killTimer()
        
        // Handle no animation
        if (duration == 0.0) {
            updateText(toValue)
            return
        }
        
        // Create timer
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(SACountingLabel.updateValue), userInfo: nil, repeats: true)
    }
    
    public func animateToValue(value: Double) {
        let from = end
        let to = value
        
        countFrom(from, to: to, withDuration: 1, andAnimationType: .EaseOut, andCountingType: .Float)
    }
    
    func updateText(value: Double) {
        switch countingType! {
        case .Int:
            self.text = "\(Int(value))"
        case .Float:
            self.text = String(format: "%.2f", value)
        case .Custom:
            if let format = format {
                self.text = String(format: format, value)
            } else {
                self.text = String(format: "%.2f", value)
            }
        }
    }
    
    func updateValue() {
        
        // Update the progress
        let now = NSDate.timeIntervalSinceReferenceDate()
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        // End when timer is up
        if (progress >= duration) {
            killTimer()
            progress = duration
        }
        
        updateText(currentValue)
        
    }
    
    func killTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateCounter(t: Double) -> Double {
        switch animationType! {
        case .Linear:
            return t
        case .EaseIn:
            return pow(t, kCounterRate)
        case .EaseOut:
            return 1.0 - pow((1.0 - t), kCounterRate)
        case .EaseInOut:
            var t = t
            var sign = 1.0;
            let r = Int(kCounterRate)
            if (r % 2 == 0) {
                sign = -1.0
            }
            t *= 2;
            if (t < 1) {
                return 0.5 * pow(t, kCounterRate)
            } else {
                return (sign * 0.5) * (pow(t-2, kCounterRate) + (sign * 2))
            }
            
        }
    }
    
    
}
