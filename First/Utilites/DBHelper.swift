//
//  DBHelper.swift
//  First
//
//  Created by IBL INFOTECH on 03/03/21.
//  Copyright © 2021 IBL INFOTECH. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper {
    
    public static var shared = DBHelper()
    var db:OpaquePointer?
    let createTableQuery = "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)"
    let insertDataQuery = "INSERT INTO Heroes (name, powerrank) VALUES (?,?)"
    let allHero = "SELECT * FROM Heroes"
    let deleteHero = "DELETE FROM Heroes WHERE ID = %@"
    let updateHero = "UPDATE Heroes SET NAME = %@,POWERRANK = %@ WHERE ID = %@"
    
    func createDatabase() {
       let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("HeroesDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
             let errmsg = String(cString: sqlite3_errmsg(db)!)
             print("error creating table: \(errmsg)")
        }
    }
    
    func insertData(name:String,powerRank:String,completion : (Bool) -> Void) {
        
        var stmt: OpaquePointer?
        if sqlite3_prepare(db, insertDataQuery, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            completion(false)
            return
        }
        
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            completion(false)
            return
        }
        
        if sqlite3_bind_int(stmt, 2, (powerRank as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            completion(false)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            completion(false)
            return
        }
         completion(true)
    }
    
    func fetchHeros(completion : ([Hero]) -> Void) {
        var stmt:OpaquePointer?
        var heros = [Hero]()
        if sqlite3_prepare(db, allHero, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing fetching: \(errmsg)")
            return
        }
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let powerrank = sqlite3_column_int(stmt, 2)
            heros.append(Hero(id: Int(id), name: String(describing:name), powerRanking: Int(powerrank)))
        }
        completion(heros)
    }
    
    func deleteHero(id:Int,completion:(Bool) -> Void ) {
        var stmt:OpaquePointer?
        let deleteQuery = String(format: deleteHero, "\(id)")
        if sqlite3_prepare_v2(db, deleteQuery, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
               completion(true)
            } else {
               completion(false)
            }
        }
    }
    
    func updateHero(id:Int,name:String,powerRank:Int,completion:(Bool) -> Void ) {
        var stmt:OpaquePointer?
       // let updateQuery = String(format: updateHero, name,powerRank,id)
        let updateQuery = "UPDATE Heroes SET name = '\(name)',powerrank = '\(powerRank)' WHERE id = \(id);"
        if sqlite3_prepare(db, updateQuery, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
