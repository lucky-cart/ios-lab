//
//  LCRequest+SendCart.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation

// MARK: - sendCart -

/// LCRequestName
///
/// Defines the request primitives
/// - the name ("myrequest")
/// - the server to use ( api or promomatching )
/// - the path to access resource from server base
/// - the method ( "GET", "POST" )

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
    
    static let sendCart = LCRequestName(rawValue: "sendCart",
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
    
    /// SendCart
    ///
    /// Parameters structure to pass to a `sendCart` request
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
    
    
    struct SendCart: LCRequestParametersBase {
        
        public var customerId: String
        public var cartId: String
        
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
            
            // Create the base dictionary for request body
            var out: [String: Any] = try PostCartJSONComposer(customerId: customerId, cartId: cartId, auth: auth).makeDictionary()
            
            
            try ticketComposer.append(to: &out)
            
            return out
        }
        
        func json(for request: LCRequestBase) throws -> Data {
            let dictionary = try self.dictionary(for: request)
            let json = try JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted])
            print("[luckycart.sendCart.json] ===>\r\(String(data: json, encoding: .utf8)!)\r<========\r")
            return json
        }
    }
}

/// LuckyCart Required Fields Composer
///
/// Generates the base dictionary to generate sendCart json
///
/// - customerId: String
/// - cartId: String
/// - auth: LCAuthorization

struct PostCartJSONComposer: LCTicketComposer {
    struct Keys {
        static let auth_key = "auth_key"
        static let auth_ts = "auth_ts"
        static let auth_v = "auth_v"
        static let auth_sign = "auth_sign"
        static let auth_nonce = "auth_nonce"
        static let customerId = "customerId"
        static let cartId = "cartId"
    }
    
    public var customerId: String
    public var cartId: String
    public var auth: LCAuthorization
    
    public init(customerId: String, cartId: String, auth: LCAuthorization) {
        self.customerId = customerId
        self.cartId = cartId
        self.auth = auth
    }
    
    /// Returns data as Dictionary
    public func makeDictionary() throws -> [String : Any] {
        
        let signature = auth.computeSignature()
        
        let out: [String: Any] = [
            Keys.auth_ts: signature.timestamp,
            Keys.auth_key: signature.key,
            Keys.auth_sign: signature.hex,
            Keys.auth_nonce: signature.timestamp,
            Keys.auth_v: auth.version,
            Keys.cartId: cartId,
            Keys.customerId: customerId
        ]
        
        return out
    }
}
