//
//  TransactionResponse.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation

struct TransactionResponse: Decodable {
    
    let transactionReference: String?
    let charge: Int
    let redirectUrl: String?
    
}
