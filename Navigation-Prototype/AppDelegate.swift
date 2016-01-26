//
//  AppDelegate.swift
//  Navigation-Prototype
//
//  Created by Тимур Юсипов on 21/01/16.
//  Copyright © 2016 Тимур Юсипов. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    weak var applicationModuleInput: ApplicationModuleInput? // Presenter

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        applicationModuleInput = AssemblyFactory.applicationModuleAssembly().module()
        return true
    }

    var instance: AppDelegate? {
        return UIApplication.sharedApplication().delegate as? AppDelegate
    }

}

