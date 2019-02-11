//
//  CPCardNumberTextField.swift
//  cyberpay
//
//  Created by David Ehigiator on 08/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import UIKit

@IBDesignable
public class CPCardNumberTextField: MaterialFilledTextField {
    
   public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
  
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setIcon(getFrameworkImage(named: "credit-card-icon")!)

    }
    
    public override func prepareForInterfaceBuilder() {
        setup()
    }
    
    public func setup() {
        delegate = self
        self.placeholder = "XXXX XXXX XXXX XXXX"
        self.borderStyle = BorderStyle.none
        keyboardType = .numberPad
        autocorrectionType = .no
    }
    
   public func getFrameworkImage(named:String) -> UIImage? {
        let bundle = Bundle(for: type(of: self))
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
    
    
  public  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //range.length will be greater than 0 if user is deleting text - allow it to replace
        if range.length > 0
        {
            return true
        }
        
        //Don't allow empty strings
        if string == " "
        {
            return false
        }
        
        //Check for max length including the spacers we added
        if range.location == 24
        {
            return false
        }
        
        var originalText = self.text
        let replacementText = string.replacingOccurrences(of: " ", with: "")
        
        //Verify entered text is a numeric value
        let digits = NSCharacterSet.decimalDigits
        for char in replacementText.unicodeScalars
        {
            if !digits.contains(char)
            {
                return false
            }
        }
        
        //Put an empty space after every 4 places
        if originalText!.count  % 5 == 0
        {
            originalText?.append(contentsOf: " ")
            textField.text = originalText
        }
//
//        if originalText!.count > 3 {
//            self.setIcon(cardImage(forState: CardState(fromPrefix: string)) ?? UIImage())
//        }
//        else {
//            self.setIcon(UIImage(named: "credit-card-icon")!)
//        }

      

        
        return true
    }
    
     func cardImage(forState cardState:CardState) -> UIImage? {
        switch cardState {
        case .identified(let cardType):
            switch cardType{
            case .visa:
                return getFrameworkImage(named: "visa-icon")
            case .masterCard:
                return getFrameworkImage(named: "mastacard-icon")
            }
        case .indeterminate:
            return getFrameworkImage(named: "credit-card-icon")

        case .invalid:
            return getFrameworkImage(named: "credit-card-icon")

        }
    }
    
}

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 0, y: 5, width: 30, height: 30))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 40, height: 40))
        
        
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always
    }
}
