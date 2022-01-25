//
//  LCTicketComposer+Model.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

/// LCTicketComposer
///
/// The ticket composer is the aggregator that prepare the LuckyCart data to send when checking out.

public extension LCTicketComposer {
        
    /// Order
    ///
    /// Generates the Order dictionary to generate ticket json
    ///
    /// - shippingMethod: "<LCShippingMethod>"
    /// - shopId: "<ShopId>"
    /// - device: "<device>"
    /// - cart: <Cart> [ <ProductOrder> ]
    
    struct Order: LCTicketComposerScope {
        public var shippingMethod: LCShippingMethod
        public var shopId: String
        public var device: String
        
        public init(shippingMethod: LCShippingMethod, shopId: String, device: String) {
            self.shippingMethod = shippingMethod
            self.shopId = shopId
            self.device = device
        }
        
        public func makeDictionary() throws -> [String : Any] {
            [
                "shippingMethod": shippingMethod.rawValue,
                "shopId": shopId,
                "device": device,
            ]
        }
    }

    /// Customer
    ///
    /// Generates the Customer dictionary to generate ticket json
    ///
    /// - id: "41410788"
    /// - email: "vincentoliveira@luckycart.com"
    /// - firstName: "VINCENT"
    /// - lastName: "OLIVEIRA"
    
    struct Customer: LCTicketComposerScope {
        /// The customer id
        public var id: String
        
        /// Customer information
        public var email: String
        public var firstName: String
        public var lastName: String
        
        public init(id: String?,
                    email: String?,
                    firstName: String?,
                    lastName: String?) {
            self.id = id ?? LCCustomer.guest.id
            self.email = email ?? ""
            self.firstName = firstName ?? ""
            self.lastName = lastName ?? ""
        }
        
        public func makeDictionary() throws -> [String : Any] {
            [
                Keys.customerId: id,
                Keys.email: email,
                Keys.firstName: firstName,
                Keys.lastName : lastName
            ]
        }
    }

    /// ProductOrder
    ///
    /// - id: "14917412"
    /// - ttc: "12.0",
    /// - ht: "10.0",
    /// - quantity: "1.00"
    /// - id: "14917412"
    
    struct ProductOrder: LCTicketComposerScope {
        public var id: String
        public var quantity: String
        public var ttc: String
        public var ht: String
        
        public init(id: String,
                    quantity: String,
                    ttc: String,
                    ht: String) {
            self.id = id
            self.quantity = quantity
            self.ttc = ttc
            self.ht = ht
        }
        public func makeDictionary() throws -> [String : Any] {
            [
                "quantity": quantity,
                "ttc": ttc,
                "ht": ht,
                "id" : id
            ]
        }
    }
    
    /// LCShippingMethod
    ///
    /// Describes a shipping method
    
    struct LCShippingMethod: RawRepresentable, Equatable {
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let pickUp = LCShippingMethod(rawValue: "pickup")
        public static let localShipping = LCShippingMethod(rawValue: "shipping.local")
        public static let internationalShipping = LCShippingMethod(rawValue: "shipping.international")
        public static let sameDayDelivery = LCShippingMethod(rawValue: "sameDayDelivery")
        public static let digitalDelivery = LCShippingMethod(rawValue: "digitalDelivery")
    }
    
    /// Cart
    ///
    /// Generates the Cart dictionary to generate ticket json
    ///
    /// - currency: "EUR"
    /// - ttc: "12.0"
    /// - ht: "10.0"
    /// - products: [ <ProductOrder> ]
    
    struct Cart: LCTicketComposerScope {
        public let id: String
        
        /// The currency set for this cart ( "EUR" )
        public let currency: String
        
        /// The total price, all taxes included
        public let ttc: String // Key in dict is "totalAti"
        
        /// The total price, without taxes
        public let ht: String
        
        /// The product orders ( Product, Quantity )
        public let products: [ProductOrder]
        
        public init(id: String,
                    currency: String,
                    ttc: String,
                    ht: String,
                    products: [ProductOrder]) {
            self.id = id
            self.currency = currency
            self.ttc = ttc
            self.ht = ht
            self.products = products
        }
        
        public func makeDictionary() throws -> [String : Any] {
            [
                Keys.cartId: id,
                Keys.currency: currency,
                Keys.totalAti: ttc,
                Keys.ht: ht,
                Keys.products : try products.map { try $0.makeDictionary() }
            ]
        }
    }
    
    /// Meta
    ///
    /// Free Dictionary encodable as json

    struct MetaData: LCTicketComposerScope {
        
        public var dictionary: [String: Any]

        public init(dictionary: [String: Any]) {
            self.dictionary = dictionary
        }
        
        public func makeDictionary() throws -> [String : Any] {
            return dictionary
        }
        
        public subscript (key: String) -> Any? {
            get {
                return dictionary[key]
            }
            set {
                dictionary[key] = newValue
            }
        }
        
        /// set
        ///
        /// Sets a value for the given key
        mutating public func set(key: String, value: Any) {
            dictionary[key] = value
        }
    }
}
