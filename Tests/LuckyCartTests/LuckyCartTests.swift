//
//  LuckyCartTests.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.
//

import XCTest
@testable import LuckyCart

/// Public Requests Tests

final class LuckyCartTests: XCTestCase {
    
    func testGetGames() throws {
        try facadeCall(.getGames) { name, expectation in
            try LuckyCart.test.getGames { result in
                self.facadeTestCompletion(name, responseType: [LCGame].self, result: result, expectation: expectation) { result in
                    result.forEach { game in
                        print("-- Game code : \(game.code) --")
                        print(game.isGamePlayable ? "Playable" : "Not PLayable")
                        print(game.gameResult.rawValue)
                    }

                }
            }
        }
    }
    
    func testGetBannerSpaces() throws {
        try facadeCall(.getBannerSpaces) { name, expectation in
            try LuckyCart.test.getBannerSpaces { result in
                self.facadeTestCompletion(name, responseType: LCBannerSpaces.self, result: result, expectation: expectation) { result in
                    print("----- Received Banner Spaces")
                    print(result)
                }
            }
        }
    }
    
    func testGetBanner() throws {
        try facadeCall(.getBanner) { name, expectation in
            try LuckyCart.test.getBanner(banner: "banner") { result in
                self.facadeTestCompletion(name, responseType: LCBanner.self, result: result, expectation: expectation) { result in
                    print("----- Received Banner")
                    print(result)
                }
            }
        }
    }
    
    
    func testPostCart() throws {
        
        try facadeCall(.postCart) { name, expectation in
            try LuckyCart.test.postCart() { result in
                self.facadeTestCompletion(.postCart, responseType: LCRequestResponse.PostCart.self, result: result, expectation: expectation) { result in
                    print("----- Received PostCart Response")
                    print(result)
                }
            }
        }
    }
}
