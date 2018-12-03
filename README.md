<p align="center">
<img
src="https://s3.amazonaws.com/ryu-logos/RyuIcon128x128.png"
width="128px;">
</p>

<h1 align="center">NetworkUtils</h1>
<p align="center">
Swift package for handling HTTP requests
</p>

[![Version](https://img.shields.io/cocoapods/v/NetworkUtils.svg?style=flat)](https://cocoapods.org/pods/NetworkUtils)
[![License](https://img.shields.io/cocoapods/l/NetworkUtils.svg?style=flat)](https://cocoapods.org/pods/NetworkUtils)
[![Platform](https://img.shields.io/cocoapods/p/NetworkUtils.svg?style=flat)](https://cocoapods.org/pods/NetworkUtils)

## Author

[WyattMufson](wyatt@ryucoin.com) - cofounder of Ryu Blockchain Technologies

## Overview

NetworkUtils is a package for implementing HTTP network requests in Swift for iOS. The goal of the project is to replicate the funcitonality of the [axios](https://github.com/axios/axios) npm package used in nodejs.

It is built off of the [Foundation URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system) (similar to [Alamofire](https://github.com/Alamofire/Alamofire)). NetworkUtils uses Google's [Promises](https://github.com/google/promises) library for promise support.

## Installation

NetworkUtils is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
pod 'NetworkUtils'
```

And run ```pod install```.

## Example Usage

```swift
let networkUtils = NetworkUtils.shared

networkUtils.get("http://ip-api.com/json").then {(data) in
    print("Data found: \(data)")
}.catch {(error) in
    print("Error: \(error.localizedDescription)")
}
```
