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
    
    /// testSignature
    ///
    /// Test then signature encoding algorithm
    
    func testSignature() throws {
        let auth = LuckyCart.testAuthorization
        let signature = auth.computeSignature(timestamp: "1641998862")
        
        XCTAssert(signature.hex == "dd41953d1890072bce9d352edb4fe00aa15a17bea49b65a2ec0a0c87457553d0")
    }
    
    /// testTicketComposer
    ///
    /// Test the ticket composer
    func testTicketComposer() throws {
        
        let composer = LCTicketComposer.test
        
        let dict = try composer.makeDictionary()
        
        print(dict)
    }
    
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
                self.facadeTestCompletion(.postCart, responseType: LCPostCart.self, result: result, expectation: expectation) { result in
                    print("----- Received PostCart Response")
                    print(result)
                }
            }
        }
    }
}
