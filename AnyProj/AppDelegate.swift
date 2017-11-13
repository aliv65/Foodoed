//
//  AppDelegate.swift
//  AnyProj
//
//  Created by Александр Иванин on 11.11.17.
//

import UIKit
import IQKeyboardManager
import MMDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawer: MMDrawerController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        SearchManager.shared.delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        updateMainController()
        window?.makeKeyAndVisible()
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
    
    private func updateMainController() {
        if SearchManager.shared.emptySearchParameters {
            setupFirstSearchUI()
        } else {
            window?.rootViewController = TabbarController()
            SearchManager.shared.search()
        }
    }

    private func setupFirstSearchUI() {
        let navigationController = SearchNaigationController(rootViewController: StartViewController())
        drawer = MMDrawerController(center: navigationController, leftDrawerViewController: AdditionalInfoViewController())
        
        // Configure drawer
        drawer.openDrawerGestureModeMask = .custom
        drawer.closeDrawerGestureModeMask = [
            .panningCenterView,
            .panningDrawerView,
            .panningNavigationBar,
            .bezelPanningCenterView,
            .tapCenterView,
            .tapNavigationBar
        ]
        drawer.showsShadow = false
        drawer.shouldStretchDrawer = false
        
        drawer.setMaximumLeftDrawerWidth(UIScreen.main.bounds.width * 0.8, animated: true, completion: nil)
        
        // callback блок вызываемый при попытке жестом открыть drawer
        let setGustureRecognizer = { [weak self] in
            self?.drawer.setGestureShouldRecognizeTouch { (drawerController, gestureRecognizer, touch) -> Bool in
                if let drawerController = drawerController, drawerController.openSide == .none {
                    guard let controller = drawerController.centerViewController as? ViewControllerInDrawer else {
                        return false
                    }
                    return controller.isDrawerEnable()
                }
                return false
            }
        }
        setGustureRecognizer()
        self.window?.rootViewController = drawer
    }
}

extension AppDelegate : SearchManagerDelegate {
    func reloadMainController() {
        updateMainController()
    }
    
    func reloadSearchResults(with products: [Product]) {
        guard let tabbarController = window?.rootViewController as? TabbarController else {
            assertionFailure("Invalid root view controller: \(String(describing: window?.rootViewController))")
            return
        }
        
        if let controllers = tabbarController.viewControllers,
            let searchController = controllers[0] as? SearchViewController {
            tabbarController.selectedIndex = 0
            searchController.reloadData(with: products)
        }
    }
}
