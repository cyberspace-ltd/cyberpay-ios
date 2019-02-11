//
//  ApiResponse.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation


// MODEL THAT WILL RETURN FROM REQUEST
struct ApiResponse<T: Decodable>: Decodable {
    
    let data: T?
    var succeeded: Bool
}

