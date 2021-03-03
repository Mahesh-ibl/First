//
//  Hero.swift
//  First
//
//  Created by IBL INFOTECH on 03/03/21.
//  Copyright © 2021 IBL INFOTECH. All rights reserved.
//

import Foundation

struct Hero {

    var id: Int
    var name: String
    var powerRanking: Int
 
    init(id: Int, name: String, powerRanking: Int){
        self.id = id
        self.name = name
        self.powerRanking = powerRanking
    }
}
