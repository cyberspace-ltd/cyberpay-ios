//
//  CardTextField.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import UIKit


@IBDesignable
public class MaterialFilledTextField: UITextField, UITextFieldDelegate {
    
   public var bottomBorder = UIView()

    
    override public func awakeFromNib() {
        
        // Setup Bottom-Border
        self.backgroundColor = UIColor(hexString: "#f5f5f5")
        self.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor(hexString: "#bdbdbd")// Set Border-Color
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bottomBorder)
        
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
        
        self.roundCorners(cornerRadius: 4.0)
        self.setLeftPaddingPoints(8)
        self.setRightPaddingPoints(8)
        
        delegate = self
    }
    
   public var change: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = self.change ?  UIColor(hexString: "#e3f2fd") : UIColor(hexString: "#f5f5f5")
                self.bottomBorder.backgroundColor = self.change ? UIColor(hexString: "#1e88e5"): UIColor(hexString: "#bdbdbd")
            }
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.change = true
    }
    
  public   func textFieldDidEndEditing(_ textField: UITextField) {
        self.change = false
    }
    
    

   public func roundCorners(cornerRadius: Double) {
        
        
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = CGFloat(cornerRadius)
            self.clipsToBounds = true
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
        
       
    }
    
  public  func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
  public  func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
    



