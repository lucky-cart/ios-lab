//
//  LuckyCartTests+Utils.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 13/01/2022.
//

import XCTest
@testable import LuckyCart

/// LuckyCart XC Texts Utilities

extension LuckyCartTests {
    
    /// facadeCall
    ///
    /// Call this to test requests calls.
    ///
    /// ```
    /// try facadeCall(.<my_request_name>) { name, expectation in
    ///    try LuckyCart.test.<my_request> { result in
    ///        self.facadeTestCompletion(name, responseType: <my_response_type>.self, result: result, expectation: expectation) { result in
    ///            print(result)
    ///        }
    ///    }
    /// }
    /// ```

    func facadeCall(_ request: LCRequestName, function: @escaping ((LCRequestName, XCTestExpectation) throws -> Void)) rethrows {
        print("----- Execute Request : ")
        let expectation = XCTestExpectation(description: "loaded")
        
        try function(request, expectation)
        
        XCTWaiter().wait(for: [expectation], timeout: 10)
        print("-- Done --")
    }
    
    /// facadeTestCompletion
    ///
    /// function to pass in request completion when called from facadeCall
    
    func facadeTestCompletion<T: Codable>(_ request: LCRequestName, responseType: T.Type, result: Result<Any,Error>, expectation: XCTestExpectation, success: (T)->Void) {
        switch result {
        case .failure(let error):
            print("\(request.rawValue) test failed \(error)")
            expectation.fulfill()
        case .success(let result):
            guard let result = result as? T else {
                expectation.fulfill()
                XCTFail()
                return
            }
            print("----- Received \(responseType)")
            success(result)
            expectation.fulfill()
        }
    }
}
