//
//  DepartmentListVC.swift
//  Chapter06-HR
//
//  Created by Park Jae Han on 08/08/2019.
//

import UIKit

class DepartmentListVC: UITableViewController {
    
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]! // 데이터소스용 멤버 변수
    let departDAO = DepartmentDAO() // SQL처리 객체
    
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "부서 목록\n" + "총\(self.departList.count)개"
        
        self.navigationItem.titleView = navTitle
        self.navigationItem.leftBarButtonItem = self.editButtonItem // 편집버튼 추가
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.departList = self.departDAO.find() // 저장정보 로드
        self.initUI()
    }
   
    // 부서등록 버튼
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "신규 부서 등록", message: "부서를 등록해주세요", preferredStyle: .alert)
        alert.addTextField(){ (tf) in tf.placeholder = "부서명" }
        alert.addTextField(){ (tf) in tf.placeholder = "주소" }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default){ (_) in
            
            // 부서등록 로직
            let title = alert.textFields?[0].text
            let addr = alert.textFields?[1].text
            
            if self.departDAO.create(title: title!, addr: addr!) {
                // 등록되면 DB리로드 후 테이블 갱신
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
                
                // 내비타이틀 갱신
                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "부서 목록\n" + "총 \(self.departList.count)개"
            }
        })
        self.present(alert, animated: false)
    }

    // MARK:- 테이블뷰
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.departList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        cell?.textLabel?.text = rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell?.detailTextLabel?.text = rowData.departAddr
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let departCd = self.departList[indexPath.row].departCd

        // DB, 데이터소스, 테이블뷰에서 차례로 삭제
        if departDAO.remove(departCd: departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let departCd = self.departList[indexPath.row].departCd
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "DEPART_INFO")
        if let _infoVC = infoVC as? DepartmentInfoVC {
            _infoVC.departCd = departCd
            self.navigationController?.pushViewController(_infoVC, animated: true)
        }
    }
}
