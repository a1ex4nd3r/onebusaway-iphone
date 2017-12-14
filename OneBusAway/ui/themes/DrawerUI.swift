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
            let stopController = OBAStopViewController.init(stopID: navigationTarget.object as! String)
            mapNavigation.present(stopController, animated: true, completion: nil)
        }
    }
}
