<p align="center">
<img
src="https://s3.amazonaws.com/ryu-logos/RyuIcon128x128.png"
width="128px;">
</p>

<h1 align="center">NetworkUtils</h1>
<p align="center">
Swift package for handling HTTP requests
</p>

[![Build Status](https://travis-ci.com/Ryucoin/NetworkUtils.svg?branch=master)](https://travis-ci.com/Ryucoin/NetworkUtils)
[![Version](https://img.shields.io/cocoapods/v/NetworkUtils.svg?style=flat)](https://cocoapods.org/pods/NetworkUtils)
[![License](https://img.shields.io/cocoapods/l/NetworkUtils.svg?style=flat)](./LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/NetworkUtils.svg?style=flat)](https://cocoapods.org/pods/NetworkUtils)

- [Overview](#overview)
- [Installation](#installation)
- [Example Usage](#example-usage)
- [Author](#author)
- [License](#license)

## Overview

NetworkUtils is a package for implementing HTTP network requests in Swift for iOS. The goal of the project is to replicate the functionality of the [axios](https://github.com/axios/axios) npm package used in nodejs.

It is built off of the [Foundation URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system) (similar to [Alamofire](https://github.com/Alamofire/Alamofire)). NetworkUtils uses Google's [Promises](https://github.com/google/promises) library for promise support.

## Installation

NetworkUtils is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
pod 'NetworkUtils'
```

And run ```pod install```.

## Example Usage

### HTTP Requests

Making an HTTP request with `NetworkUtils` is really simple. Use the `NetworkUtils.main` singleton object and one of the HTTP methods: `post`, `get`, `put` and `delete`.

Here is an example HTTP GET request:

``` swift
let networkUtils = NetworkUtils.main

networkUtils.get("http://ip-api.com/json").then {(data) in
  print("Data found: \(data)")
}.catch {(error) in
  print("Error: \(error.localizedDescription)")
}
```

#### Error Handling

`NetworkUtils` offers a very basic subclass of `Error` named `NetworkError`:

``` swift
public struct NetworkError: Error {
  public let msg: String
  public let code: Int
}
```

You can cast the returned `Error` to a `NetworkError` and access both of it's fields:

``` swift
}.catch {(err) in
  let error = err as! NetworkError
  let code = error.code
  let msg = error.msg
}
```

### Reachability

`NetworkUtils` also offers reachability services. Access reachability with `NetworkUtils.reachability` such as in the following example:

``` swift
let reachability = NetworkUtils.reachability

switch reachability.connection {
case .wifi:
    print("Reachable via WiFi")
case .cellular:
    print("Reachable via Cellular")
case .none:
    print("Not Reachable")
}
```

## Author

[WyattMufson](mailto:wyatt@ryucoin.com) - cofounder of Ryu Blockchain Technologies

## License

`NetworkUtils` is available under the [MIT license](./LICENSE).
