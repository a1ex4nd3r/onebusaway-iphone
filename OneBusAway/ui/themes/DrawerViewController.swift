//
//  DrawerViewController.swift
//  OneBusAway
//
//  Created by Aaron Brethorst on 12/14/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

import UIKit
import SnapKit

class DrawerViewController: UIViewController {
    private let label = UILabel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(label)
        label.text = "I AM A DRAWER"
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
