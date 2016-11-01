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
    
    private var topDecoration = UIView()
    private var currencyInputContainer = UIView()
    private var pickerControls = NumberPicker()
    private var currencyInput = UILabel()
    private var hiddenInput = UITextField()
    private var currencyTypeLabel = UILabel()
    private var currencyTable = UITableView()
    private var explanatoryLabel = UILabel()
    private var resultsTable = UITableView()
    
    private var dollarsAmount: Int = 0 {
        didSet {
            currencyInput.text = "\(dollarsAmount)"
        }
    }
    
    // MARK: Conversion engine

    
    private var currencyConverter = DollarsConverter()
    
    
    private var conversionResults : [ConvertedCurrency] = [] {
    
        didSet {
            explanatoryLabel.text = "Your \(dollarsAmount) us dollars are worth:"
        }
    }
    
    // Status bar coloring
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupViews() {
        
        // MARK: View styling
        
        topDecoration.backgroundColor = AppColors.UIColorFromTag(.BlackPanel)
        currencyInputContainer.backgroundColor = AppColors.UIColorFromTag(.Salmon)
        pickerControls.delegate = self
        
        currencyInput.backgroundColor = UIColor.clearColor()
        currencyInput.text = "0";
        currencyInput.font = AppFonts.fontOfType(.Black, withSize: 62.0)
        currencyInput.textColor = AppColors.UIColorFromTag(.White)
        currencyInput.textAlignment = .Right
        
        hiddenInput.delegate = self
        hiddenInput.keyboardType = .NumberPad;
        
        currencyTypeLabel.backgroundColor = UIColor.clearColor()
        currencyTypeLabel.text = "USD";
        currencyTypeLabel.font = AppFonts.fontOfType(.Light, withSize: 16.0)
        currencyTypeLabel.textColor = AppColors.UIColorFromTag(.White)
        
        explanatoryLabel.backgroundColor = UIColor.clearColor()
        explanatoryLabel.text = "Press +/- buttons to set the amount, press harder to increase counting velocity (on 3d touch enabled devices)"
        explanatoryLabel.font = AppFonts.fontOfType(.Light, withSize: 18.0)
        explanatoryLabel.numberOfLines = 0
        explanatoryLabel.textAlignment = .Center
        explanatoryLabel.textColor = AppColors.UIColorFromTag(.LightGray)
        
        resultsTable.registerClass(CurrencyTableViewCell.self, forCellReuseIdentifier: "cell")
        resultsTable.delegate = self
        resultsTable.dataSource = self
        resultsTable.rowHeight = 97
        resultsTable.showsVerticalScrollIndicator = false
        resultsTable.allowsSelection = false
        
        view.addSubview(topDecoration)
        view.addSubview(currencyInputContainer)
        view.addSubview(pickerControls)
        view.addSubview(explanatoryLabel)
        view.addSubview(resultsTable)
        
        currencyInputContainer.addSubview(currencyTypeLabel)
        currencyInputContainer.addSubview(currencyInput)
        currencyInputContainer.addSubview(hiddenInput)
        
        // MARK: autolayout setup
        
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
        
        hiddenInput.snp_makeConstraints { make in
            make.top.right.bottom.left.equalTo(currencyInputContainer)
        }
        
        explanatoryLabel.snp_makeConstraints { make in
            make.top.equalTo(currencyInputContainer.snp_bottom).offset(60)
            make.left.equalTo(view).offset(45)
            make.right.equalTo(view).offset(-45)
        }
        
        resultsTable.snp_makeConstraints { make in
            make.top.equalTo(explanatoryLabel.snp_bottom).offset(25)
            make.left.equalTo(view).offset(51)
            make.right.equalTo(view).offset(-51)
            make.bottom.equalTo(view)
        }
        
        // shadows
        
        currencyInputContainer.layer.shadowColor = AppColors.UIColorFromTag(.Black).CGColor
        currencyInputContainer.layer.shadowOpacity = 0.37
        currencyInputContainer.layer.shadowOffset = CGSize(width: 0 , height: 6)
        currencyInputContainer.layer.shadowRadius = 8
        
        currencyInput.layer.shadowColor = AppColors.UIColorFromTag(.Black).CGColor
        currencyInput.layer.shadowOpacity = 0.45
        currencyInput.layer.shadowOffset = CGSize(width: 0 , height: 3)
        currencyInput.layer.shadowRadius = 3
        currencyInput.layer.shouldRasterize = true
        
    }
    
    func errorMsg(error: String) {
        let errorString = "I'm sorry I could not reach exchange rates, Try again later please !" as NSString;
        let errorMsg = NSMutableAttributedString(string: errorString as String )
        let attributes = [NSForegroundColorAttributeName:AppColors.UIColorFromTag(.Salmon)]
        
        errorMsg.addAttributes(attributes, range: errorString.rangeOfString(errorString as String))
        explanatoryLabel.attributedText = errorMsg
    }
    
    func invokeCurrencyConversion() {
        
        currencyConverter.convertDollars(dollarsAmount) { (results, error ) in
            
            
            if let error = error {
                self.errorMsg(error);
            }
            
            guard let results = results else {
                self.errorMsg("No conversion data available")
                return
            }
            
            self.conversionResults = results
            self.resultsTable.reloadData()
        }
            
    }
    
}


extension ViewController {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}

// delegates implementation

extension ViewController : NumberPickerDelegate {

    func numberDidChange(number: Int) {
        dollarsAmount = number
        currencyInput.transform = CGAffineTransformMakeScale(0.2, 0.5)

        UIView.animateWithDuration(0.15, delay: 0.0, options: [], animations: {
            self.currencyInput.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        
    }
    
    func touchesDidEnd(){
       invokeCurrencyConversion()
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hiddenInput.hidden = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        hiddenInput.text = ""
        hiddenInput.hidden = false
        invokeCurrencyConversion()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
        let numberFiltered = compSepByCharInSet.joinWithSeparator("")
        let textFieldText: NSString = hiddenInput.text ?? ""
        let txtAfterUpdate = textFieldText.stringByReplacingCharactersInRange(range, withString: string)

        if(string == numberFiltered && txtAfterUpdate.characters.count <= 4) {
            
            dollarsAmount = Int(txtAfterUpdate)!
            pickerControls.setNumber(dollarsAmount)
            return true
        } else {
            return false
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversionResults.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = resultsTable.dequeueReusableCellWithIdentifier("cell") as? CurrencyTableViewCell
        let conversion = conversionResults[indexPath.row]
        
        cell?.currencyCode = conversion.currencyId
        cell?.currencyValue = Float(conversion.dollarsWorth)
        
        return cell!
    }
    
    

}

