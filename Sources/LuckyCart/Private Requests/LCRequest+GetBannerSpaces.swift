//
//  LCRequest+GetBannerSpaces.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 12/01/2022.
//

import Foundation

// MARK: - getBannerSpaces -

/// LCRequestName
///
/// Defines the request primitives
/// - the name ("myrequest")
/// - the server to use ( api or promomatching )
/// - the path to access resource from server base
/// - the method ( "GET", "POST" )

extension LCRequestName {
    
    /// getBannerSpaces
    ///
    /// The `getBannerSpaces` request needs some parameters, passed via a `LCRequestParameters` object
    /// 
    /// - `LCRequestParametersBase.BannerSpaces`
    ///     - customerId
    ///
    /// **Example:**
    /// ```swift
    /// let parameters = LCRequestParameters.BannerSpaces(customerId: customerId)
    /// let request: LCRequest<Model.Banner> = try network.buildRequest(name: .getBannerSpaces, parameters: parameters)
    /// network.run(request) {
    ///    // completion(Result<Model.BannerSpaces, Error>)
    /// }
    /// ```
    ///
    /// **Scheme:**
    /// ```
    /// https://promomatching.luckycart.com/{{auth_key}}/{{customer_id}}/banners/mobile/list
    /// ```
    ///
    /// **Results:**
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
    /// Parameters structure to pass to a `getBannerSpaces` request
    /// - Parameter customerId: The id of the customer
    ///
    /// **Resource Name:**
    /// ```
    /// banners
    /// ```
    ///
    /// **Path Extension:**
    /// ```
    /// {authKey}{customerId}/{resourceName}/mobile/list
    /// ```

    struct BannerSpaces: LCRequestParametersBase {
        var customerId: String
        
        func pathExtension(for request: LCRequestBase) throws -> String {
            guard let authKey = request.connection.authorization?.key else {
                throw LuckyCart.Err.authKeyMissing
            }
            return "\(authKey)/\(customerId)/banners/mobile/list"
        }

        func parametersString(for request: LCRequestBase) throws -> String {
            return ""
        }
    }
}
