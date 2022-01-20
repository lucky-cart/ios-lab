//
//  LuckyCartTests.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.
//

import XCTest
@testable import LuckyCart

extension Dictionary {
    
    func string(_ key: Any?, fallback: String = "<nil>") -> String {
        guard let key = key as? String, let dict = self as? [String: Any?] else {
            return "<wrong key>"
        }
        
        guard let str = dict[key] as? String else {
            return fallback
        }
        return str
    }
    
    func test(name: String, key: String, match: String) {
        print("\(name).\(key) = \(string(key))")
        XCTAssert(string(key) == match)
    }
    
    func testNotNil(name: String, key: String) {
        print("\(name).\(key) = \(string(key))")
        XCTAssert(string(key) != "<nil>")
    }
}

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
        
        let parameters = LCRequestParameters.PostCart(cart: LuckyCart.testCart,
                                                      customer:  LuckyCart.testCustomer,
                                                      ticketComposer: composer)
        
        // We create a request to inspect the final body ( ticket composer info + authorization )
        let request: LCRequest<Model.PostCartResponse> = try LCNetwork(authorization: LuckyCart.testAuthorization).buildRequest(name: .postCart,
                                                                                      parameters: nil,
                                                                                      body: parameters)
        let dict = try parameters.dictionary(for: request)
        
        dict.testNotNil(name: "dict", key: Keys.auth_ts)
        dict.testNotNil(name: "dict", key: Keys.auth_sign)
        dict.testNotNil(name: "dict", key: Keys.auth_nonce)
        
        dict.test(name: "dict", key: Keys.auth_key, match: LuckyCart.testAuthKey)
        dict.test(name: "dict", key: Keys.auth_v, match: "2.0")
        
        dict.test(name: "dict", key: Keys.customerId, match: LuckyCart.testCustomer.id)
        dict.test(name: "dict", key: Keys.customerClientId, match: "41410788")
        dict.test(name: "dict", key: Keys.email, match: "vincentoliveira@luckycart.com")
        dict.test(name: "dict", key: Keys.lastName, match: "OLIVEIRA")
        dict.test(name: "dict", key: Keys.firstName, match: "VINCENT")
        
        dict.test(name: "dict", key: Keys.cartId, match: LuckyCart.testCart.id)
        dict.test(name: "dict", key: Keys.cartClientId, match: "client_cart_5c1e51fda")
        
        dict.test(name: "dict", key: Keys.totalAti, match: "12.00")
        dict.test(name: "dict", key: Keys.loyaltyCart, match: "")
        dict.test(name: "dict", key: Keys.currency, match: "EUR")
        dict.test(name: "dict", key: Keys.ht, match: "10.00")
        
        dict.test(name: "dict", key: Keys.shopId, match: "A75710")
        dict.test(name: "dict", key: Keys.shippingMethod, match: "pickup")
        dict.test(name: "dict", key: Keys.device, match: "ios-test-optin")
        
        if let products = dict[Keys.products] as? [String: String] {
            products.test(name: "products", key: Keys.quantity, match: "1.00")
            products.test(name: "products", key: Keys.ttc, match: "12.00")
            products.test(name: "products", key: Keys.ht, match: "10.00")
            products.test(name: "products", key: Keys.id, match: "14917412")
        }

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
                    XCTAssert(result.baseDesktopUrl == LuckyCart.testPostCartResponse.baseDesktopUrl)
                    XCTAssert(result.baseMobileUrl == LuckyCart.testPostCartResponse.baseMobileUrl)
                    XCTAssert(result.baseTabletUrl == LuckyCart.testPostCartResponse.baseTabletUrl)
                    XCTAssert(result.mobileUrl == LuckyCart.testPostCartResponse.mobileUrl)
                    XCTAssert(result.tabletUrl == LuckyCart.testPostCartResponse.tabletUrl)
                    XCTAssert(result.desktopUrl == LuckyCart.testPostCartResponse.desktopUrl)
                    XCTAssert(result.ticket == LuckyCart.testPostCartResponse.ticket)
                }
            }
        }
    }
}
