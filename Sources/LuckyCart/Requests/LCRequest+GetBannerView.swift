//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 13/01/2022.
//

import Foundation

// MARK: - getBannerView -

extension LCRequestName {
    
    /// connect
    ///
    /// The name of the request that retrieves banner spaces
    ///
    /// Scheme:
    /// ```
    /// https://promomatching.luckycart.com/{{auth_key}}/{{customer_id}}/banner/mobile/homepage/banner
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
    
    static let getBannerView = LCRequestName(rawValue: "getBannerView",
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
    /// \(authKey)/\(customerId)/\(banner)/mobile/homepage/banner
    /// ```
    /// url parameters:
    /// ```
    ///
    /// ```

    struct BannerView: LCRequestParametersBase {
        var customerId: String
        var banner: String
    
        func pathExtension(for request: LCRequestBase) throws -> String {
            guard let authKey = request.connection.authorization?.key else {
                throw LuckyCart.Err.authKeyMissing
            }
            return "\(authKey)/\(customerId)/\(banner)/mobile/homepage/banner"
        }

        func parametersString(for request: LCRequestBase) throws -> String {
            return ""
        }
    }

}

