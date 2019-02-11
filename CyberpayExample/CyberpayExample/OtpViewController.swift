//
//  OtpViewController.swift
//  CyberpayExample
//
//  Created by David Ehigiator on 10/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import UIKit
import cyberpaysdk

class OtpViewController: UIViewController {
    
    
    @IBOutlet weak var otpTextField: MaterialFilledTextField!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    var transaction: CPTransactionParams?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        verifyButton.isEnabled = false
        handleTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func onVerifyTapped(_ sender: Any) {
        
        view.endEditing(true)

        self.setLoadingProcess(isLoading: true)
        
        if transaction != nil {
            
            transaction?.otp = otpTextField.text!
            
            CyberpaySDK.shared.verifyOtp(param: transaction!, onSuccess: { (transactionReference) in
                
                self.setLoadingProcess(isLoading: false)
                self.displayMessage("Your payment was successful, Transaction Reference: \(transactionReference)", title: "Success")
                
                //NAVIGATE TO ANOTHER VIEW OR DO SOMETHING ELSE
                
            }) { (error) in
                
                self.setLoadingProcess(isLoading: false)
                self.displayMessage(error ?? "Oops an error occurred", title: "Error")
                
            }
            
        }
        
    }
    
    func handleTextFields() {
        
        otpTextField.addTarget(self, action: #selector(OtpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange(){
        
        guard let otp = otpTextField.text, !otp.isEmpty else {
            
            self.verifyButton.isEnabled =  false
            return
        }
        verifyButton.isEnabled = true
        
    }
    
    func setLoadingProcess(isLoading: Bool)  {
        
        if isLoading {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            verifyButton.isEnabled = false
            activityIndicator.startAnimating()
            
        }
        else {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            verifyButton.isEnabled = true
            activityIndicator.stopAnimating()
            
        }
        
    }
    
    
    func displayMessage(_ message: String, title: String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
        
    }
}
