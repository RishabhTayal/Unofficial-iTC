//
//  AppDelegate.swift
//  ReviewMonitor
//
//  Created by Tayal, Rishabh on 9/7/17.
//  Copyright © 2017 Tayal, Rishabh. All rights reserved.
//

import UIKit
import LocalAuthentication
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var blurEffectView: UIVisualEffectView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        #if DEBUG
        #else
            Fabric.with([Answers.self, Crashlytics.self])
        #endif

        if AccountManger.getAccountArray().count == 0 {
            window?.rootViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        } else {
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        if UserDefaults.standard.bool(forKey: "useBiometrics") {
            let context = LAContext()
            var error: NSError?
            addBlurView()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate."
                context.localizedFallbackTitle = ""
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            self.removeBlurView()
                        } else {
                            // Blurred, need changes
                        }
                    }
                }
            } else {
                removeBlurView()
            }
        }
        window?.makeKeyAndVisible()
        return true
    }

    func showAppView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }

    func addBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        let view = window?.rootViewController?.view
        blurEffectView?.frame = (view?.bounds)!
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        if !view!.subviews.contains(blurEffectView!) {
            view?.addSubview(blurEffectView!)
        }
    }

    func removeBlurView() {
        blurEffectView?.removeFromSuperview()
    }

    var startBack = Date()
    func applicationDidEnterBackground(_ application: UIApplication) {
        startBack = Date()
        addBlurView()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        ReachabilityManager.shared.startMonitoring()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        ReachabilityManager.shared.stopMonitoring()

        if Date().timeIntervalSince(startBack) >= 30 && UserDefaults.standard.bool(forKey: "useBiometrics") {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate."
                context.localizedFallbackTitle = ""
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            self.removeBlurView()
                        } else {
                            // Still blurred
                            //                            let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                            //                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            //                            self.present(ac, animated: true)
                        }
                    }
                }
            } else {
                removeBlurView()
            }
        } else {
            removeBlurView()
        }
    }
}
