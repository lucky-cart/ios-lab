//
//  LCNetwork.swift
//
//  LuckyCart Framework - (c)2022 Lucky Cart
//
//  Created by Tristan Leblanc on 10/01/2022.

import Foundation

/// LCNetwork
///
/// The LuckyCart network layer
///
/// The network layer manage a LuckyCart networking session
///
/// It opens two connection with api and promoMatching servers

internal class LCNetwork {
    
    var authorization: LCAuthorization
    
    lazy var session: URLSession = {
        URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    init(authorization: LCAuthorization) {
        self.authorization = authorization
    }
    
    lazy var api: LCConnection = {
        return LCConnection.api(authorization: authorization)
    }()
    
    lazy var promoMatching: LCConnection = {
        return LCConnection.promo(authorization: authorization)
    }()

    // MARK: - Run Requests
    
    /// run
    ///
    /// Runs the request.
    ///
    /// Completion is called with the decoded object, passed as generic Codable
    
    func run(_ request: LCRequestBase, completion: @escaping (Codable)->Void) throws {
        let urlRequest = try request.makeURLRequest()
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
            do {
                completion(try request.response(data: data))
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
