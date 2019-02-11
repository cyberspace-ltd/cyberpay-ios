//
//  ChargeRequest.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation

struct ChargeRequest : Encodable {
    
    let Name: String
    let ExpiryMonth: Int
    let ExpiryYear: Int
    let CardNumber: String
    let CVV: String
    let Reference: String //transactionReference
    
 
}
