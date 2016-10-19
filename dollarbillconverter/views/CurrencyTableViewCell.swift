//
//  CurrencyTableViewCell.swift
//  dollarbillconverter
//
//  Created by Diego Castaño on 10/3/16.
//  Copyright © 2016 Diego Castaño. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    // views
    var currencyLabel = UILabel()
    var dollarsLabel = SACountingLabel()
    var balanceLabel = UILabel()
    var currencyFlag = UIImageView()
    
    // data
    var currencyCode: String? {
    
        didSet {
            currencyLabel.text = currencyCode
            let flagImage = UIImage(named: currencyCode!);
            currencyFlag.image = flagImage
            
        }
    }
    
    var currencyValue : Float = 0.0 {
        didSet {
            dollarsLabel.alpha = 0.0;
            var t = CGAffineTransformIdentity
            t = CGAffineTransformTranslate(t, CGFloat(0), CGFloat(15))
            dollarsLabel.transform = t
            dollarsLabel.animateToValue(currencyValue)
            
            UIView.animateWithDuration(0.7, delay: 0.0, options: [.CurveEaseInOut], animations: {
                self.dollarsLabel.alpha = 1
                self.dollarsLabel.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(dollarsLabel)
        contentView.addSubview(currencyLabel)
        contentView.addSubview(currencyFlag)
        contentView.addSubview(balanceLabel)
        
        //appearance
        
        dollarsLabel.font = AppFonts.fontOfType(.Black, withSize: 48)
        currencyLabel.font = AppFonts.fontOfType(.Light, withSize:20)
        
        //autolayout
        
        dollarsLabel.snp_makeConstraints() { make in
            make.top.left.equalTo(contentView)
        }
        
        currencyFlag.snp_makeConstraints() { make in
            make.top.equalTo(dollarsLabel.snp_bottom).offset(5)
            make.left.equalTo(contentView)
        }
        
        currencyLabel.snp_makeConstraints() { make in
            make.centerY.equalTo(currencyFlag)
            make.left.equalTo(currencyFlag.snp_right).offset(15)
        }
    }

}
