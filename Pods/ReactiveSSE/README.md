# ReactiveSSE

[![CI Status](http://img.shields.io/travis/banjun/ReactiveSSE.svg?style=flat)](https://travis-ci.org/banjun/ReactiveSSE)
[![Version](https://img.shields.io/cocoapods/v/ReactiveSSE.svg?style=flat)](http://cocoapods.org/pods/ReactiveSSE)
[![License](https://img.shields.io/cocoapods/l/ReactiveSSE.svg?style=flat)](http://cocoapods.org/pods/ReactiveSSE)
[![Platform](https://img.shields.io/cocoapods/p/ReactiveSSE.svg?style=flat)](http://cocoapods.org/pods/ReactiveSSE)

ReactiveSSE is a `ReactiveSwift.SignalProducer` acting as Server-Sent Events (SSE) parser.
<https://www.w3.org/TR/eventsource/>

SSE stream is buffered and parsed in a background queue and can be observed via  its signal.

## Usage

```swift
let sse = ReactiveSSE(urlRequest: URLRequest(url: URL(string: endpoint)!))
sse.producer.observe(on: QueueScheduler.main).startWithValues { (v: SSEvent) in
    v.type // String: "message", "update", or whatever
    v.data // String: json payload string, any value string, or whatever
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ReactiveSSE is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ReactiveSSE'
```

## Author

@banjun

## License

ReactiveSSE is available under the MIT license. See the LICENSE file for more info.
