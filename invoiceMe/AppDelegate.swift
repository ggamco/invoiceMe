//
//  AppDelegate.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 9/3/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "GPCnMgZWwWcTKToE02nMOfomH8lVSDCVDKGs3bQr"
            $0.clientKey = "c0Lt5ww44YHZdES7EqtqKbSuypz4b8m4iYi8KZvZ"
            $0.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: configuration)
        
        //personalizar ui
        personalizaUI()
        
        return true
    }
    
    func personalizaUI(){
        let font = UIFont(name: "HelveticaNeue", size: 16.0)
        let navBar = UINavigationBar.appearance()
        let tabBar = UITabBar.appearance()
        let toolBar = UIToolbar.appearance()
        let buttonItem = UIBarButtonItem.appearance()
        
        navBar.barTintColor = CONSTANTES.COLORES.PRIMARY_COLOR
        navBar.isTranslucent = false
        navBar.barStyle = .black
        navBar.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        navBar.titleTextAttributes = [NSForegroundColorAttributeName : CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT, NSFontAttributeName: font!]
        
        navBar.backIndicatorImage = UIImage(named: "arrow2")
        navBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow2mask")

        tabBar.barTintColor = CONSTANTES.COLORES.PRIMARY_COLOR
        tabBar.barStyle = .black
        tabBar.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        tabBar.unselectedItemTintColor = CONSTANTES.COLORES.FIRST_TEXT_COLOR
        
        toolBar.barTintColor = CONSTANTES.COLORES.PRIMARY_COLOR
        toolBar.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        
        buttonItem.setTitleTextAttributes([NSFontAttributeName: font!], for: .normal)
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let TOKEN_DEVICE = deviceToken.reduce("", {$0 + String(format: "%02X",    $1)})
        print("deviceToken: \(TOKEN_DEVICE)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStack.shared.saveContext()
    }

}

