//
//  OtpResponse.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation

struct OtpResponse: Decodable {
    
    let reference: String?
    let processorReference: String?
    let status: String?
    let redirectUrl: String?
    let message: String?
    let reason: String?
    let responseAction: String?

}

