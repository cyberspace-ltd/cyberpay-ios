//
//  ViewController.swift
//  CyberpayExample
//
//  Created by David Ehigiator on 08/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import UIKit
import cyberpaysdk
class ViewController: UIViewController {
    
    @IBOutlet weak var cardNumberTextField: CPCardNumberTextField!
    
    @IBOutlet weak var expiryDateTextField: CPDateTextField!
    
    @IBOutlet weak var cvvTextField: CPCVVTextField!
    
    @IBOutlet weak var paymentButton: UIButton!
    
    @IBOutlet weak var amountTextField: MaterialFilledTextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var transaction = CPTransactionParams()
    
    var card = CPCardParams()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        paymentButton.isEnabled = false
        handleTextFields()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OtpViewController {
            let destination = segue.destination as? OtpViewController
            destination?.transaction = self.transaction
        }
    }
    
    @IBAction func onPayTapped(_ sender: Any) {
        view.endEditing(true)

        //STEP 1: Set the card & transaction details
        initializePaymentParameters()
        
        //STEP 2: Begin transaction
        beginTransaction()
        
    }
    
    func initializePaymentParameters(){
        let cardNumber = self.cardNumberTextField.text!
        card.number = cardNumber.replacingOccurrences(of: " ", with: "")//removing the whitespace
        
        card.cvv = self.cvvTextField.text!
        card.expMonth = Int(self.expiryDateTextField.month)!
        card.expYear = Int(self.expiryDateTextField.year)!
        
        let amount = Double.init(amountTextField.text!)
        
        let amountInKobo = amount! * 100
        let identifier = UUID()

        transaction.amountInKobo = amountInKobo
        transaction.description = "Sample transaction from iOS SDK" //Replace with your transaction description
        transaction.merchantReference = identifier.uuidString //Replace with your merchant reference
        
        
//        ADD OPTIONAL TRANSACTION PARAMS
//        transaction.customerEmail
//        transaction.customerName
//        transaction.customerMobile
        

    }
    
    func handleTextFields() {
        
        cardNumberTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        expiryDateTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        cvvTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        amountTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange(){
        
        guard let cardNumber = cardNumberTextField.text, !cardNumber.isEmpty, let date = expiryDateTextField.text, !date.isEmpty,let cvv = cvvTextField.text, !cvv.isEmpty, let amount = amountTextField.text, !amount.isEmpty  else {
            
            self.paymentButton.isEnabled =  false
            return
        }
        paymentButton.isEnabled = true
        
    }
    func beginTransaction(){
        
        setLoadingProcess(isLoading: true)
        
        CyberpaySDK.shared.beginTransaction(param: transaction, onSuccess: { (transactionReference) in
            
            self.setLoadingProcess(isLoading: false)
            
            self.transaction.transactionReference = transactionReference
            
            //STEP 3: Charge Card
            self.chargeCard()
            
        }) { (error) in
            
            self.setLoadingProcess(isLoading: false)
            self.displayMessage(error ?? "Oops an error occurred", title: "Error")
            
        }
        
    }
    
    
    func setLoadingProcess(isLoading: Bool)  {
        
        if isLoading {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            paymentButton.isEnabled = false
            activityIndicator.startAnimating()
            
        }
        else {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            paymentButton.isEnabled = true
            activityIndicator.stopAnimating()
            
        }
        
    }
    
    func chargeCard()  {
        
        self.setLoadingProcess(isLoading: true)
        CyberpaySDK.shared.chargeCard(param: card, transactionRef: transaction.transactionReference, onSuccess: { (transRef) in
            
            self.setLoadingProcess(isLoading: false)
            
            self.displayMessage("Your payment was successful, Transaction Reference: \(transRef)", title: "Success")
            
            
        }, onOtpRequired: { (transRef) in
            
            self.setLoadingProcess(isLoading: false)
            
            self.performSegue(withIdentifier: "go-to-otp", sender: self)
            
            
        }) { (error) in
            
            self.setLoadingProcess(isLoading: false)
            
            self.displayMessage(error ?? "Oops an error occurred", title: "Error")
        }
        
    }
    
    func displayMessage(_ message: String, title: String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
        
    }
    
}

