//
//  Endpoint.swift
//  cyberpay
//
//  Created by David Ehigiator on 07/02/2019.
//  Copyright © 2019 David Ehigiator. All rights reserved.
//

import Foundation


protocol Endpoint {
    var base: String { get }
    var path: String { get }
}
extension Endpoint {
 
    var urlComponents: URLComponents? {
        guard var components = URLComponents(string: base) else { return nil }
        components.path = path
        return components
    }
    
    var request: URLRequest? {
        guard let url = urlComponents?.url ?? URL(string: "\(self.base)\(self.path)") else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    
    func postRequest<T: Encodable>(parameters: T, headers: [HTTPHeader]) -> URLRequest? {
        guard var request = self.request else { return nil }
        request.httpMethod = HTTPMethod.post.rawValue
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch let error {
            print(APIError.postParametersEncodingFalure(description: "\(error)").customDescription)
            return nil
        }
        headers.forEach { request.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
        return request
    }
    
    func getRequest(parameters: [String:Any],headers: [HTTPHeader]) -> URLRequest? {
        guard var request = self.request else { return nil }
        request.httpMethod = HTTPMethod.get.rawValue
        request.url = createURLFromParameters(parameters: parameters)
        headers.forEach { request.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
        return request
    }
    
    
    
    private func createURLFromParameters(parameters: [String:Any]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host   = self.base
        components.path   = self.path
        
      
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
}




