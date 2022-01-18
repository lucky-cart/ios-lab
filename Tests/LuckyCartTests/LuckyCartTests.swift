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
        facadeCall(.getGames) { name, expectation in
            LuckyCart.test.getGames { result in
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
        facadeCall(.getBannerSpaces) { name, expectation in
            LuckyCart.test.getBannerSpaces { result in
                self.facadeTestCompletion(name, responseType: LCBannerSpaces.self, result: result, expectation: expectation) { result in
                    print("----- Received Banner Spaces")
                    print(result)
                }
            }
        }
    }
    
    func testGetBanner() throws {
        facadeCall(.getBanner) { name, expectation in
            LuckyCart.test.getBanner(bannerIdentifier: "banner") { result in
                self.facadeTestCompletion(name, responseType: LCBanner.self, result: result, expectation: expectation) { result in
                    print("----- Received Banner")
                    print(result)
                }
            }
        }
    }
    
    
    func testPostCart() throws {
        facadeCall(.postCart) { name, expectation in
            LuckyCart.test.postCart(ticketComposer: LCTicketComposer.test) { result in
                self.facadeTestCompletion(.postCart, responseType: LCPostCartResponse.self, result: result, expectation: expectation) { result in
                    print("----- Received PostCart Response")
                    print(result)
                }
            }
        }
    }
}
