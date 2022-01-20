//
//  LCRequest+PostCart.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation

typealias Keys = PostCartBodyKeys

struct PostCartBodyKeys {
    
    static let auth_key = "auth_key"
    
    // Auth
    static let auth_ts = "auth_ts"
    static let auth_v = "auth_v"
    static let auth_sign = "auth_sign"
    static let auth_nonce = "auth_nonce"
    
    // Customer
    static let customerClientId = "customerClientId"
    static let lastName = "lastName"
    static let firstName = "firstName"
    static let email = "email"
    
    // Cart
    static let cartId = "cartId"
    static let cartClientId = "cartClientId"
    static let totalAti = "totalAti"
    static let currency = "currency"
    static let products = "products"

    static let loyaltyCart = "loyaltyCart" // Is this a custom tag sample, or a real model key
    
    // Product
    static let quantity = "quantity"
    static let id = "id"
    static let ht = "ht"
    static let ttc = "ttc"
    
    // Order
    static let shopId = "shopId"
    static let shippingMethod = "shippingMethod"
    static let customerId = "customerId"
    
    static let device = "device" // Any defined format for this?
}

// MARK: - postCart -

extension LCRequestName {
    
    /// Post Cart
    ///
    /// The name of the request that posts a cart
    /// Parameters are used to pass authorization in body
    /// All other ticket parameters are append to body by the ticketComposer
    ///
    /// Scheme:
    /// ```
    /// https://api.luckycart.com/cart/ticket.json
    /// ```
    ///
    /// Parameters:
    /// ```
    /// {
    ///     "auth_key": "{{auth_key}}",
    ///     "auth_ts": "{{timestamp}}",
    ///     "auth_sign": "{{sign}}",
    ///     "auth_v": "2.0",
    /// }
    /// ```
    ///
    /// Results:
    /// {
    ///     "ticket": "QLWG-SHYR-MGBZ-SLXK",
    ///     "mobileUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/mobile/url",
    ///     "tabletUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/tablet/url",
    ///     "desktopUrl": "https://api.luckycart.com/replacement/QLWG-SHYR-MGBZ-SLXK/desktop/url",
    ///     "baseMobileUrl": "https://go.luckycart.com/mobile/QLWG-SHYR-MGBZ-SLXK",
    ///     "baseTabletUrl": "https://go.luckycart.com/tablet/QLWG-SHYR-MGBZ-SLXK",
    ///     "baseDesktopUrl": "https://go.luckycart.com/lc__team__qa/NX5PDN/play/QLWG-SHYR-MGBZ-SLXK"
    /// }
    ///
    
    static let postCart = LCRequestName(rawValue: "postCart",
                                        server: .api,
                                        path: "cart/ticket.json",
                                        method: "POST")
    
}

extension Model {
    
    /// PostCartResponse
    ///
    /// The data structure received after a successful cart upload
    
    public struct PostCartResponse: Codable {
        var ticket: String
        var mobileUrl: String
        var tabletUrl: String
        var desktopUrl: String
        var baseMobileUrl: String
        var baseTabletUrl: String
        var baseDesktopUrl: String
    }
}

extension LCRequestParameters {
    
    /// PostCart
    ///
    /// Parameters structure to pass to a `postCart` request
    ///
    /// - Parameter banner: the banner id
    /// - Parameter customerId: The user customer id
    ///
    /// name:
    /// ```
    /// banner
    /// ```
    /// path extension:
    /// ```
    /// \(authKey)/\(customerId)/\(banner)/mobile/homepage/banner
    /// ```
    /// url parameters:
    /// ```
    ///
    /// ```
    
    
    struct PostCart: LCRequestParametersBase {
        
        // The json dictionary to send in ticket json
        var ticketComposer: LCTicketComposer
        
        func pathExtension(for request: LCRequestBase) throws -> String {
            return "/cart/ticket.json"
        }
        
        func parametersString(for request: LCRequestBase) throws -> String {
            return ""
        }
        
        
        func dictionary(for request: LCRequestBase) throws -> [String: Any] {
            guard let auth = request.connection.authorization else {
                throw LuckyCart.Err.authorizationMissing
            }
            
            let signature = auth.computeSignature()
            
            var out: [String: Any] = [
                Keys.auth_ts: signature.timestamp,
                Keys.auth_key: signature.key,
                Keys.auth_sign: signature.hex,
                Keys.auth_nonce: signature.timestamp,
                Keys.auth_v: auth.version
            ]
            
            try ticketComposer.append(to: &out)
            
            return out
        }

        func json(for request: LCRequestBase) throws -> Data {
            let dictionary = try self.dictionary(for: request)
            let json = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let dataString = String(data: json, encoding: .utf8) ?? "<no valid utf8 data>"
            print("[luckycart.network.postCart] Ticket Json :\r--->\r \(dataString)\r<---\r")
            return json
        }
    }
}
