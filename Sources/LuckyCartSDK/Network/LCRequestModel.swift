//
//  LCRequestModel.swift
//  
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation

internal struct LCRequestModel {
    let url: URL?
    let method: LCHTTPMethods
    let body: Data?
}

internal enum LCHTTPMethods: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
}
