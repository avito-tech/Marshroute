//
//  AppDelegate.swift
//  Navigation-Prototype
//
//  Created by Тимур Юсипов on 21/01/16.
//  Copyright © 2016 Тимур Юсипов. All rights reserved.
//

import UIKit

private class WindowHolderImpl {
    static var instance = WindowHolderImpl()

    private var window: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let windowHolder = WindowHolderImpl.instance
        let window = windowHolder.window
        
        let applicationModule = AssemblyFactory.applicationModuleAssembly().module()
        
        window.rootViewController = applicationModule.0
        window.makeKeyAndVisible()
        
        return true
    }
}

