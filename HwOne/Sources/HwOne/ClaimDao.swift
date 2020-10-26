//
//  ClaimDao.swift
//  HwOne
//
//  Created by Tommy Huynh on 10/25/20.
//

import SQLite3
import Foundation

struct Claim :Codable{
    var id : String?
    var title : String?
    var date : String?
    var isSolved : String?
    
    init(cid: String?, ct: String?, cd: String?, iss: String?) {
        id = cid
        title = ct
        date = cd
        isSolved = iss
    }
}

class ClaimDao {
    
    func addClaim (cObj : Claim){
        let sqlStmt = String(format: "insert into claim (id , title, date, isSolved) values ('%@', '%@', '%@', '%@')", (cObj.id)!, (cObj.title)!, (cObj.date)!, (cObj.isSolved)!)
        
        // get database connection
        let conn = Database.getInstance().getDBconnection()
        
        // Submit the insert sql statement
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a claim due to error \(errcode)")
        }
        // closes the connection
        sqlite3_close(conn)
    }
    
    func getAll() -> [Claim] {
        var cList = [Claim]()
        var resultSet : OpaquePointer?   // result set of variable return back from sqlite3
        let sqlStr = "id, title, date, isSolved"
        let conn = Database.getInstance().getDBconnection()
        
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW){
          
                let id_val = sqlite3_column_text(resultSet, 0)
                let cid = String(cString: id_val!)
                
                let title_val = sqlite3_column_text(resultSet, 1)
                let ct = String(cString: title_val!)
                
                let date_val = sqlite3_column_text(resultSet, 2)
                let cd = String(cString: date_val!)
                
                let isSolved_val = sqlite3_column_text(resultSet, 3)
                let iss = String(cString: isSolved_val!)
                
                cList.append(Claim(cid: cid, ct: ct, cd: cd, iss: iss))
            }
        }
        return cList
    }

}
