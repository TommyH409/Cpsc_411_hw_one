//
//  Database.swift
//  HwOne
//
//  Created by Tommy Huynh on 10/25/20.
//

import SQLite3
import Foundation

class Database {
    //Database Wrapper
    static var dbObj : Database!
    let dbName = "/Users/Haya/Documents/Fall 2020/HwOne/claimDb.sqlite"
    var conn : OpaquePointer?
    init() {
        //1. create db
        //2. create tables
        if sqlite3_open(dbName,&conn) == SQLITE_OK{
            initializeDB()
            sqlite3_close(conn)
        }
        else {
            let errcode = sqlite3_errcode(conn)
            print("Create Table Failed due to error \(errcode)")
        }
    }

    private func initializeDB(){
        let sqlStmt = "create table if not exists claim (id text, title text, date text, isSolved text)"
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let eCode = sqlite3_errcode(conn)
            print("Create Table failed due to error \(eCode)")
        }
    }
    
    func getDBconnection() -> OpaquePointer? {
        var conn : OpaquePointer?
        if sqlite3_open(dbName, &conn) == SQLITE_OK {
            return conn
        }
        else {
            let errcode = sqlite3_errcode(conn)
            let errmsg = sqlite3_errmsg(conn)
            print("Open Database failed \(errcode)")
            print("Open Database failed \(errmsg)")
            let _ = String(format:"%@", errmsg!)

        }
        return conn
    }
    
    static func getInstance() -> Database {
        if dbObj == nil {
            dbObj = Database()
        }
        return dbObj
    }
}
