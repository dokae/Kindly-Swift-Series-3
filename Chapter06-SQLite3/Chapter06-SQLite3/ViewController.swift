//
//  ViewController.swift
//  Chapter06-SQLite3
//
//  Created by Park Jae Han on 07/08/2019.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbPath = self.getDBPath()
        self.dbExecute(dbPath: dbPath)
    }
    
    func dbExecute(dbPath: String) {
        var db: OpaquePointer? = nil // SQLite연결정보를 담을 객체
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            print("db connect fail")
            return
        }
        
        defer {
            print("close db connection")
            sqlite3_close(db)
        }
        
        var stmt: OpaquePointer? = nil // 컴파일된 SQL을 담을 객체
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)" // SQL구문
        guard sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            print("prepare stmt fail")
            return
        }
        
        defer {
            print("finalize stmt")
            sqlite3_finalize(stmt)
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("create table success")
        }
    }
    
    
    func getDBPath() -> String {
        // 문서 디렉토리에서 SQlite DB를 찾는다
        let fileMgr = FileManager()
        let docuPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docuPathURL.appendingPathComponent("db.sqlite").path
        //let dbPath = "/Users/jh/db.sqlite"
        
        // dbPath에 파일이 없다면 앱번들에서 가져와 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        return dbPath
    }
    
    
}
