# Marshroute
[![GitHub license](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://github.com/avito-tech/Marshroute/blob/master/LICENSE) [![GitHub release](https://img.shields.io/badge/Version-0.4.0-brightgreen.svg)](https://github.com/avito-tech/Marshroute/releases)  [![Swift 3 support](https://img.shields.io/badge/Swift%203-supported-brightgreen.svg)](https://github.com/avito-tech/Marshroute/pull/1) [![cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-blue.svg)](https://cocoapods.org) [![carthage compatible](https://img.shields.io/badge/Carthage-compatible-blue.svg)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/avito-tech/Marshroute.svg?branch=master)](https://travis-ci.org/avito-tech/Marshroute) [![Code Coverage](https://img.shields.io/codecov/c/github/avito-tech/Marshroute.svg)](https://codecov.io/gh/avito-tech/Marshroute)

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

## 3d touch support

## `PeekAndPopUtility`

Want to add fancy peek and pop previews? Easy peasy! Just use `PeekAndPopUtility` from the `MarshrouteStack` and register your view controller as capable of previewing other controllers!

```swift
peekAndPopUtility.register(
    viewController: self,
    forPreviewingInSourceView: peekSourceView,
    onPeek: { [weak self] (previewingContext, location) in
        self?.startPeekWith(
            previewingContext: previewingContext,
            location: location
        )
    },
    onPreviewingContextChange: nil
)
```

`peekSourceView` is used by `UIKit` during preview animations to take screenshots from. You can register single view controller for previewing in many source views (e.g.: in a table view and in a navigation bar).

`onPeek` closure will get called every time a force touch gesture occurs in a `peekSourceView`. In your `startPeekWith(previewingContext:location:)` method you should do the following:

1. Find a view which a user interacts with (interactable view). You should use a specified `location` in `previewingContext.sourceView`'s coordinate system.

1. Adjust `sourceRect` of a `previewingContext`. You should convert a frame of that interactable view to `previewingContext.sourceView`'s coordinate system. `UIKit` uses `sourceRect` to keep it visually sharp when a user presses it, while blurring all surrounding content.

1. Invoke the transition, that will normally occur if a user simply taps at a same `location`.
For example, it a user presses a `UIControl`, you may call `sendActions(for: .touchUpInside)` to invoke that `UIControl`'s an action handler. 

Lets pretend the above-mentioned action handler ends up with some router calling `pushViewControllerDerivedFrom(_:)` to push a new view controller.
In this case no pushing will actually occur. Instead of this, `Marshroute` will freeze a transition and present a target view controller in a preview mode.
The transition will eventually get performed only if a user commits the preview (i.e. pops).

The above described behavior takes place only during active `peek` requests (when `UIViewControllerPreviewingDelegate` requests a view controller to be previewed).
In all other situations, `pushViewControllerDerivedFrom(_:)` will push immediately as expected.

Important note: if you invoke no transition within `onPeek` closure, or invoke an asynchronous transition, no `peek` will occur.
This behavior is a result of `UIKit` Api restrictions: `UIViewControllerPreviewingDelegate` is required to return a previewing view controller synchronously.

You can also use `onPreviewingContextChange` closure to set up your gesture recognizer failure relationships.

## `PeekAndPopStateObservable` and `PeekAndPopStateViewControllerObservable`

You can use `PeekAndPopStateObservable` from the `MarshrouteStack` to observe any view controller's `peek and pop` state changes. 
This may be useful for analytics purposes.


```swift
peekAndPopStateObservable.addObserver(
    disposable: self,
    onPeekAndPopStateChange: { viewController, peekAndPopState in
        debugPrint("viewController: \(viewController) changed `peek and pop` state: \(peekAndPopState)")
    }
)
```

You can also use `PeekAndPopStateViewControllerObservable` to observe your particular view controller's `peek and pop` state changes. 
This may be useful for adjusting view controller's appearance in `peek` and `popped` modes.

```swift
peekAndPopStateViewControllerObservable.addObserver(
    disposableViewController: self,
    onPeekAndPopStateChange: { [weak self] peekAndPopState in
        switch peekAndPopState {
        case .inPeek:
            self?.onPeek?()
        case .popped:
            self?.onPop?()
        case .cancelled:
            break
        }
    }
)
```

Here in `onPeek` and `onPop` closures your `Presenter` may force a view to update its UI accordingly

```swift
view?.onPeek = { [weak self] in
    self?.view?.setSimilarSearchResultsHidden(true)
}

view?.onPop = { [weak self] in
    self?.view?.setSimilarSearchResultsHidden(false)
}
```

## Demo

Check out the [demo](https://github.com/avito-tech/Marshroute/tree/master/Example) project. 
This demo is written in `Swift` using `VIPER` architecture and shows all the capabilities which `Router`s are now full of.

Run this demo on a simulator and check out what happens if you simulate a memory warning or a device shake. 
You will see several types of transitions driven by the root module's `Router` (i.e. a `UITabBarController`'s `Router`).

The demo project targets both `iPhone` and `iPad` and adds some minor differences to their navigation behaviors by creating distinct `Router` implementations for every supported device idiom, thus highlighting the value of moving the navigation logic from the `View` layer in favor of a `Router` layer.

When you tap a blue timer tile, you schedule a reverse transition to the module that tile belongs to. 
To see this effect taking place, you should make several transitions deeper into the navigation stack.

Starting with 0.4.0 the demo project was updated to show `PeekAndPopUtility` in action: you can press on any table view cell and navigation bar button to get a preview of an underlying transition.
You can also learn how to use `PeekAndPopStateViewControllerObservable` to adjust `AdvertisementViewController`'s appearance in `peek` and `popped` modes: in a `peek` mode you will see only a fullscreen colored image pattern, while in a `popped` mode you will also see a similar advertisements section.

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
github "avito-tech/Marshroute" ~> 0.4.0
```

Then run `carthage update --platform iOS` command. For details of the installation and usage of Carthage, visit [its  repo website](https://github.com/Carthage/Carthage).

## Contacts
Feel free to send your questions at `tyusipov@avito.ru`

## License
MIT

## Objective-c support
The framework is written in pure `Swift` using its latest features, so if you want to use `Marshroute` in your `Objective-c` application you will have to write your `Router`s in `Swift`.
