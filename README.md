# Marshroute [![GitHub license](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://github.com/avito-tech/Marshroute/blob/master/LICENSE) [![GitHub release](https://img.shields.io/badge/Version-0.3.5-brightgreen.svg)](https://github.com/avito-tech/Marshroute/releases)  [![Swift 3 support](https://img.shields.io/badge/Swift 3-supported-brightgreen.svg)](https://github.com/avito-tech/Marshroute/pull/1) [![cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-blue.svg)](https://cocoapods.org) [![carthage compatible](https://img.shields.io/badge/Carthage-compatible-blue.svg)](https://github.com/Carthage/Carthage) 

## Overview

This repo contains the source code for making your `Router`s  simple but extremely powerful!

Every `Router`-driven transition is always forwarded to the topmost `UIViewController`
to make it super easy to support `DeepLink`s and for example present `Authorization` module from any point of your application. 
I prefer doing this right from my root application's `Router`.

This repo allows you to drive your transitions in a super clean, descriptive and flexible fashion. 
For example pretend the following code is taken from your root application's `Router`: 

```swift
func showAuthorization() {
    pushViewControllerDerivedFrom { routerSeed -> UIViewController in
        let authorizationAssembly = assemblyFactory.authorizationAssembly()

        let viewController = authorizationAssembly.module(
            routerSeed: routerSeed
        )

        return viewController
    }
}
```

This code pushes an `Authorization` view controller to the top `UINavigationController`'s stack.
The `routerSeed` parameter is only used to create a `Router` for the `Authorization` module.

The magic here is in this line of code:
```swift
pushViewControllerDerivedFrom { routerSeed -> UIViewController in
```

You can easily change the presentation style in favor of a modal transition by simply changing it to: 
```swift
presentModalNavigationControllerWithRootViewControllerDerivedFrom { routerSeed -> UIViewController in
```

If for some reason you do not need a `UINavigationController` for your `Authorization` module, you may accomplish this by:
```swift
presentModalViewControllerDerivedFrom { routerSeed -> UIViewController in
```

Once again, the transition will be forwarded to the top, keeping the `Router` very plain and straightforward.
So that, the `Router` keeps being responsible for only one thing: selecting the style of a transition. 

### Tuning the transition animation

You may add an animator to customize the way your transition looks like. For example

```swift
func showCategories() {
    presentModalNavigationControllerWithRootViewControllerDerivedFrom( { routerSeed -> UIViewController in
        let categoriesAssembly = assemblyFactory.categoriesAssembly()

        let viewController = categoriesAssembly.module(
            routerSeed: routerSeed
        )

        return viewController
    }, animator: RecursionAnimator())
}
```

The key line here is 
```swift
}, animator: RecursionAnimator())
```

So the syntax remains clean and it is super easy to switch back to the original animation style.

## Demo

Check out the [demo](https://github.com/avito-tech/Marshroute/tree/master/Example) project. 
This demo is written in `Swift` using `VIPER` architecture and shows all the capabilities which `Router`s are now full of.

Run this demo on a simulator and check out what happens if you simulate a memory warning or a device shake. 
You will see several types of transitions driven by the root module's `Router` (i.e. a `UITabBarController`'s `Router`).

The demo project targets both `iPhone` and `iPad` and adds some minor differences to their navigation behaviors by creating distinct `Router` implementations for every supported device idiom, thus highlighting the value of moving the navigation logic from the `View` layer in favor of a `Router` layer.

When you tap a blue timer tile, you schedule a reverse transition to the module that tile belongs to. 
To see this effect taking place, you should make several transitions deeper into the navigation stack. 

## Requirements

- iOS 8.0+
- Xcode 7.3+

## Installation
### CocoaPods

To install Marshroute using CocoaPods, add the following lines to your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Marshroute'
```

Then run `pod install` command. For details of the installation and usage of CocoaPods, visit [its official website](https://cocoapods.org).

### Carthage

To install Marshroute using Carthage, add the following lines to your `Cartfile`:
```ruby
github "avito-tech/Marshroute" ~> 0.3.5
```

Then run `carthage update --platform iOS` command. For details of the installation and usage of Carthage, visit [its  repo website](https://github.com/Carthage/Carthage).

## Contacts
Feel free to send your questions at `tyusipov@avito.ru`

## License
MIT

## Objective-c support
The framework is written in pure `swift` using its latest features, so if you want to use `Marshroute` in your `objective-c` application you will have to write your `Router`s in `swift`.
