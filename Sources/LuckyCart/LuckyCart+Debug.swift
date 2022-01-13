//
//  File.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation

#if DEBUG

// MARK: - Public test objects

/// Client model test entitites

public extension LuckyCart {

    static let testAuthorization = LCAuthorization(key: "ugjArgGw", secret: "p#91J#i&00!QkdSPjgGNJq")
    
    static let test: LuckyCart = LuckyCart.init(authorization: LuckyCart.testAuthorization,
                                customer: LuckyCart.testCustomer,
                                cart: LuckyCart.testCart)
    
    static let testGame = LCGame(Model.testGame)
    
    static let testCustomer = LCCustomer(Model.testCustomer)
    
    static let testCart = LCCart(Model.testCart)
    
    static let testBannerSpaces = LCBannerSpaces(Model.testBannerSpaces)
    
    static let testBanner = LCBanner(Model.testBanner)
    
}

// MARK: - Private test objects

extension LCNetwork {
    static let testApi = LCConnection(server: .api, authorization: LuckyCart.testAuthorization)
    static let testPromoMatching = LCConnection(server: .promo, authorization: LuckyCart.testAuthorization)
}


#endif
