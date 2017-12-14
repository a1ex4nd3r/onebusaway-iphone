//
//  StopNavigationTarget.swift
//  OBAKit
//
//  Created by Aaron Brethorst on 12/14/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

import Foundation

@objc public class StopNavigationTarget: OBANavigationTarget {
    public let stopID: String

    public override var target: OBANavigationTargetType {
        get {
            return .stopID
        }
    }

    public override var object: Any {
        get {
            return self.stopID
        }
        set {
            // no-op.
        }
    }

    @objc public init(stopID: String) {
        self.stopID = stopID

        super.init()
    }

    private static let kStopIDKey = "stopID"

    public required init?(coder aDecoder: NSCoder) {
        self.stopID = aDecoder.decodeObject(forKey: StopNavigationTarget.kStopIDKey) as! String
        super.init(coder: aDecoder)
    }

    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.stopID, forKey: StopNavigationTarget.kStopIDKey)
    }

}
