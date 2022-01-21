//
//  LCTicketComposer+Debug.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

#if DEBUG

public extension LCTicketComposer {
    
    static let test = LCTicketComposer(customer: LCTicketComposer.testCustomer,
                                       cart: LCTicketComposer.testCart,
                                       order: LCTicketComposer.testOrder,
                                       metaData: LCTicketComposer.testMetaData)
    
    static let testCustomer = Customer(customerClientId: "41410788",
                                       email: "vincentoliveira@luckycart.com",
                                       firstName: "VINCENT",
                                       lastName: "OLIVEIRA")
    
    static let testOrder = Order(shippingMethod: LCShippingMethod.pickUp,
                                 shopId: "A75710",
                                 device: "ios-test-optin")
    
    static let testProduct = ProductOrder(id: "14917412", quantity: "10.00", ttc: "12.00", ht: "10.00")
   
    static let testCart = Cart(cartClientId: "client_cart_5c1e51fda", currency: "EUR", ttc: "12.00", ht: "10.00", products: [ LCTicketComposer.testProduct])
    
    static let testMetaData = MetaData(dictionary: ["loyaltyCart" : ""])
    
    static let testTicketJson: [String: Any] = [
        Keys.shippingMethod: "pickup",
        Keys.customerId: "41410788",
        Keys.ttc: "12.00",
        Keys.lastName: "OLIVEIRA",
        Keys.firstName: "VINCENT",
        Keys.ht: "10.00",
        Keys.products: [
             Keys.ttc: "12.00",
             Keys.quantity: "1.00",
             Keys.ht: "10.00",
             Keys.id: "14917412"
        ],
        Keys.shopId: "A75710",
        Keys.email: "vincentoliveira@luckycart.com",
        Keys.currency: "EUR",
        Keys.device: "ios-test-optin",
        Keys.cartId: LuckyCart.testCart.id,
        Keys.loyaltyCart: ""
    ]
}

#endif
