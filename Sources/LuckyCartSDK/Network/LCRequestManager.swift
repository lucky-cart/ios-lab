//
//  LCRequestManager.swift
//  
//
//  Created by Lucky Cart on 19/01/2023.
//

import Foundation
import Combine

class LCRequestManager<T: Decodable> {
    
    static var shared: LCRequestManager<T> {
        return LCRequestManager<T>()
    }
    
    private init() {}
    
    private var requestsHeaders = [
        "content-type": "application/json"
    ]
    
    func request(with model: LCRequestModel) -> AnyPublisher<T, Error> {
        guard let url = model.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = model.method.rawValue
        urlRequest.allHTTPHeaderFields = requestsHeaders
        if let body = model.body {
            urlRequest.httpBody = body
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap() { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .tryMap { data in
                if data.count == 0 {
                    return true as! T
                }
                else {
                    return try! JSONDecoder().decode(T.self, from: data)
                }
                
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestWithRetry(with model: LCRequestModel) -> AnyPublisher<T, Error> {
        
        guard let url = model.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = model.method.rawValue
        urlRequest.allHTTPHeaderFields = requestsHeaders
        if let body = model.body {
            urlRequest.httpBody = body
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap() { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .tryMap { data in
                if data.count == 0 {
                    return true as! T
                }
                else {
                    return try! JSONDecoder().decode(T.self, from: data)
                }
            }
            .delay(for: RunLoop.SchedulerTimeType.Stride(LCConfiguration.shared.apiRetryDelay),
               scheduler: RunLoop.main)
            .retry(LCConfiguration.shared.apiRetries)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
