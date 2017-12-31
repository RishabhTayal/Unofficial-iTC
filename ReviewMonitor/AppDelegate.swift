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
        #if DEBUG
        #else
            Fabric.with([Answers.self, Crashlytics.self])
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        if AccountManger.getAccountArray().count == 0 {
            window?.rootViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        } else {
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        window?.makeKeyAndVisible()
        return true
    }

    func showAppView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }

    func addBlueView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        let view = window?.rootViewController?.view
        blurEffectView?.frame = (view?.bounds)!
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        view?.addSubview(blurEffectView!)
    }

    func removeBlurView() {
        blurEffectView?.removeFromSuperview()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print(Date())
        addBlueView()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        removeBlurView()
    }

    //    func applicationWillEnterForeground(_ application: UIApplication) {
    //        let touchIDManager = AccountManger()
    //
    //        addBlueView()
    //
    //        touchIDManager.authenticateUser(success: { () -> Void in
    //            OperationQueue.main.addOperation({ () -> Void in
    //                //                self.loadDada()
    //                self.removeBlurView()
    //            })
    //        }, failure: { (evaluationError: NSError) -> Void in
    //            switch evaluationError.code {
    //            case LAError.Code.systemCancel.rawValue:
    //                print("Authentication cancelled by the system")
    //                //                self.statusLabel.text = "Authentication cancelled by the system"
    //            case LAError.Code.userCancel.rawValue:
    //                print("Authentication cancelled by the user")
    //                //                self.statusLabel.text = "Authentication cancelled by the user"
    //            case LAError.Code.userFallback.rawValue:
    //                print("User wants to use a password")
    //                //                self.statusLabel.text = "User wants to use a password"
    //                // We show the alert view in the main thread (always update the UI in the main thread)
    //                OperationQueue.main.addOperation({ () -> Void in
    //                    //                    self.showPasswordAlert()
    //                })
    //            case LAError.Code.touchIDNotEnrolled.rawValue:
    //                print("TouchID not enrolled")
    //                //                self.statusLabel.text = "TouchID not enrolled"
    //            case LAError.Code.passcodeNotSet.rawValue:
    //                print("Passcode not set")
    //                //                self.statusLabel.text = "Passcode not set"
    //            default:
    //                print("Authentication failed")
    //                //                self.statusLabel.text = "Authentication failed"
    //                OperationQueue.main.addOperation({ () -> Void in
    //                    //                    self.showPasswordAlert()
    //                })
    //            }
    //        })
    //    }
}

extension UIView {
    public func addBorder(_ width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    public func cornerRadius(_ radius: CGFloat) {
        layoutIfNeeded()
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
