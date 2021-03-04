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
    @IBOutlet weak var textFieldRank: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var deleteHeroDelgate:DeleteHeroDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnUpdate.isEnabled = false
        textFieldName.addTarget(self, action: #selector(onTextDidChange), for: .editingChanged)
    }
    
    
    
    @IBAction func onTapDelete(_ sender: UIButton) {
        deleteHeroDelgate?.onTapDeleteHero(cell: self)
    }
    
    @IBAction func onTapUpdate(_ sender: UIButton) {
        deleteHeroDelgate?.onTapUpdate(cell: self)
    }
    
    @objc func onTextDidChange() {
        if textFieldName.text != "" {
            btnUpdate.isEnabled = true
        } else {
            btnUpdate.isEnabled = false
        }
    }
}

