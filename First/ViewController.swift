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
    
    @IBAction func onTapGet(_ sender: Any) {
       
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
        cell.selectionStyle = .none
        cell.deleteHeroDelgate = self
        let hero = heros[indexPath.row]
        cell.lblId.text = "\(hero.id)"
        cell.lblName.text = hero.name
        return cell
    }
}

extension ViewController : DeleteHeroDelegate {
    
    func onTapDeleteHero(cell:HeroRow) {
        let cell  = cell
        DBHelper.shared.deleteHero(id: Int(cell.lblId.text ?? "") ?? 0) { (bSuccess) in
            if bSuccess {
                let indexOfItem = heros.firstIndex(where: {$0.name == cell.lblName.text})
                heros.remove(at: indexOfItem ?? 0)
                tableViewHero.reloadData()
            }
        }
    }
}

