//
//  NetworkUtils.swift
//  NetworkUtils
//
//  Created by Wyatt Mufson on 12/3/18.
//

import Foundation
import Promises

public let networkUtils = NetworkUtils.main
public let reachability = NetworkUtils.reachability

public class NetworkUtils: NSObject {
    public static let main = NetworkUtils()
    public static let reachability = Reachability.shared
    
    public func post(_ urlLink:String, _ params:[String:Any] = [:]) -> Promise<Data> {
        return httpMethod(urlLink: urlLink, method: .POST, params: params)
    }
    
    public func get(_ urlLink:String, _ params:[String:Any] = [:]) -> Promise<Data> {
        return httpMethod(urlLink: urlLink, method: .GET, params: params)
    }
    
    public func put(_ urlLink:String, _ params:[String:Any] = [:]) -> Promise<Data> {
        return httpMethod(urlLink: urlLink, method: .PUT, params: params)
    }
    
    public func delete(_ urlLink:String, _ params:[String:Any] = [:]) -> Promise<Data> {
        return httpMethod(urlLink: urlLink, method: .DELETE, params: params)
    }
    
    private func httpMethod(urlLink:String, method:httpMethodType, params:[String:Any]) -> Promise<Data> {
        let promise = Promise<Data> { fulfill, reject in
            let url = URL(string: urlLink)
            var request = URLRequest(url: url!)
            let count = params.keys.count
            
            if count > 0 {
                if (method.rawValue == "POST" || method.rawValue == "PUT"){
                    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                } else if (method.rawValue == "GET" || method.rawValue == "DELETE"){
                    var keys = Array(params.keys)
                    var queryItems : [URLQueryItem] = []
                    
                    for i in 0..<count {
                        let name = keys[i]
                        let value = "\(params[name]!)"
                        
                        let queryItem = URLQueryItem(name: name, value: value)
                        queryItems.append(queryItem)
                    }
                    var urlComponents = URLComponents(string: urlLink)!
                    urlComponents.queryItems = queryItems
                    request = URLRequest(url: urlComponents.url!)
                }
            }
            
            request.httpMethod = method.rawValue
            
            let session = URLSession.shared
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                if (error != nil){
                    reject(error!)
                } else {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        reject(networkError(msg: "Invalid url response"))
                        return
                    }
                    let statusCode = httpResponse.statusCode
                    if statusCode < 200 || statusCode >= 300 {
                        var errorMessage = "Failed with code \(statusCode)"
                        if let additionalString  = String(data: data!, encoding: String.Encoding.utf8){
                            errorMessage += " - \(additionalString)"
                        }
                        reject(networkError(msg: errorMessage))
                    } else {
                        fulfill(data!)
                    }
                }
            }).resume()
        }
        return promise
    }
}

private struct networkError:Error {
    let msg : String
}

private enum httpMethodType:String {
    case POST, GET, PUT, DELETE
}
