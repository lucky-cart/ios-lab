//
//  LCRequest+GetBanner.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 13/01/2022.

import Foundation

// MARK: - getBanner -

/// LCRequestName
///
/// Defines the request primitives
/// - the name ("myrequest")
/// - the server to use ( api or promomatching )
/// - the path to access resource from server base
/// - the method ( "GET", "POST" )

extension LCRequestName {
    
    /// getBanner
    ///
    /// The `getBanner` request needs some parameters, passed via a `LCRequestParameter` object.
    ///
    /// - `LCRequestParametersBase.Banner`
    ///     - customerId: String
    ///     - bannerSpace: String banner space identifier ( key to an array of banner ids )
    ///     - banner: String banner identifier
    ///
    /// **Example:**
    /// ```swift
    /// let parameters = LCRequestParameters.Banner(customerId: customerId, bannerSpace: bannerSpaceId, banner: bannerId)
    /// let request: LCRequest<Model.Banner> = try network.buildRequest(name: .getBanner, parameters: parameters)
    /// network.run(request) {
    ///    // completion(Result<Model.Banner, Error>)
    /// }
    /// ```
    ///
    /// **Scheme:**
    /// ```
    /// https://promomatching.luckycart.com/{{auth_key}}/{{customer_id}}/banner/mobile/{bannerSpaceIdentifier}/{banner_id}
    /// ```
    ///
    /// **Results:**
    /// ```
    /// {
    ///     "image_url": "https://promomatching.luckycart.com/61d6c677baa1676dd46bfee6/customer_1234/image?meta=61bb057807879bee01ed5298&test=true&noCache1641942555414",
    ///     "redirect_url": "https://promomatching.luckycart.com/61d6c677baa1676dd46bfee6/customer_1234/jump?meta=61bb057807879bee01ed5298&test=true",
    ///     "name": "QA ITW Assessment",
    ///     "campaign": "61bb057807879bee01ed5298",
    ///     "space": "61d6c677baa1676dd46bfee6",
    ///     "action": {
    ///         "type": "boutique",
    ///         "ref": ""
    ///     }
    /// }
    /// ```
    
    static let getBanner = LCRequestName(rawValue: "getBanner",
                                         server: .promo,
                                         path: "",
                                         method: "GET")
}

// MARK: - getBanner parameters -

extension LCRequestParameters {
    
    /// Banner
    ///
    /// Parameters structure to prepare parameters for a `getBanner` request
    ///
    /// - Parameter customerId: The user customer id
    /// - Parameter bannerId: the banner id
    /// - Parameter bannerSpaceId: the banner space id
    /// - Parameter format: the banner format
    ///
    /// **Resource Name:**
    /// ```
    /// banner
    /// ```
    ///
    /// **Path Extension:**
    /// ```
    /// {authKey}{customerId}/{resourceName}/mobile/{bannerspace_id}/{banner_id}
    /// ```
    
    struct Banner: LCRequestParametersBase {
        var customerId: String
        var bannerSpaceId: String
        var bannerId: String
        var format: String
        
        func pathExtension(for request: LCRequestBase) throws -> String {
            guard let authKey = request.connection.authorization?.key else {
                throw LuckyCart.Err.authKeyMissing
            }
            let underscore = bannerId.isEmpty ? "" : "_"
            return "\(authKey)/\(customerId)/banner/mobile/\(bannerSpaceId)/\(format)\(underscore)\(bannerId)"
        }
        
        func parametersString(for request: LCRequestBase) throws -> String { "" }
    }
}
