//
//  CPAPIClient.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation

class CPAPIClient: GenericAPIClient {
    
    internal let session: URLSession

    static let shared = CPAPIClient()

    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
  
   private convenience init() {
        self.init(configuration: .default)
    }
    
    
    
   public func setTransaction(params: TransactionRequest, completion: @escaping (Result<ApiResponse<TransactionResponse>?, APIError>) -> ()) {
        
        let parameter = params
        
        guard let request = CPAPIEndpoint.beginTransaction.postRequest(parameters: parameter,
                                                         headers: [HTTPHeader.contentType("application/json")]) else { return }
        fetch(with: request , decode: { json -> ApiResponse<TransactionResponse>? in
            guard let results = json as? ApiResponse<TransactionResponse> else { return  nil }
            return results
        }, completion: completion)
        
    }
    
    
    public func chargeCard(params: ChargeRequest, completion: @escaping (Result<ApiResponse<ChargeResponse>?, APIError>) -> ()) {
        
        let parameter = params
        
        guard let request = CPAPIEndpoint.chargeCard.postRequest(parameters: parameter,
                                                                       headers: [HTTPHeader.contentType("application/json")]) else { return }
        fetch(with: request , decode: { json -> ApiResponse<ChargeResponse>? in
            guard let results = json as? ApiResponse<ChargeResponse> else { return  nil }
            return results
        }, completion: completion)
        
    }
    
  public  func verifyOtp(params: OtpRequest, completion: @escaping (Result<ApiResponse<OtpResponse>?, APIError>) -> ()) {
        
        let parameter = params
        
        guard let request = CPAPIEndpoint.verifyOtp.postRequest(parameters: parameter,
                                                                 headers: [HTTPHeader.contentType("application/json")]) else { return }
        fetch(with: request , decode: { json -> ApiResponse<OtpResponse>? in
            guard let results = json as? ApiResponse<OtpResponse> else { return  nil }
            return results
        }, completion: completion)
        
    }
    
   public func verifyMerchantTransaction(queryParam: String, completion: @escaping (Result<ApiResponse<VerifyTransactionResponse>?, APIError>) -> ()) {
        
        
        guard let request = CPAPIEndpoint.verifyMerchantTransaction.getRequest(parameters: ["merchantRef" : queryParam ],  headers: [HTTPHeader.contentType("application/json")]) else { return }
        
        fetch(with: request , decode: { json -> ApiResponse<VerifyTransactionResponse>? in
            guard let results = json as? ApiResponse<VerifyTransactionResponse> else { return  nil }
            return results
        }, completion: completion)
        
    }
    
    
  
}







enum CPAPIEndpoint {
    case beginTransaction
    case chargeCard
    case verifyMerchantTransaction
    case verifyOtp
}

extension CPAPIEndpoint: Endpoint {
    
    
    var base: String {

        get {
            if (CyberpaySDK.shared.isStagingMode){
                return "https://payment-api.staging.cyberpay.ng/api/v1/"
            }
            else {
                return "https://payment-api.cyberpay.ng/api/v1/"
            }
        }
        set {
            
        }
    }
    
    var path: String {
        switch self {
        case .beginTransaction: return "payments"
        case .chargeCard: return "payments/card"
        case .verifyMerchantTransaction: return "transactions"
        case .verifyOtp: return "payments/otp"
            
        }
    }
}

