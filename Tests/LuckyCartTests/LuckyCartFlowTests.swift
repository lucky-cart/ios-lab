//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 13/01/2022.
//

import Foundation


import XCTest
@testable import LuckyCart

/// Public Requests Tests

final class LuckyCartFlowTests: XCTestCase {
    
    func testFlow() throws {
        let expectation = XCTestExpectation(description: "expectation")
        let bannerSpacesExpectation = XCTestExpectation(description: "bannerSpacesExpectation")
        
        do {
            
            print(" === 1 Check In")
            
            let luckyCart = LuckyCart(authorization: LuckyCart.testAuthorization,
                                      customer: LuckyCart.testCustomer,
                                      cart: LuckyCart.testCart)
            
            print(" === 2 Get Banners")
            
            luckyCart.loadBannerSpaces(failure: { error in
                XCTFail("GetBannerSpaces Failed - \(error.localizedDescription)")
                bannerSpacesExpectation.fulfill()
                expectation.fulfill()
            }, success: { bannerSpaces in
                print("GetBannerSpaces Succeed")
                bannerSpacesExpectation.fulfill()

            })
            
            
            _ = XCTWaiter.wait(for: [bannerSpacesExpectation], timeout: 10)
            
            print(" === 3 - Check banner for View Identifier 'homepage'")
            
            if let bannerSpace = luckyCart.bannerSpaces?["homepage"] {
                
                if let firstId = bannerSpace.bannerIds.first {
                    
                    
                    luckyCart.banner(with: firstId) { error in
                        XCTFail("GetBanner Failed - \(error.localizedDescription)")
                        bannerSpacesExpectation.fulfill()
                        expectation.fulfill()
                    } success: { bnner in
                        print("GetBanner Succeed")
                        expectation.fulfill()
                    }
                }
                else {
                    XCTFail("Lucky Cart `homePage` bannerSpace not set")
                }
            }
        }
        
        _ = XCTWaiter.wait(for: [expectation], timeout: 10)
    }
}
