This repo contains the source code for making your `Router`s  simple but extremely powerful!

Every `Router`-driven transition is always forwarded to the topmost `UIViewcontroller`
to make it super easy to support `DeepLink`s and for example present `Authorization` module from any point of your application. 
I prefer doing this right from my root application's `Router`.

This repo allows you to drive your transitions in a super clean, descriptive and flexible fashion. 
For example pretend the following code is taken from your root application's `Router`: 

```
func showAuthorziation() {
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
```
pushViewControllerDerivedFrom { routerSeed -> UIViewController in
```

You can easily change the presentation style in favor of a modal transition by simply changing it to: 
```
presentModalNavigationControllerWithRootViewControllerDerivedFrom { routerSeed -> UIViewController in
```

If for some reason you do not need a `UINavigationController` for your `Authorization` module, you may accomplish this by:
```
presentModalViewControllerDerivedFrom { routerSeed -> UIViewController in
```

Once again, the transition will be forwarded to the top, keeping the `Router` very plain and straightforward.
So that, the `Router` keeps being responsible for only one thing: selecting the style of a transition. 


Check out the [demo](https://github.com/avito-tech/Marshroute/tree/master/Example) project at. 
This demo is written in `Swift` using `VIPER` architecture and shows all the capabilities which `Router`s are now full of.
Run this demo on a simulator and check out what happens if you simulate a memory warning or a device shake. You will see several types of transitions driven by the root module's `Router` (i.e. a `UITabBarController`'s `Router`).
Check this demo on your `iPhone` and `iPad` simulators, because their navigation behavior slightly differs to make the demo more rich and descriptive.

When you tap a blue timer tile, you schedule a reverse transition to the module that tile belongs to. 
To see this effect taking place, you should make several transitions deeper to the navigation stack. 