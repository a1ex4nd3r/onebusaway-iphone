//
//  DrawerUI.swift
//  OneBusAway
//
//  Created by Aaron Brethorst on 12/14/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

import UIKit

class DrawerUI: NSObject, OBAApplicationUI {
    private let mapController = OBAMapViewController.init()
    private lazy var mapNavigation: UINavigationController = {
        return UINavigationController.init(rootViewController: mapController)
    }()
    private let drawer = DrawerViewController.init()

    override init() {
        super.init()

        mapController.oba_addChildViewController(drawer, settingFrame: false)
        drawer.view.frame = CGRect.init(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }

    var rootViewController: UIViewController {
        get {
            return mapNavigation
        }
    }

    func performAction(for shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        //
    }

    func applicationDidBecomeActive() {
        //
    }

    func navigate(toTargetInternal navigationTarget: OBANavigationTarget) {
        if navigationTarget.target == .stopID {

//            let stopController = OBAStopViewController.init(stopID: navigationTarget.object as! String)
//            stopController.displaysHeader = false
//            let nav = UINavigationController.init(rootViewController: stopController)
//
//            let pulley = PullUpController.init()
//            pulley.oba_addChildViewController(nav)
//
//            mapNavigation.addPullUpController(pulley)
        }
    }
}
