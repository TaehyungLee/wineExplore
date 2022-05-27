//
//  UTIL.swift
//  WineExplore
//
//  Created by Taehyung Lee on 2022/05/04.
//

import UIKit
import TAKUUID

@objc class UTIL: NSObject {
    // Device 고유 아이디
    class func getUUID() -> String {
        TAKUUIDStorage.sharedInstance().migrate()
        return TAKUUIDStorage.sharedInstance().findOrCreate() ?? ""
    }
}
