//
//  Result.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

