

  


# 1. Overview

 1. YCProductSDK-Swift is a toolkit provided by Shenzhen Yucheng Innovation Technology for users to develop iOS App. This toolkit is only suitable for wearable devices such as watches developed by Yucheng Innovation.

2. The SDK is compatible with both Objective-C and Swfit5.x languages
3. The code in the Example directory can be run directly, and the use of each API is demonstrated in the Demo.
4. The Sources directory contains some resource files that may be used
5. There are all instructions about SDK usage in Docs, corresponding to Example.


1.YCProductSDK-Swift 是 深圳玉成创新科技提供给用户用于开发iOS App的工具包，此工具包只适用于玉成创新开发的手表等穿戴设备。

2. SDK同时兼容的Objective-C和Swfit5.x语言
3. Example目录中的代码可以直接运行，Demo中演示了各个API的使用。
4. Sources目录中包含一些可能用的上的资源文件
5. Docs中有关于SDK使用的所有说明，与Example对应。

# 2. Installation with CocoaPods

> arm64，  iOS 9.0+， iPhone Simulator is not supported

```bash
platform :ios, '9.0'

target 'Your app' do 
	use_frameworks!
	
	pod 'YCProductSDK-Swift'
	
end
```



# 3. Import SDK

```objective-c
// Objective-C
@import CoreBluetooth;
@import YCProductSDK;
```



```swift
// Swift
import CoreBluetooth 
import YCProductSDK
```



## 4. How To Get Started

View Chinese and English document descriptions in Docs


> 自 2024年1月1日起，将不再维护此代码。

