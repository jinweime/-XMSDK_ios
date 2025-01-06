# XMSDK_ios

[![CI Status](https://img.shields.io/travis/Mingsheng Zhang/XMSDK_ios.svg?style=flat)](https://travis-ci.org/Mingsheng Zhang/XMSDK_ios)
[![Version](https://img.shields.io/cocoapods/v/XMSDK_ios.svg?style=flat)](https://cocoapods.org/pods/XMSDK_ios)
[![License](https://img.shields.io/cocoapods/l/XMSDK_ios.svg?style=flat)](https://cocoapods.org/pods/XMSDK_ios)
[![Platform](https://img.shields.io/cocoapods/p/XMSDK_ios.svg?style=flat)](https://cocoapods.org/pods/XMSDK_ios)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XMSDK_ios is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XMSDK_ios'
```

## demo
```ruby
platform :ios, '13.0'

# 如果有依赖第三方库，可以加上cocoapods的索引库地址
source 'https://cdn.cocoapods.org/'
# 私有库地址
source 'https://github.com/jinweime/sdk-cross-ios-config.git'

use_frameworks!
target 'iosApp' do
  pod 'XMSDK_ios', '~> 0.1.0'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
```

## Author

Mingsheng Zhang, 1046724509@qq.com

## License

XMSDK_ios is available under the MIT license. See the LICENSE file for more info.
