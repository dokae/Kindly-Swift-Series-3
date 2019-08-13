//
//  DepartmentDAO.swift
//  Chapter06-HR
//
//  Created by Park Jae Han on 08/08/2019.
//

import Foundation

class DepartmentDAO {
    // 부서 정보를 담을 튜플 타입 정의
    typealias DepartRecord = (Int, String, String)
    
    // SQLite 연결 및 초기화
    lazy var fmdb: FMDatabase! = {
        // 1 파일매니저 생성
        let fileMgr = FileManager.default
        
        // 2 샌드박스내 문서디렉토리에서 파일 경로 확인
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        // 3 샌드박스에 파일없으면 메인번들에서 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        // 4 준비된 db파일로 fmdatabase 객체 생성
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open()
    }
    
    deinit {
        self.fmdb.close()
    }
    
    // MARK:- 부서목록 읽어오기
    func find() -> [DepartRecord] {
        var departList = [DepartRecord]()
        
        do {
            let sql = """
                SELECT depart_cd, depart_title, depart_addr
                FROM department
                ORDER BY depart_cd ASC
            """
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            // 결과 집합 추출
            while rs.next() {
                let departCd = rs.int(forColumn: "depart_cd") // Int32타입 반환
                let departTitle = rs.string(forColumn: "depart_title")
                let departAddr = rs.string(forColumn: "depart_addr")
                departList.append((Int(departCd), departTitle!, departAddr!))
            }
        }  catch let error as NSError {
            print("failded:\(error.localizedDescription)")
        }
        
        return departList
    }
    
    // MARK:- 단일 부서정보 읽기
    func get(departCd: Int) -> DepartRecord? {
        let sql = """
            SELECT depart_cd, depart_title, depart_addr
            FROM department
            WHERE depart_cd = ?
        """
        
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [departCd])
        if let _rs = rs {
            _rs.next()
            let departCd = _rs.int(forColumn: "depart_cd")
            let departTitle = _rs.string(forColumn: "depart_title")
            let departAddr = _rs.string(forColumn: "depart_addr")
            return (Int(departCd), departTitle!, departAddr!)
        } else {
            return nil
        }
    }
    
    // MARK:- 부서 추가
    func create(title: String!, addr: String!) -> Bool {
        do {
            let sql = """
                INSERT INTO department (depart_title, depart_addr)
                VALUES ( ?, ? )
            """
            try self.fmdb.executeUpdate(sql, values: [title, addr])
            return true
        
        } catch let error as NSError {
            print("Insert Error:\(error.localizedDescription)")
            return false
        }
    }
    
    // MARK:- 부서 삭제
    func remove(departCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM department WHERE depart_cd= ?"
            try self.fmdb.executeUpdate(sql, values: [departCd])
            return true
        
        } catch let error as NSError {
            print("delete error: \(error.localizedDescription)")
            return false
        }
    }
    

    
}



