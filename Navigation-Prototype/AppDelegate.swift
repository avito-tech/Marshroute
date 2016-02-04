//
//  AppDelegate.swift
//  Navigation-Prototype
//
//  Created by Тимур Юсипов on 21/01/16.
//  Copyright © 2016 Тимур Юсипов. All rights reserved.
//

import UIKit

protocol NavigationRootsHolder: class {
    var rootTransitionsHandler: TransitionsHandler? { get set }
    var transitionsCoordinator: TransitionsCoordinator { get }
}

private class NavigationRootsHolderImpl: NavigationRootsHolder {
    static var instance = NavigationRootsHolderImpl()
    
    private var rootTransitionsHandler: TransitionsHandler?
    private var window: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
    private var transitionsCoordinator = TransitionsCoordinatorImpl(
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    weak var applicationModuleInput: ApplicationModuleInput? // Presenter
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let navigationRootsHolder = NavigationRootsHolderImpl.instance
        let window = navigationRootsHolder.window
        
        let applicationModule = AssemblyFactory.applicationModuleAssembly().module(navigationRootsHolder)
        
        window.rootViewController = applicationModule.0
        applicationModuleInput = applicationModule.1
        window.makeKeyAndVisible()
        
        return true
    }
    
    static var instance: AppDelegate? {
        return UIApplication.sharedApplication().delegate as? AppDelegate
    }
    
}

