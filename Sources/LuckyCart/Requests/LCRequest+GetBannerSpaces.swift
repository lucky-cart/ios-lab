//
//  LCRequest+GetBannerSpaces.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation

// MARK: - getBannerSpaces -

extension LCRequestName {
    
    /// getBannerSpaces
    ///
    /// The name of the request that retrieves banner spaces
    ///
    /// Scheme:
    /// ```
    /// https://promomatching.luckycart.com/{{auth_key}}/{{customer_id}}/banners/mobile/list
    /// ```
    ///
    /// Results:
    /// ```
    /// {
    ///     "homepage": [
    ///         "banner"
    ///     ],
    ///     "categories": [
    ///         "banner_100",
    ///         "banner_200",
    ///         "search_100",
    ///         "search_200"
    ///     ]
    /// }
    /// ```
    
    static let getBannerSpaces = LCRequestName(rawValue: "getBannerSpaces",
                                               server: .promo,
                                               path: "",
                                               method: "GET")
    
}

extension LCRequestParameters {
    
    /// BannerSpaces
    ///
    /// Parameters structure to pass to a `getBanner` request
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

    struct BannerSpaces: LCRequestParametersBase {
        var customerId: String
        
        func pathExtension(for request: LCRequestBase) throws -> String {
            guard let authKey = request.connection.authorization?.key else {
                throw LuckyCart.Err.authKeyMissing
            }
            return "\(authKey)/\(customerId))/banners/mobile/list"
        }

        func parametersString(for request: LCRequestBase) throws -> String {
            return ""
        }
    }
}
