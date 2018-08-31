//
//  AppDelegate.swift
//  iTA
//
//  Created by Shuyang Zang on 2018-07-03.
//  Copyright © 2018 Shuyang Zang. All rights reserved.
//

import UIKit
import Stripe
import VimeoNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        STPPaymentConfiguration.shared().publishableKey = "pk_test_qglYITXHpo49PPtffT2vQEcg"
        let appConfiguration = AppConfiguration(
            clientIdentifier: "6acfef25fb4b5bf0996de716a6a6578913cfee68",
            clientSecret: "zf66Fic9htXi5nhoWfGAeQcwSkkAAJ5lofnJEEAK8zP+Sio7LiyLNiSkL3ML9Zw0hKxaDHebcdiIX2hBzph7cLej85fG82NIBrxki60XTkZrY4qLHAcA0TuT7Ts2tyrb",
            scopes: [.Public, .Private],
            keychainService: "com.vimeo.keychain_service"
        )
        let vimeoClient = VimeoClient(appConfiguration: appConfiguration)
        let authenticationController = AuthenticationController(client: vimeoClient, appConfiguration: appConfiguration)
        let loadedAccount: VIMAccount?
        do
        {
            loadedAccount = try authenticationController.loadUserAccount()
        }
        catch let error
        {
            loadedAccount = nil
            print("error loading account \(error)")
        }
        
        // If we didn't find an account to load or loading failed, we'll authenticate using client credentials
        
        if loadedAccount == nil
        {
            authenticationController.clientCredentialsGrant { result in
                
                switch result
                {
                case .success(let account):
                    print("authenticated successfully: \(account)")
                    if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Authentication") as? Authentication {
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(controller, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    let appConfiguration = AppConfiguration(
                        clientIdentifier: "6acfef25fb4b5bf0996de716a6a6578913cfee68",
                        clientSecret: "zf66Fic9htXi5nhoWfGAeQcwSkkAAJ5lofnJEEAK8zP+Sio7LiyLNiSkL3ML9Zw0hKxaDHebcdiIX2hBzph7cLej85fG82NIBrxki60XTkZrY4qLHAcA0TuT7Ts2tyrb",
                        scopes: [.Public, .Private],
                        keychainService: "com.vimeo.keychain_service"
                    )
                    let vimeoClient = VimeoClient(appConfiguration: appConfiguration)
                    let authenticationController = AuthenticationController(client: vimeoClient, appConfiguration: appConfiguration)
                    
                    let URL = authenticationController.codeGrantAuthorizationURL()
                    UIApplication.shared.openURL(URL)
                    print("failure authenticating: \(error)")
                }
            }
        }
        return true
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
    }


}

