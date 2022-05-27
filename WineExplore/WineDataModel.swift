//
//  WineDataModel.swift
//  WineExplore
//
//  Created by Taehyung Lee on 2022/05/02.
//

import UIKit

struct WineDataModel:Codable {
    var no = 0
    var koreanName:String = ""
    var originName:String? = ""
    var country:String? = ""
    var region1:String? = ""
    var region2:String? = ""
    var price:Int? = 0
    
}
