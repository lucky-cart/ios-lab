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
            
            try luckyCart.getBannerSpaces { result in
                switch result {
                case .failure(let error):
                    XCTFail("GetBannerSpaces Failed - \(error.localizedDescription)")
                    bannerSpacesExpectation.fulfill()
                    expectation.fulfill()
                case .success(let bannerSpaces):
                    print("GetBannerSpaces Succeed")
                    bannerSpaces.spaces.forEach { space in
                        print("==> Space `\(space.identifier)`")
                        space.bannerIds.forEach { bannerId in
                            print("  ==> Banner `\(bannerId)`")
                        }
                    }
                    
                    bannerSpacesExpectation.fulfill()
                }
            }
            
            
            XCTWaiter.wait(for: [bannerSpacesExpectation], timeout: 10)
            
            print(" === 3 - Check banner for View Identifier 'homepage'")
            
            if let bannerSpace = luckyCart.bannerSpaces?["homepage"] {
                
                if let firstId = bannerSpace.bannerIds.first {
                    
                    
                    try luckyCart.getBanner(banner: firstId) { result in
                        switch result {
                        case .failure(let error):
                            XCTFail("GetBanner Failed - \(error.localizedDescription)")
                            bannerSpacesExpectation.fulfill()
                            expectation.fulfill()
                        case .success(let banner):
                            print("GetBanner Succeed")
                            
                        }
                    }
                }
                else {
                    XCTFail("Lucky Cart `homePage` bannerSpace not set")
                }
            }
        }
        catch {
            XCTFail("Test Flow Failed : \(error.localizedDescription)")
            expectation.fulfill()
        }
        
        XCTWaiter.wait(for: [expectation], timeout: 10)
    }
}
