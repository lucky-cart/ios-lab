//
//  LuckyCart+Debug.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation


// MARK: - Public static entities for testing

#if DEBUG

/// Client model test entitites

public extension LuckyCart {
    static var testAuthKey = "ugjArgGw"
    static var testSecret = "p#91J#i&00!QkdSPjgGNJq"
}

public extension LuckyCart {
    
    static let testAuthorization = LCAuthorization(key: testAuthKey, secret: testSecret)
    
    internal static let testSignature = testAuthorization.computeSignature(timestamp: "664354523")
    
    static var test: LuckyCart {
        LuckyCart.shared ?? LuckyCart.init(authorization: LuckyCart.testAuthorization,
                                           customer: LuckyCart.testCustomer)
    }
    
    static let testGame = LCGame(Model.testGame)
    
    static let testCustomer = LCCustomer(Model.testCustomer)
    
    static let testCart = LCCart(Model.testCart)
    
    static let testBannerSpaces = LCBannerSpaces(Model.testBannerSpaces)
    
    static let testBanner = LCBanner(Model.testBanner)
    
    static let testPostCartResponse = LCPostCartResponse(Model.testPostCartResponse)
}

// MARK: - Private test objects

extension LCNetwork {
    static let testApi = LCConnection(server: .api, authorization: LuckyCart.testAuthorization)
    static let testPromoMatching = LCConnection(server: .promo, authorization: LuckyCart.testAuthorization)
}

/// Keys for the data sent int the sendCart request
struct TestKeys {
    // Customer
    static let lastName = "lastName"
    static let firstName = "firstName"
    static let email = "email"
    // Cart
    static let totalAti = "totalAti"
    static let currency = "currency"
    static let products = "products"
    static let loyaltyCart = "loyaltyCart"
    // Product
    static let quantity = "quantity"
    static let id = "id"
    static let ht = "ht"
    static let ttc = "ttc"
    // Order
    static let shopId = "shopId"
    static let shippingMethod = "shippingMethod"
    static let device = "device"
    
    static let customerId = "customerId"
    static let cartId = "cartId"
}

#endif

// MARK: - Static entities for testing -

#if DEBUG

/// Static test objects ready to use in SwiftUI previews, UI Tests and Unit Tests

extension Model {
    
    static let promoTestUrl = "https://promomatching.luckycart.com/61d6c677baa1676dd46bfee6/\(testCustomer.id)"
    static let apiTestUrl = "https://api.luckycart.com"
    static let goTestUrl = "https://go.luckycart.com"
    
    static let testGame = Model.Game(code: "QLWG-SHYR-MGBZ-SLXK",
                                     isGamePlayable: true,
                                     gameResult: .notPlayed,
                                     desktopGameUrl: URL(string: "\(apiTestUrl)/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/url")!,
                                     desktopGameImage: URL(string: "\(apiTestUrl)/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/image")!,
                                     mobileGameUrl: URL(string: "\(apiTestUrl)/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/url")!,
                                     mobileGameImage: URL(string: "\(apiTestUrl)/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/image")!
    )
    
    static let testBannerSpaces:  [String : [String]] = [
        "homepage": ["banner"] ,
        "categories": ["banner_100",
                       "banner_200",
                       "search_100",
                       "search_200"
                      ]]
    
    static let testCustomer = Model.Customer(id: "customer1234")
    
    static let testCart = Model.Cart(id: "cart_1234")
    
    static let testBanner = Model.Banner(image_url: URL( string: "\(promoTestUrl)/image?meta=61bb057807879bee01ed5298&test=true&noCache1641942555414")!,
                                         redirect_url: URL(string: "\(promoTestUrl)/jump?meta=61bb057807879bee01ed5298&test=true")!,
                                         name: "QA ITW Assessment",
                                         campaign: "61bb057807879bee01ed5298",
                                         space: "61d6c677baa1676dd46bfee6",
                                         action: Model.BannerAction(type: "boutique", ref: ""))
    
    static let testPostCartResponse = PostCartResponse(ticket: "QLWG-SHYR-MGBZ-SLXK",
                                                       mobileUrl: "\(apiTestUrl)/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/url",
                                                       tabletUrl: "\(apiTestUrl)/replacement/QLWG-SHYR-MGBZ-SLXK/tablet/url",
                                                       desktopUrl: "\(apiTestUrl)/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/url",
                                                       baseMobileUrl: "\(goTestUrl)/mobile/QLWG-SHYR-MGBZ-SLXK",
                                                       baseTabletUrl: "\(goTestUrl)/tablet/QLWG-SHYR-MGBZ-SLXK",
                                                       baseDesktopUrl: "\(goTestUrl)/lc__team__qa/NX5PDN/play/QLWG-SHYR-MGBZ-SLXK")
}

#endif

