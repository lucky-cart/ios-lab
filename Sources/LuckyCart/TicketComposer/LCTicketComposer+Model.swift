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
        var shippingMethod: LCShippingMethod
        var shopId: String
        var device: String
        
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
        
        var customerClientId: String
        var email: String
        var firstName: String
        var lastName: String
        
        public func makeDictionary() throws -> [String : Any] {
            [
                "customerClientId": customerClientId,
                "email": email,
                "firstName": firstName,
                "lastName" : lastName
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
        var id: String
        var quantity: String
        var ttc: String
        var ht: String
        
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
        
        static let pickUp = LCShippingMethod(rawValue: "pickup")
        static let localShipping = LCShippingMethod(rawValue: "shipping.local")
        static let internationalShipping = LCShippingMethod(rawValue: "shipping.international")
        static let sameDayDelivery = LCShippingMethod(rawValue: "sameDayDelivery")
        static let digitalDelivery = LCShippingMethod(rawValue: "digitalDelivery")
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
        var cartClientId: String
        var currency: String
        var ttc: String
        var ht: String
        var products: [ProductOrder]
        
        public func makeDictionary() throws -> [String : Any] {
            [
                "cartClientId": cartClientId,
                "currency": currency,
                "ttc": ttc,
                "ht": ht,
                "products" : try products.map { try $0.makeDictionary() }
            ]
        }
    }
    
    /// Meta
    ///
    /// Free Dictionary encodable as json

    struct MetaData: LCTicketComposerEntity {
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
        
        var dictionary: [String: Any]
    }
}
