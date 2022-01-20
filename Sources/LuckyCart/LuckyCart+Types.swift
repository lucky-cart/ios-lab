//
//  LuckyCart+Types.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 15/01/2022.
//

import Foundation

/// LuckyCart object identifiers
///

public protocol LCIdentifier : RawRepresentable, Codable, Hashable, CustomStringConvertible, ExpressibleByStringLiteral {
    
    static var identifier: String { get }
    
    var rawValue: String { get }
    
    /// transform
    /// Apply a transformation to the input string ( remove spaces, lowercase, … )
    static func transform(_ string: String) -> String

}

public extension LCIdentifier where RawValue == String {
    
    /// append
    /// Append characters to the identifier
    
    func byAppending(_ string: String) -> LCBannerSpaceIdentifier {
        return LCBannerSpaceIdentifier(rawValue: "\(rawValue).\(Self.transform(string))")
    }
    
    var description: String {
        rawValue
    }
    
    var path: String {
        return Self.identifier + rawValue
    }
    
}

/// LCBannerSpaceIdentifier
///
/// A string that is used to identify banner spaces.
///
/// Client application can use any format

public struct LCBannerIdentifier: LCIdentifier {
    
    public static let identifier: String = "banner"
    
    public let rawValue: String

    /// Returns a lowercased string and replace spaces by underscores
    static public func transform(_ string: String) -> String {
        string.lowercased().replacingOccurrences(of: " ", with: "_")
    }
        
    /// Create a new identifier
    ///
    /// If the passed string is "Product 5314", the identifier will be `product_5314`
    ///
    /// ```
    /// print(LCBannerIdentifier.productDetail.byAppending("_100"))
    ///
    /// // result identifier = "product.detail.product_5314"
    /// ```
    
    public init(rawValue: String) {
        self.rawValue = Self.transform(rawValue)
    }
    
    init(_ string: String) {
        self.init(rawValue: string)
    }

    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }

    /// The identifier to use for a generic identifier
    
    public static let generic = LCBannerSpaceIdentifier(rawValue: "generic")
}

/// LCBannerSpaceIdentifier
///
/// A string that is used to identify banner spaces.
///
/// Client application can use any string to define identifiers.
/// To provide more structured data, it is advised to use predefined prefixes

public struct LCBannerSpaceIdentifier: LCIdentifier {
    
    public static let identifier: String = "bannerSpace"

    public let rawValue: String

    /// Returns a lowercased string and replace spaces by underscores
    static public func transform(_ string: String) -> String {
        string.lowercased().replacingOccurrences(of: " ", with: "_")
    }
        
    /// Create a new identifier
    ///
    /// If the passed string is "Product 5314", the identifier will be `product_5314`
    ///
    /// ```
    /// print(LCBannerSpaceIdentifier.productDetail.byAppending("Product 5314"))
    ///
    /// // result identifier = "product.detail.product_5314"
    /// ```
    
    public init(rawValue: String) {
        self.rawValue = Self.transform(rawValue)
    }
    
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }

    init(_ string: String) {
        self.init(rawValue: string)
    }

    /// Some pre-defined spaces identifier
    
    /// The identifier to use for the application homepage
    public static let homePage = LCBannerSpaceIdentifier(rawValue: "homepage")
    
    /// The identifier to use for a categories browser
    public static let categories = LCBannerSpaceIdentifier(rawValue: "category.browser")
    
    
    /// The identifier to use for a categories browser
    public static let categoryDetail = LCBannerSpaceIdentifier(rawValue: "category.detail")
    
    /// The identifier to use for a products browser
    public static let products = LCBannerSpaceIdentifier(rawValue: "product.browser")
    
    /// The identifier to use for a product detail view
    public static let productDetail = LCBannerSpaceIdentifier(rawValue: "product.detail")
    
    /// The identifier to use for a brands browser
    public static let brands = LCBannerSpaceIdentifier(rawValue: "brand.browser")
    
    /// The identifier to use for a brand detail view
    
    public static let brandDetail = LCBannerSpaceIdentifier(rawValue: "brand.detail")
    
    /// The identifier to use for a generic identifier
    
    public static let generic = LCBannerSpaceIdentifier(rawValue: "generic")
    
    /// The identifier to use for a generic browser
    
    public static let browser = LCBannerSpaceIdentifier(rawValue: "generic.browser")

    /// The identifier to use for a generic detail
    
    public static let detail = LCBannerSpaceIdentifier(rawValue: "generic.detail")

    /// The identifier to use for an advert view
    
    public static let advert = LCBannerSpaceIdentifier(rawValue: "advert")
}
