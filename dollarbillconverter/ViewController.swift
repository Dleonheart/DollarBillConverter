//
//  ViewController.swift
//  dollarbillconverter
//
//  Created by Diego Castaño on 8/9/16.
//  Copyright © 2016 Diego Castaño. All rights reserved.
//

import UIKit
import SnapKit



class ViewController: UIViewController {
    
    var topDecoration : UIView!
    var currencyInputContainer: UIView!
    var pickerControls: NumberPicker!
    var currencyInput : UILabel!
    var currencyTypeLabel: UILabel!
    
    // animation properties
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
    
        topDecoration = UIView();
        topDecoration.backgroundColor =  UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 100)
        currencyInputContainer = UIView();
        currencyInputContainer.backgroundColor = UIColor(red: 252/255, green: 105/255, blue: 105/255, alpha: 100)
        pickerControls = NumberPicker()
        pickerControls.delegate = self
        
        currencyInput = UILabel()
        currencyInput.backgroundColor = UIColor.clearColor()
        currencyInput.text = "0";
        currencyInput.font = UIFont(name:"HelveticaNeue-Bold", size: 62.0)
        currencyInput.textColor = UIColor.whiteColor()
        currencyInput.textAlignment = .Right
        
        currencyTypeLabel = UILabel();
        currencyTypeLabel.backgroundColor = UIColor.clearColor()
        currencyTypeLabel.text = "USD";
        currencyTypeLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        currencyTypeLabel.textColor = UIColor.whiteColor()


        
        
        view.addSubview(topDecoration)
        view.addSubview(currencyInputContainer)
        view.addSubview(pickerControls)
        
        currencyInputContainer.addSubview(currencyTypeLabel)
        currencyInputContainer.addSubview(currencyInput)
        
    
        
        topDecoration.snp_makeConstraints {(make) in
            
            make.top.left.right.equalTo(view)
            make.height.equalTo(150)
        }
        
        currencyInputContainer.snp_makeConstraints { (make) in
        
            make.top.equalTo(view).offset(50)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(200);
        }
        
        pickerControls.snp_makeConstraints { make in
            make.right.equalTo(currencyInputContainer).offset(-15)
            make.bottom.equalTo(currencyInputContainer).offset(27)
            make.height.equalTo(55)
            make.width.equalTo(130)
        }
        
        currencyInput.snp_makeConstraints { make in
            make.height.equalTo(currencyInputContainer)
            make.right.equalTo(currencyInputContainer).offset(-15)
            make.centerY.equalTo(currencyInputContainer)
        }
        
        currencyTypeLabel.snp_makeConstraints { make in
            make.centerY.equalTo(currencyInput).offset(-10)
            make.right.equalTo(currencyInput.snp_left).offset(-25)
        }
        
        currencyInputContainer.layer.shadowColor = UIColor.blackColor().CGColor
        currencyInputContainer.layer.shadowOpacity = 0.37
        currencyInputContainer.layer.shadowOffset = CGSize(width: 0 , height: 6)
        currencyInputContainer.layer.shadowRadius = 8
        
    }


}

extension ViewController : NumberPickerProtocol {

    func numberDidChange(number: Int) {
        self.currencyInput.transform = CGAffineTransformMakeScale(0.2, 0.5)

        
        UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: {
            self.currencyInput.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        currencyInput.text = "\(number)"
    }
}

