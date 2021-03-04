//
//  ViewController.swift
//  First
//
//  Created by IBL INFOTECH on 03/03/21.
//  Copyright © 2021 IBL INFOTECH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewHero: UITableView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldRank: UITextField!
    var heros = [Hero]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBHelper.shared.createDatabase()
        fetchHeros()
    }
    
    @IBAction func onTapSave(_ sender: Any) {
        
        if !textFieldName.text!.isEmpty && !textFieldRank.text!.isEmpty  {
            DBHelper.shared.insertData(name: textFieldName.text ?? "", powerRank: textFieldRank.text ?? "") { (bSuccess) in
                if bSuccess {
                    textFieldRank.text = ""
                    textFieldName.text = ""
                    fetchHeros()
                    tableViewHero.reloadData()
                } else {
                    print("Error while data inserting")
                }
            }
        }
    }
    
    func fetchHeros(){
        DBHelper.shared.fetchHeros { (resonseHero) in
            self.heros = resonseHero
        }
    }
    
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroRow", for: indexPath) as! HeroRow
        let hero = heros[indexPath.row]
        cell.selectionStyle = .none
        cell.deleteHeroDelgate = self
        cell.textFieldName.text = hero.name
        cell.lblId.text = "\(hero.id)"
        cell.textFieldRank.text = "\(hero.powerRanking)"
        return cell
    }
}

extension ViewController : DeleteHeroDelegate {
  
    func onTapUpdate(cell: HeroRow) {
        let cell  = cell
        let indexOfItem = heros.firstIndex(where: {$0.id == Int(cell.lblId.text ?? "0") ?? 0})
        DBHelper.shared.updateHero(id: heros[indexOfItem ?? 0].id, name: cell.textFieldName.text ?? "", powerRank: Int(cell.textFieldRank.text ?? "") ?? 0) { (bSuccess) in
            if bSuccess {
                cell.textFieldName.endEditing(true)
                cell.textFieldRank.endEditing(true)
                cell.btnUpdate.isEnabled = false
                heros[indexOfItem ?? 0].name = cell.textFieldName.text ?? ""
                tableViewHero.reloadData()
            }
        }
    }
    
    func onTapDeleteHero(cell:HeroRow) {
        let cell  = cell
        let indexOfItem = heros.firstIndex(where: {$0.name == cell.textFieldName.text})
        DBHelper.shared.deleteHero(id: heros[indexOfItem ?? 0 ].id) { (bSuccess) in
            if bSuccess {
                heros.remove(at: indexOfItem ?? 0)
                tableViewHero.reloadData()
            }
        }
    }
    
    
}

