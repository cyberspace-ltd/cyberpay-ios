//
//  CPTransactionParams.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation



public struct CPTransactionParams {
    
   public var currency: String = "NGN"
   public var merchantReference: String = ""
   public var amountInKobo: Double = 0
   public var customerName: String = ""
   public var customerEmail: String = ""
   public var customerMobile: String = ""
   public var description: String = ""
   public var transactionReference: String = ""
   public var otp: String = ""
    
    public init() {
        
    }
    
}




