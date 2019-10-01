//
//  NetworkUtils.swift
//  NetworkUtils
//
//  Created by Wyatt Mufson on 12/3/18.
//  Copyright © 2019 Ryu Blockchain Technologies. All rights reserved.
//

import Foundation
import SwiftPromises

public let networkUtils = NetworkUtils.main
public let reachability = NetworkUtils.reachability

public typealias NUPromise<Value> = BasePromise<Value, NetworkError>

public let NUDefaultHeaders: [String: String] = ["Content-Type": "application/json", "Accept": "application/json"]

public final class NetworkUtils: NSObject {
    public static let main = NetworkUtils()
    public static let reachability = Reachability.shared
    private let retryErrors = [NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut]
    internal var testing: Bool = false

    public func post(dispatchQueue: DispatchQueue? = nil, _ urlLink: String, _ params: [String: Any] = [:], _ retry: Int = 3, headers: [String: String] = NUDefaultHeaders) -> NUPromise<Data> {
        return httpMethod(dispatchQueue: dispatchQueue, urlLink: urlLink, method: .POST, params: params, retry: retry, headers: headers)
    }

    public func get(dispatchQueue: DispatchQueue? = nil, _ urlLink: String, _ params: [String: Any] = [:], _ retry: Int = 3, headers: [String: String] = NUDefaultHeaders) -> NUPromise<Data> {
        return httpMethod(dispatchQueue: dispatchQueue, urlLink: urlLink, method: .GET, params: params, retry: retry, headers: headers)
    }

    public func put(dispatchQueue: DispatchQueue? = nil, _ urlLink: String, _ params: [String: Any] = [:], _ retry: Int = 3, headers: [String: String] = NUDefaultHeaders) -> NUPromise<Data> {
        return httpMethod(dispatchQueue: dispatchQueue, urlLink: urlLink, method: .PUT, params: params, retry: retry, headers: headers)
    }

    public func delete(dispatchQueue: DispatchQueue? = nil, _ urlLink: String, _ params: [String: Any] = [:], _ retry: Int = 3, headers: [String: String] = NUDefaultHeaders) -> NUPromise<Data> {
        return httpMethod(dispatchQueue: dispatchQueue, urlLink: urlLink, method: .DELETE, params: params, retry: retry, headers: headers)
    }

    private func httpMethod(dispatchQueue: DispatchQueue?, urlLink: String, method: httpMethodType, params: [String: Any], retry: Int, headers: [String: String]) -> NUPromise<Data> {
        return NUPromise<Data>(dispatchQueue: dispatchQueue) { fulfill, reject in
            let url = URL(string: urlLink)
            var request = URLRequest(url: url!)
            let count = params.keys.count

            if count > 0 {
                if (method.rawValue == "POST" || method.rawValue == "PUT"){
                    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                } else if (method.rawValue == "GET" || method.rawValue == "DELETE"){
                    let keys = Array(params.keys)
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
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }

            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    let code = (error as NSError).code
                    if (self.retryErrors.contains(code) || self.testing) && retry > 0 {
                        self.httpMethod(dispatchQueue: dispatchQueue, urlLink: urlLink, method: method, params: params, retry: retry - 1, headers: headers).then { (data) in
                            fulfill(data)
                        }.catch { (err) in
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
                        if let data = data, let additionalString = String(data: data, encoding: .utf8){
                            errorMessage = additionalString
                        }
                        reject(NetworkError(msg: errorMessage, code: statusCode))
                    } else {
                        fulfill(data!)
                    }
                }
            }.resume()
        }
    }
}

public struct NetworkError: Error {
    public let msg: String
    public let code: Int
    public var localizedDescription: String {
        return "There was a Network Error with code \(code) and a message: \(msg)"
    }

    public var errorMessage: String {
        guard let data = msg.data(using: .utf8),
            let error = try? JSONDecoder().decode(ServerError.self, from: data) else {
                return msg
        }

        return error.error
    }

    public init(msg: String, code: Int) {
        self.msg = msg
        self.code = code
    }
}

public struct ServerError: Codable {
    public var error: String
    public var errorDict: [String: String] {
        return ["error": error]
    }

    public init(error: String) {
        self.error = error
    }
}

private enum httpMethodType: String {
    case POST, GET, PUT, DELETE
}
