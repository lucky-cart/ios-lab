//
//  LCTicketComposer.swift
//  
//
//  Created by Tristan Leblanc on 14/01/2022.
//

import Foundation

public struct LCTicketComposer: LCTicketComposerEntity {
    var customer: Customer
    var order: Order
    var metaData: MetaData
    var cart: Cart

    func makeDictionary() throws -> [String: Any] {
        var out = [String: Any]()
        try customer.append(to: &out)
        try cart.append(to: &out)
        try order.append(to: &out)
        try metaData.append(to: &out)
        return out
    }
    
    init(customer: Customer, cart: Cart, order: Order, metaData: MetaData) {
        self.customer = customer
        self.order = order
        self.cart = cart
        self.metaData = metaData
    }
}
