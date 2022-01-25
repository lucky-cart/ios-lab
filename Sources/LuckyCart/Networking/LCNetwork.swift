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
    
    func run<T>(_ request: LCRequest<T>, completion: @escaping (Result<T, Error>)->Void) throws {
        
        print("[luckycart.network] - Run [\(request.method)] \(try request.url().absoluteString)")
        let urlRequest = try request.makeURLRequest()
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(LuckyCart.Err.emptyResponse))
                }
                return
            }
            
            do {
                guard let castedData = try request.response(data: data) as? T else {
                    DispatchQueue.main.async {
                        completion(.failure(LuckyCart.Err.cantCastDataToResponseType))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(castedData))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func downloadData(url: URL, completion: @escaping (Result<Data, Error>)->Void) throws {
        let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
        print("[luckycart.network] - Download Data \(url.absoluteString)")
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(LuckyCart.Err.emptyResponse))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
