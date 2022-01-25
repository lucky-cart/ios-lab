//
//  LCTicketComposer.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

/// LCTicketComposer
///
/// The ticket composer is the aggregator that prepare the LuckyCart data to send when checking out.
/// The composer is clearly splitted in four scopes represented by `LCTicketComposerScope`

public struct LCTicketComposer: LCTicketComposerScope {
    
    typealias Keys = PostCartBodyKeys

    /// PostCartBodyKeys
    ///
    /// The keys used in the ticket json, which is sent in the body of the `postCart` request

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

    public var customer: Customer
    public var cart: Cart
    public var order: Order
    public var metaData: MetaData
    
    /// init
    ///
    /// Initialize the ticket composer.
    
    public init(customer: Customer, cart: Cart, order: Order, metaData: MetaData) {
        self.customer = customer
        self.order = order
        self.cart = cart
        self.metaData = metaData
    }
    
    /// makeDictionary
    ///
    /// Compose the final dictionary for JSON conversion.
    /// Note that the first level of the resulting dictionary is flattened.
    /// So metadatq can't use a key already used by customer, cart or order.
    ///
    /// If a key is duplicate, a `ticketComposerKeyAlreadyPresent` exception will be thrown
    
    public func makeDictionary() throws -> [String: Any] {
        var out = [String: Any]()
        try customer.append(to: &out)
        try cart.append(to: &out)
        try order.append(to: &out)
        try metaData.append(to: &out)
        return out
    }
    
    /// priceString
    ///
    /// Returns a price as string
    
    public static func priceString(_ price: Double) -> String{
        let f = NumberFormatter()
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f.string(for: price) ?? "\(price)"
    }
}

/// LCTicketComposerScope
///
/// A sub model of the ticket composer.
/// All objects must implement a `makeDictionary` to export in JSON.

protocol LCTicketComposerScope {
    
    /// makeDictionary
    ///
    /// Returns the dictionary ready for JSON conversion
    
    func makeDictionary() throws -> [String: Any]
}

extension LCTicketComposerScope {

    /// append
    ///
    /// Append the dictionary to a passed dictionary.
    /// An exception is thrown if the key already exists.
    
    func append(to dictionary: inout [String: Any]) throws {
        for (key,value) in try makeDictionary() {
            if dictionary[key] != nil {
                print("[luckycart.ticketComposer] Key `\(key)` already set")
                throw LuckyCart.Err.ticketComposerKeyAlreadyPresent
            }
            dictionary[key] = value
        }
    }
}
