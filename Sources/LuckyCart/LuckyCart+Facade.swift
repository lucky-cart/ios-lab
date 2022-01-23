//
//  LuckyCart+Facade.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation
import CryptoKit

/// LuckyCart Facade Requests
///
/// Public request calls.
///
/// When request is called, the private request is called, then the result is casted to client model, and finally cached

extension LuckyCart {
    
    /// Check Out
    ///
    /// Sends the ticket in LuckyCart format
    public func checkOut(ticketComposer: LCTicketComposer,
                         failure: @escaping (Error)->Void,
                         success: @escaping (LCPostCartResponse)->Void) {
        postCart(ticketComposer: ticketComposer) { result in
            switch result {
            case .failure(let error):
                print("[luckycart.checkout] CheckOut Error:\r\(error.localizedDescription)")
                self.lastCheckOutResponse = nil
                failure(error)
            case .success(let response):
                print("[luckycart.checkout] CheckOut succeed:---->\r\(response)\r<----\r")
                self.lastCheckOutResponse = response
                success(response)
            }
        }
    }
    
    
    /// Load all games
    ///
    /// Games are usually loaded just after the check out

    public func loadGames(failure: @escaping (Error)->Void,
                          success: @escaping ([LCGame])->Void) {
        getGames { result in
            switch result {
            case .failure(let error):
                print("[luckycart.checkout] PostCart Error : \(error.localizedDescription)")
                failure(error)
            case .success(let response):
                print("[luckycart.checkout] PostCart succeed:---->\r\(response)\r<----\r")
                success(response)
            }
        }
    }
    
    /// Reload the games without completion
    ///
    /// Observe the `LuckyCart.games` property to do interface refresh if needed
    
    public func reloadGames() {
        getGames(reload: true) { _ in }
    }
    /// Load all banner spaces
    ///
    /// Banner spaces are loaded as soon as the LuckyCart instance is created.
    
    public func loadBannerSpaces(failure: @escaping (Error)->Void,
                                 success: @escaping (LCBannerSpaces)->Void) {
        getBannerSpaces { result in
            switch result {
            case .failure(let error):
                print("[luckycart.load.bannerSpaces] GetBannerSpaces Error:\r\(error.localizedDescription)")
                failure(error)
            case .success(let spaces):
                print("[luckycart.load.bannerSpaces] GetBannerSpaces succeed :\r\(spaces)")
                success(spaces)
            }
        }
    }
    
    /// Load all banner spaces
    ///
    /// Banner spaces are loaded as soon as the LuckyCart instance is created.
    
    public func banner(with identifier: LCBannerIdentifier,
                       bannerSpaceIdentifier: LCBannerSpaceIdentifier,
                       failure: @escaping (Error)->Void,
                       success: @escaping (LCBanner)->Void) {
        getBannerSpaces { [weak self] _ in
            self?.getBanner(bannerSpaceIdentifier: bannerSpaceIdentifier, bannerIdentifier: identifier) { result in
                switch result {
                case .failure(let error):
                    print("[luckycart.load.banner] GetBanner `\(identifier.rawValue)` Error:\r\(error.localizedDescription)")
                    failure(error)
                case .success(let banner):
                    print("[luckycart.load.banner] GetBanner `\(identifier.rawValue)` Succeed :\r\(banner)")
                    success(banner)
                }
            }
        }
    }

}
