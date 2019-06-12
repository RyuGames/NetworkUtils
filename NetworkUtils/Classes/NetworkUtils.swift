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

public final class NetworkUtils: NSObject {
    public static let main = NetworkUtils()
    public static let reachability = Reachability.shared
    private let retryErrors = [NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut]
    internal var testing: Bool = false

    public func post(_ urlLink: String, _ params: [String: Any] = [:], _ retry: Int = 3, _ contentType: String = "application/json") -> Promise<Data> {
        return httpMethod(urlLink: urlLink, method: .POST, params: params, retry: retry, contentType: contentType)
    }

    public func get(_ urlLink: String, _ params: [String: Any] = [:], _ retry: Int = 3) -> Promise<Data> {
        return httpMethod(urlLink: urlLink, method: .GET, params: params, retry: retry)
    }

    public func put(_ urlLink: String, _ params: [String: Any] = [:], _ retry: Int = 3, _ contentType: String = "application/json") -> Promise<Data> {
        return httpMethod(urlLink: urlLink, method: .PUT, params: params, retry: retry, contentType: contentType)
    }

    public func delete(_ urlLink: String, _ params: [String: Any] = [:], _ retry: Int = 3) -> Promise<Data> {
        return httpMethod(urlLink: urlLink, method: .DELETE, params: params, retry: retry)
    }

    private func httpMethod(urlLink: String, method: httpMethodType, params: [String: Any], retry: Int, contentType: String = "application/json") -> Promise<Data> {
        return Promise<Data>(on: .global()) { fulfill, reject in
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
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            session.dataTask(with: request, completionHandler: {(data, response, error) in
                if let error = error {
                    let code = (error as NSError).code
                    if (self.retryErrors.contains(code) || self.testing) && retry > 0 {
                        self.httpMethod(urlLink: urlLink, method: method, params: params, retry: retry - 1).then(on: .global()) { (data) in
                            fulfill(data)
                        }.catch (on: .global()) { (err) in
                            reject(err)
                        }
                    } else {
                        reject(NetworkError(msg: error.localizedDescription, code: code))
                    }
                } else {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        reject(NetworkError(msg: "Invalid url response", code: -1))
                        return
                    }

                    let statusCode = httpResponse.statusCode
                    if statusCode < 200 || statusCode >= 300 {
                        var errorMessage = ""
                        if let data = data {
                            if let additionalString  = String(data: data, encoding: .utf8){
                                errorMessage = additionalString
                            }
                        }
                        reject(NetworkError(msg: errorMessage, code: statusCode))
                    } else {
                        fulfill(data!)
                    }
                }
            }).resume()
        }
    }
}

public struct NetworkError: Error {
    public let msg: String
    public let code: Int
    public var localizedDescription: String {
        return "There was a Network Error with code \(code) and a message: \(msg)"
    }
}

private enum httpMethodType: String {
    case POST, GET, PUT, DELETE
}
