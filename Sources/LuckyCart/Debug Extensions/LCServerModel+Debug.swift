//
//  LCServerModel+Debug.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation


/// "auth_key": "ugjArgGw",
/// "auth_ts": "1641998862",
/// "auth_sign": "dd41953d1890072bce9d352edb4fe00aa15a17bea49b65a2ec0a0c87457553d0",
/// "auth_v": "2.0",


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

