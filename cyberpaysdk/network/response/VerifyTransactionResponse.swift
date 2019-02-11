//
//  VerifyTransactionResponse.swift
//  cyberpaysdk
//
//  Created by David Ehigiator on 08/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation

struct VerifyTransactionResponse: Decodable {
    
    let status: String?
    let processorCode: String?
    
}

