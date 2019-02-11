//
//  TransactionRequest.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation

/// MODEL PARAMETER REQUESTED FOR THE API
struct TransactionRequest: Encodable {
    
    let Currency: String
    let MerchantRef: String
    let Amount: Double
    let Description: String
    let IntegrationKey: String
    let ReturnUrl: String
    
}
