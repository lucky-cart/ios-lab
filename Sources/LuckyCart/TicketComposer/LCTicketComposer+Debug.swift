//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

#if DEBUG

extension LCTicketComposer {
    
    static let test = LCTicketComposer(customer: LCTicketComposer.testCustomer,
                                       cart: LCTicketComposer.testCart,
                                       order: LCTicketComposer.testOrder,
                                       metaData: LCTicketComposer.testMetaData)
    
    static let testCustomer = Customer(customerId: "41410788", email: "vincentoliveira@luckycart.com", firstName: "VINCENT", lastName: "OLIVEIRA")
    
    static let testOrder = Order(shippingMethod: LCShippingMethod.pickUp, shopId: "A75710", device: "ios-test-optin")
    static let testProduct = ProductOrder(id: "14917412", quantity: "1.00", ttc: "12.0", ht: "10.0")
    static let testCart = Cart(cartId: "cart_1234", currency: "EUR", ttc: "12.0", ht: "10.0", products: [ LCTicketComposer.testProduct])
    
    static let testMetaData = MetaData(dictionary: ["loyaltyCart" : ""])
    
    static let testTicketJson: [String: Any] = [
        "shippingMethod": "pickup",
        "customerId": "41410788",
        "ttc": "12.0",
        "lastName": "OLIVEIRA",
        "firstName": "VINCENT",
        "ht": "10.0",
        "products": [
            ["ttc": "12.0", "quantity": "1.00", "ht": "10.0", "id": "14917412"]
        ],
        "shopId": "A75710",
        "email": "vincentoliveira@luckycart.com",
        "currency": "EUR",
        "device": "ios-test-optin",
        "cartId": "cart_1234",
        "loyaltyCart": ""
    ]
}

#endif
