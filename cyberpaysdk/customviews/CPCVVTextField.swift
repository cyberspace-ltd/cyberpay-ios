//
//  CPCVVTextField.swift
//  cyberpay
//
//  Created by David Ehigiator on 08/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import UIKit

@IBDesignable
public class CPCVVTextField: MaterialFilledTextField {
    
    
   public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    public override func prepareForInterfaceBuilder() {
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        super.delegate = self
        self.placeholder = "123"
        keyboardType = .numberPad
        autocorrectionType = .no
        self.borderStyle = BorderStyle.none

    }
    
   public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 3
    }
}
