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
        
        let composer = LuckyCartTests.testSendCartComposer
        
        let parameters = LCRequestParameters.SendCart(customerId: LuckyCart.testCustomer.id,
                                                      cartId: LuckyCart.testCart.id,
                                                      ticketComposer: composer)
        
        // We create a request to inspect the final body ( ticket composer info + authorization )
        let request: LCRequest<Model.PostCartResponse> = try LCNetwork(authorization: LuckyCart.testAuthorization).buildRequest(name: .sendCart,
                                                                                                                                parameters: nil,
                                                                                                                                body: parameters)
        let dict = try parameters.dictionary(for: request)
        
        dict.testNotNil(name: "dict", key: PostCartJSONComposer.Keys.auth_ts)
        dict.testNotNil(name: "dict", key: PostCartJSONComposer.Keys.auth_sign)
        dict.testNotNil(name: "dict", key: PostCartJSONComposer.Keys.auth_nonce)
        
        dict.test(name: "dict", key: PostCartJSONComposer.Keys.auth_key, match: LuckyCart.testAuthKey)
        dict.test(name: "dict", key: PostCartJSONComposer.Keys.auth_v, match: "2.0")
        
        dict.test(name: "dict", key: PostCartJSONComposer.Keys.customerId, match: LuckyCart.testCustomer.id)
        dict.test(name: "dict", key: PostCartJSONComposer.Keys.cartId, match: LuckyCart.testCart.id)
        
        dict.test(name: "dict", key: TestKeys.email, match: "vincentoliveira@luckycart.com")
        dict.test(name: "dict", key: TestKeys.lastName, match: "OLIVEIRA")
        dict.test(name: "dict", key: TestKeys.firstName, match: "VINCENT")
    
        
        dict.test(name: "dict", key: TestKeys.totalAti, match: "12.00")
        dict.test(name: "dict", key: TestKeys.loyaltyCart, match: "")
        dict.test(name: "dict", key: TestKeys.currency, match: "EUR")
        dict.test(name: "dict", key: TestKeys.ht, match: "10.00")
        
        dict.test(name: "dict", key: TestKeys.shopId, match: "A75710")
        dict.test(name: "dict", key: TestKeys.shippingMethod, match: "pickUp")
        dict.test(name: "dict", key: TestKeys.device, match: "ios-test-optin")
        
        if let products = dict[TestKeys.products] as? [String: String] {
            products.test(name: "products", key: TestKeys.quantity, match: "1.00")
            products.test(name: "products", key: TestKeys.ttc, match: "12.00")
            products.test(name: "products", key: TestKeys.ht, match: "10.00")
            products.test(name: "products", key: TestKeys.id, match: "14917412")
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
    
    func testGetHomePageBanner() throws {
        facadeCall(.getBanner) { name, expectation in
            LuckyCart.test.getBanner(bannerSpaceIdentifier: "homepage", bannerIdentifier: "banner", format: "banner") { result in
                self.facadeTestCompletion(name, responseType: LCBanner.self, result: result, expectation: expectation) { result in
                    print("----- Received Banner")
                    print(result)
                }
            }
        }
    }
    
    func testGetCategoriesBanner() throws {
        facadeCall(.getBanner) { name, expectation in
            LuckyCart.test.getBanner(bannerSpaceIdentifier: "categories", bannerIdentifier: "100", format: "banner") { result in
                self.facadeTestCompletion(name, responseType: LCBanner.self, result: result, expectation: expectation) { result in
                    print("----- Received Banner")
                    print(result)
                }
            }
        }
    }
    
    
    func testPostCart() throws {
        facadeCall(.sendCart) { name, expectation in
            LuckyCart.test.sendCart(cartId: LuckyCart.testCart.id, ticketComposer: LuckyCartTests.testSendCartComposer) { result in
                self.facadeTestCompletion(.sendCart, responseType: LCPostCartResponse.self, result: result, expectation: expectation) { result in
                    print("----- Received SendCart Response")
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

extension LuckyCartTests {
    
    static var testSendCartComposer: LCTicketComposer {
        
        // Returns full json composer
        return LCDictionaryComposer(dictionary: [
            TestKeys.loyaltyCart: "",
            
            TestKeys.email: "vincentoliveira@luckycart.com",
            TestKeys.firstName: "VINCENT",
            TestKeys.lastName: "OLIVEIRA",
            
            TestKeys.shippingMethod: "pickUp",
            TestKeys.shopId: "A75710",
            TestKeys.device: "ios-test-optin",
            
            TestKeys.currency: "EUR",
            TestKeys.totalAti: LuckyCart.priceString(12),
            TestKeys.ht: LuckyCart.priceString(10),
            TestKeys.products : [
                TestKeys.id: "14917412",
                TestKeys.quantity: "1.00",
                TestKeys.ttc: LuckyCart.priceString(12),
                TestKeys.ht: LuckyCart.priceString(10)
            ]
            
        ])
    }
    static let testTicketJson: [String: Any] = [
        TestKeys.shippingMethod: "pickup",
        TestKeys.customerId: "41410788",
        TestKeys.totalAti: "12.00",
        TestKeys.lastName: "OLIVEIRA",
        TestKeys.firstName: "VINCENT",
        TestKeys.ht: "10.00",
        TestKeys.products: [
            TestKeys.ttc: "12.00",
            TestKeys.quantity: "1.00",
            TestKeys.ht: "10.00",
            TestKeys.id: "14917412"
        ],
        TestKeys.shopId: "A75710",
        TestKeys.email: "vincentoliveira@luckycart.com",
        TestKeys.currency: "EUR",
        TestKeys.device: "ios-test-optin",
        TestKeys.cartId: LuckyCart.testCart.id,
        TestKeys.loyaltyCart: ""
    ]
}
