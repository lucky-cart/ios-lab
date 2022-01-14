//
//  LCTicketComposer+Model.swift
//  
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
        
        func makeDictionary() throws -> [String : Any] {
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
        
        var customerId: String
        var email: String
        var firstName: String
        var lastName: String
        
        func makeDictionary() throws -> [String : Any] {
            [
                "customerId": customerId,
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
        
        func makeDictionary() throws -> [String : Any] {
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
        var cartId: String
        var currency: String
        var ttc: String
        var ht: String
        var products: [ProductOrder]
        
        func makeDictionary() throws -> [String : Any] {
            [
                "cartId": cartId,
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
        func makeDictionary() throws -> [String : Any] {
            return dictionary
        }
        
        var dictionary: [String: Any]
    }
}
