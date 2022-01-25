//
//  LCRequest+GetGames.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation

// MARK: - getGames -

/// LCRequestName
///
/// Defines the request primitives
/// - the name ("myrequest")
/// - the server to use ( api or promomatching )
/// - the path to access resource from server base
/// - the method ( "GET", "POST" )

extension LCRequestName {
    
    /// getGames
    ///
    /// The `getGames` request needs some parameters, passed via a `LCRequestParameters` object
    ///
    /// - `LCRequestParametersBase.Games`
    ///     - customerId
    ///     - cartId
    ///
    /// **Example:**
    /// ```swift
    /// let parameters = LCRequestParameters.Games(customerId: myCustomerId, cartId: myCartId)
    /// let request: LCRequest<Model.Banner> = try network.buildRequest(name: .getBanner, parameters: parameters)
    /// network.run(request) {
    ///    // completion(Result<Model.Games, Error>)
    /// }
    /// ```
    ///
    /// **Scheme:**
    /// ```
    /// https://api.luckycart.com/cart/games?authKey={{auth_key}}&cartId={{cart_id}}&customerId={{customer_id}}
    /// ```
    ///
    /// **Results:**
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

    
    /// Games
    ///
    /// Parameters structure to prepare parameters for a `getGames` request
    ///
    /// - Parameter customerId: The user customer id
    /// - Parameter cartId: the cart id
    ///
    /// **Resource Name:**
    /// ```
    /// cart/games
    /// ```
    ///
    /// **Path Extension:**
    /// ```
    /// ?authKey={authKey}&cartId={cartId}&customerId={customerId}
    /// ```

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
