# NetworkManager

[![Version](https://img.shields.io/cocoapods/v/NetworkManager.svg?style=flat)](https://cocoapods.org/pods/NetworkManager)
[![License](https://img.shields.io/cocoapods/l/NetworkManager.svg?style=flat)](https://cocoapods.org/pods/NetworkManager)
[![Platform](https://img.shields.io/cocoapods/p/NetworkManager.svg?style=flat)](https://cocoapods.org/pods/NetworkManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

[How to create a pod](https://medium.com/practical-code-labs/how-to-create-private-cocoapods-in-swift-3cc199976a18)

### Installation

RyuConnect-Swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
pod 'NetworkManager'

source 'https://github.com/RyuCoin/RyuSpecRepo.git'
source 'https://github.com/CocoaPods/Specs.git'
```

## Author

WyattMufson, wyatt@ryucoin.com

### Update Pod

First run the following to verify that the update will go through:

```ruby
pod spec lint --allow-warnings

```

Next push the pod the Ryu spec repo.

```ruby
pod repo push RyuSpecRepo NetworkManager.podspec

```
