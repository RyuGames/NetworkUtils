# NetworkUtils

[![Version](https://img.shields.io/cocoapods/v/NetworkUtils.svg?style=flat)](https://cocoapods.org/pods/NetworkUtils)
[![License](https://img.shields.io/cocoapods/l/NetworkUtils.svg?style=flat)](https://cocoapods.org/pods/NetworkUtils)
[![Platform](https://img.shields.io/cocoapods/p/NetworkUtils.svg?style=flat)](https://cocoapods.org/pods/NetworkUtils)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Installation

NetworkUtils is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
pod 'NetworkUtils'
```

## Author

WyattMufson, wyatt@ryucoin.com

### Update Pod

```ruby
pod trunk push NetworkUtils.podspec

```

## Example Usage

```swift
let networkUtils = NetworkUtils.shared

networkUtils.httpMethod(urlLink: "http://ip-api.com/json", method: .GET, params: [:], completionClosure: {data in
    if data == nil {
        print("Data was nil")
    } else {
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            guard let status = json["status"] as? String else {
                return
            }
            print(status)
        } catch let parseError as NSError {
            print("JSON Error \(parseError.localizedDescription)")
        }
    }
})
```
