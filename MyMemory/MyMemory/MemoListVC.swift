//
//  MemoListVC.swift
//  MyMemory
//
//  Created by Park Jae Han on 28/07/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit

class MemoListVC: UITableViewController, UISearchBarDelegate {
    
    lazy var dao = MemoDAO()
    @IBOutlet var searchBar: UISearchBar!
    
    // 앱델리게이트 객체의 참조 정보
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfoKey.tutorial) == false {
            let vc = self.instanceTutorialVC(name: "MasterVC")
            self.present(vc!, animated: true, completion: nil)
            
            return
        }
        // 코어 데이터 저장데이터 로드
        self.appDelegate.memolist = self.dao.fetch()
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        // 검색바의 키보드 리턴키 항상 활성화
        searchBar.enablesReturnKeyAutomatically = false

        // SWRevealViewController라이브러리의 revealViewController 객체를 읽어옴
        if let revealVC = self.revealViewController() {
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:))
            self.navigationItem.leftBarButtonItem = btn
            
            // 제스쳐 등록
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        
        
    }
    
    //MARK:- 테이블뷰 델리게이트
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.memolist.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.appDelegate.memolist[indexPath.row]
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // memolist에서 값 꺼냄
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 상세화면 인스턴스 생성
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        // 값 전달후 이동
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.memolist[indexPath.row]
        
        if dao.delete(data.objectID!) {
            self.appDelegate.memolist.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        self.appDelegate.memolist = self.dao.fetch(keyword: keyword)
        self.tableView.reloadData()
    }
}
