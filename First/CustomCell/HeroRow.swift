//
//  HeroRow.swift
//  First
//
//  Created by IBL INFOTECH on 03/03/21.
//  Copyright © 2021 IBL INFOTECH. All rights reserved.
//

import Foundation
import UIKit

class HeroRow: UITableViewCell {
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var deleteHeroDelgate:DeleteHeroDelegate?
    
    @IBAction func onTapDelete(_ sender: Any) {
        deleteHeroDelgate?.onTapDeleteHero(cell: self)
    }
}
