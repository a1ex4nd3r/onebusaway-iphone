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
    private let visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: UIBlurEffectStyle.regular))

    override func loadView() {
        self.view = visualEffectView
        visualEffectView.contentView.layer.masksToBounds = false
        visualEffectView.contentView.layer.shadowRadius = 8.0
        visualEffectView.contentView.layer.shadowColor = UIColor.black.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        visualEffectView.contentView.addSubview(label)
        label.text = "I AM A DRAWER"
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
