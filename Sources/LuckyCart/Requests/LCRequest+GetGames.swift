//
//  LCRequest+GetGames.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation

// MARK: - getGames -

extension LCRequestName {
    
    /// Get Games
    ///
    /// The name of the request that retrieves the list of games for a given customer and cart
    ///
    /// Scheme:
    /// ```
    /// https://api.luckycart.com/cart/games?authKey={{auth_key}}&cartId={{cart_id}}&customerId={{customer_id}}
    /// ```
    ///
    /// Results:
    /// ```
    /// {
    ///     "games": [
    ///         {
    ///             "code": "QLWG-SHYR-MGBZ-SLXK",
    ///             "isGamePlayable": true,
    ///             "gameResult": "not-played",
    ///             "desktopGameUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/url",
    ///             "desktopGameImage": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/image",
    ///             "mobileGameUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/url",
    ///             "mobileGameImage": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/image"
    ///         }
    ///     ]
    /// }
    /// ```
    
    static let getGames = LCRequestName(rawValue: "games",
                                        server: .api,
                                        path: "cart/games",
                                        method: "GET")
    
}

extension LCRequestParameters {
    
    struct Games: LCRequestParametersBase {
        var customerId: String
        var cartId: String
        
        func pathExtension(for request: LCRequestBase) throws -> String {
            return ""
        }

        func parametersString(for request: LCRequestBase) throws -> String {
            guard let authKey = request.connection.authorization?.key else {
                throw LuckyCart.Err.authKeyMissing
            }
            return "?authKey=\(authKey)&cartId=\(cartId)&customerId=\(customerId)"
        }
    }
}
