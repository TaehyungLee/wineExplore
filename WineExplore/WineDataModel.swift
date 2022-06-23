//
//  WineDataModel.swift
//  WineExplore
//
//  Created by Taehyung Lee on 2022/05/02.
//

import UIKit

struct WineDataModel:Codable {
    var koreanName:String = ""
    var originName:String? = ""
    var country:String? = ""
    var region1:String? = ""
    var region2:String? = ""
    var price:Int? = 0
    
    var dictionary:[String:Any] {
        
        return [
            "koreanName" : koreanName,
            "originName" : originName ?? "",
            "country" : country ?? "",
            "region1" : region1 ?? "",
            "region2" : region2 ?? "",
            "price" : price ?? 0,
        ]
    }
    
}
