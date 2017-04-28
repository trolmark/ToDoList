//
//  TKAppDelegate.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation
import UIKit

@UIApplicationMain
class TKAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator : TaskCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let generator = TaskGenerator()
        self.coordinator = TaskCoordinator(generator)
        let flow = TaskUIFlow()
        
        self.coordinator?.windowController = flow
        self.window?.rootViewController = flow
        
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        self.coordinator?.showInitialPage()
        
        return true
    }
}
