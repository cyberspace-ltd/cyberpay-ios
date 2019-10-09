//
//  cyberpaysdkTests.swift
//  cyberpaysdkTests
//
//  Created by David Ehigiator on 08/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import XCTest
@testable import cyberpaysdk

class cyberpaysdkTests: XCTestCase {
    
    var sdk: CyberpaySDK!
    var transactionParams = CPTransactionParams()
    var card = CPCardParams()
    
    override func setUp() {
        super.setUp()
        CyberpaySDK.shared.initializeTestEnvironment(key: "7b03633edd5b40a880bbef855159d31d")
        
        card.number = "5399830000000008"
        
        card.cvv = "000"
        card.expMonth = 05
        card.expYear = 30
        
        transactionParams.amountInKobo = 2100000
        transactionParams.description = "Unit test for Cyberpay SDK iOS"
        let identifier = UUID()
        transactionParams.merchantReference = identifier.uuidString
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testChargeCard() {
        
        let promise = expectation(description: "Card was successfully charged")
        
        CyberpaySDK.shared.beginTransaction(param: transactionParams, onSuccess: { (ref) in
            CyberpaySDK.shared.chargeCard(param: self.card, transactionRef: ref, onSuccess: { (ref) in
                promise.fulfill()
                
            }, onOtpRequired: { (ref) in
                promise.fulfill()
                
            }) { (err) in
                XCTFail("Transaction Failed. Err : \(err!)")
                
            }
            
        }) { (err) in
            XCTFail("Transaction Failed. Err : \(err!)")
            return
        }
        
        
        
        wait(for: [promise], timeout: 30)
        
    }
    
    func testSuccessfulBeginTransaction() {
        
        let promise = expectation(description: "Transaction returned a proper transaction reference")
        
        CyberpaySDK.shared.beginTransaction(param: transactionParams, onSuccess: { (ref) in
            
            promise.fulfill()
            
        }) { (err) in
            XCTFail("Transaction Failed. Err : \(err!)")
            return
        }
        
        wait(for: [promise], timeout: 20)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
