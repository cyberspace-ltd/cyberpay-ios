//
//  TransactionService.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation


public class CyberpaySDK {
    
    private var apiKey: String!
    
    
    public static let shared = CyberpaySDK()
    
    var isStagingMode = false
    
    public func initializeLiveEnvironment(key: String){
        self.apiKey = key
        isStagingMode = false
    }
    
    public func initializeTestEnvironment(key: String) {
        self.apiKey = key
        isStagingMode = true
    }
    
    private init() {
    }
    
    
    func beginTransaction(param: CPTransactionParams,onSuccess: @escaping (_ transactionReference: String) -> Void, onError: @escaping(_ errorMessage: String?) -> Void){
        
        //todo: throw if public key is not set
        
        let request = TransactionRequest.init(Currency: param.currency, MerchantRef: param.merchantReference, Amount: param.amountInKobo, Description: param.description, IntegrationKey: apiKey, ReturnUrl: "")
        
        CPAPIClient.shared.setTransaction(params: request) { (result) in
            switch result {
            case .success(let apiResult):
                
                if apiResult?.succeeded ?? false {
                    guard let transactionResults = apiResult?.data else { return }
                    onSuccess(transactionResults.transactionReference!)
                }
                else {
                    print("Reached endpoint but failed error \(apiResult?.message ?? "")")
                    onError(apiResult?.message ?? "")
                }
                
            case .failure(let error):
                print("the error \(error)")
                onError(error.customDescription)
            }
        }
        
    }
    
    func chargeCard(param: CPCardParams, transactionRef: String, onSuccess: @escaping (_ reference: String) -> Void, onOtpRequired: @escaping (_ reference: String) -> Void, onError: @escaping(_ errorMessage: String?) -> Void){
        
        //todo: throw if public key is not set
        
        
        let request = ChargeRequest.init(Name: param.customerName, ExpiryMonth: param.expMonth, ExpiryYear: param.expYear, CardNumber: param.number, CVV: param.cvv, Reference: transactionRef)
        
        CPAPIClient.shared.chargeCard(params: request) { (result) in
            switch result {
            case .success(let apiResult):
                
                if apiResult?.succeeded ?? false {
                    guard let transactionResults = apiResult?.data else {
                        return onError("Transaction Failed, ensure the right card details were provided")
                        
                    }
                    
                    switch transactionResults.status!{
                        
                    case "Otp":
                        return onOtpRequired(transactionResults.reference!)
                        
                    case "Failed":
                        return onError(transactionResults.message)
                        
                    case "Success":
                        return onSuccess(transactionResults.reference!)
                        
                    case "Successful":
                        return onSuccess(transactionResults.reference!)
                        
                    default:
                        return onError(transactionResults.message)
                        
                    }
                }
                else {
                    print("Reached endpoint but failed error \(apiResult?.message ?? "")")
                    onError(apiResult?.message ?? "")
                }
                
                
                
                
                
                
            case .failure(let error):
                print("the error \(error)")
                onError(error.localizedDescription)
            }
        }
        
    }
    
    func verifyOtp(param: CPTransactionParams,onSuccess: @escaping (_ result: String) -> Void,  onError: @escaping(_ errorMessage: String?) -> Void){
        
        //todo: throw if public key is not set
        
        let request =  OtpRequest.init(otp: param.otp, reference: param.transactionReference)
        
        CPAPIClient.shared.verifyOtp(params: request) { (result) in
            switch result {
            case .success(let apiResult):
                guard let transactionResults = apiResult?.data else {
                    return onError("Otp verification failed")
                }
                
                switch transactionResults.status!{
                case "Successful":
                    return onSuccess(transactionResults.reference!)
                    
                case "Failed":
                    return onError(transactionResults.message)
                    
                default:
                    return onError(transactionResults.message)
                    
                }
        
            case .failure(let error):
                print("the error \(error)")
                onError(error.localizedDescription)
            }
        }
        
    }
    
    func verifyMerchantTransaction(param: String,onSuccess: @escaping () -> Void,  onError: @escaping(_ errorMessage: String?) -> Void){
        
        //throw if public key is not set
        
        CPAPIClient.shared.verifyMerchantTransaction(queryParam: param) { (result) in
            switch result {
            case .success(let apiResult):
                guard let _ = apiResult?.succeeded else {
                    
                    onError("Transaction not found")
                    
                    return
                }
                
                onSuccess()
                
            case .failure(let error):
                print("the error \(error)")
                onError(error.localizedDescription)
            }
            
            
        }
        
        
    }
    
    
    
    //todo: verify merchant transaction
    
    
}

