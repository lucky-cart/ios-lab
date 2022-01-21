//
//  LCRequest+GetBanner.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 13/01/2022.
//

import Foundation

// MARK: - getBannerDetails -

extension LCRequestName {
    
    /// connect
    ///
    /// The name of the request that retrieves banner spaces
    ///
    /// Scheme:
    /// ```
    /// https://promomatching.luckycart.com/{{auth_key}}/{{customer_id}}/banner/mobile/{bannerSpaceIdentifier}/{banner_id}
    /// ```
    ///
    /// Results:
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

extension LCRequestParameters {
    
    /// Banner
    ///
    /// Parameters structure to pass to a `getBanner` request
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
    /// {authKey}{customerId}/banner/mobile/{bannerspace_id}/{banner_id}
    /// ```
    /// url parameters:
    /// ```
    ///
    /// ```

    struct Banner: LCRequestParametersBase {
        var customerId: String
        var bannerSpace: LCBannerSpaceIdentifier
        var banner: LCBannerIdentifier

        func pathExtension(for request: LCRequestBase) throws -> String {
            guard let authKey = request.connection.authorization?.key else {
                throw LuckyCart.Err.authKeyMissing
            }
            return "\(authKey)/\(customerId)/banner/mobile/\(bannerSpace.rawValue)/\(banner.rawValue)"
        }

        func parametersString(for request: LCRequestBase) throws -> String { "" }
    }

}

