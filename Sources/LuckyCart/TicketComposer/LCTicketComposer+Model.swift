//
//  LCTicketComposer+Model.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

protocol LCTicketComposerEntity {
    func makeDictionary() throws -> [String: Any]
}

extension LCTicketComposerEntity {
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

public extension LCTicketComposer {
        
    /// Order
    ///
    /// Generates the Order dictionary to generate ticket json
    ///
    /// - shippingMethod: "<LCShippingMethod>"
    /// - shopId: "<ShopId>"
    /// - device: "<device>"
    /// - cart: <Cart> [ <ProductOrder> ]
    
    struct Order: LCTicketComposerEntity {
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
    /// - customerId: "41410788"
    /// - email: "vincentoliveira@luckycart.com"
    /// - firstName: "VINCENT"
    /// - lastName: "OLIVEIRA"
    
    struct Customer: LCTicketComposerEntity {
        /// The customer id in client system
        public var customerClientId: String
        
        /// Customer information
        public var email: String
        public var firstName: String
        public var lastName: String
        
        public init(customerClientId: String,
                    email: String,
                    firstName: String,
                    lastName: String) {
            self.customerClientId = customerClientId
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
        }
        
        public func makeDictionary() throws -> [String : Any] {
            [
                Keys.customerClientId: customerClientId,
                Keys.email: email,
                Keys.firstName: firstName,
                Keys.lastName : lastName
            ]
        }
    }

    /// ProductOrder
    ///
    /// - productId: "14917412"
    /// - ttc: "12.0",
    /// - ht: "10.0",
    /// - quantity: "1.00"
    /// - id: "14917412"
    
    struct ProductOrder: LCTicketComposerEntity {
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
    
    struct Cart: LCTicketComposerEntity {
        
        /// The cart Id in client system
        public var cartClientId: String
        
        /// The currency set for this cart ( "EUR" )
        public var currency: String
        
        /// The total price, all taxes included
        public var ttc: String // Key in dict is "totalAti"
        
        /// The total price, without taxes
        public var ht: String
        
        /// The product orders ( Product, Quantity )
        public var products: [ProductOrder]
        
        public init(cartClientId: String,
                    currency: String,
                    ttc: String,
                    ht: String,
                    products: [ProductOrder]) {
            self.cartClientId = cartClientId
            self.currency = currency
            self.ttc = ttc
            self.ht = ht
            self.products = products
        }
        
        public func makeDictionary() throws -> [String : Any] {
            [
                Keys.cartClientId: cartClientId,
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

    struct MetaData: LCTicketComposerEntity {
        
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
        
        mutating public func set(key: String, value: Any) {
            dictionary[key] = value
        }
        
    }
}
