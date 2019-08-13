//
//  DepartmentInfoVC.swift
//  Chapter06-HR
//
//  Created by Park Jae Han on 09/08/2019.
//

import UIKit

class DepartmentInfoVC: UITableViewController {
    
    typealias DepartRecord = (departCd: Int, departTitle: String, departAddr: String)
    var departCd: Int!
    let departDAO = DepartmentDAO()
    let empDAO = EmployeeDAO()
    var departInfo: DepartRecord!
    var empList: [EmployeeVO]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.departInfo = self.departDAO.get(departCd: self.departCd)
        self.empList = self.empDAO.find(departCd: self.departCd)
        self.navigationItem.title = "\(self.departInfo.departTitle)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textHeader = UILabel(frame: CGRect(x: 35, y: 5, width: 200, height: 30))
        textHeader.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        textHeader.textColor = UIColor(red: 0.03, green: 0.28, blue: 0.71, alpha: 1.0)
        
        let icon = UIImageView()
        icon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        if section == 0 {
            textHeader.text = "부서 정보"
            icon.image = UIImage(imageLiteralResourceName: "depart")
        } else {
            textHeader.text = "소속 사원"
            icon.image = UIImage(imageLiteralResourceName: "employee")
        }
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        v.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.0)
        v.addSubview(textHeader)
        v.addSubview(icon)
        
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return self.empList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "부서 코드"
                cell?.detailTextLabel?.text = "\(self.departInfo.departCd)"
            case 1:
                cell?.textLabel?.text = "부서명"
                cell?.detailTextLabel?.text = "\(self.departInfo.departTitle)"
            case 2:
                cell?.textLabel?.text = "부서 주소"
                cell?.detailTextLabel?.text = "\(self.departInfo.departAddr)"
            default:
                ()
            }
            return cell!
        
        } else {
            let row = self.empList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
            cell?.textLabel?.text = "\(row.empName) (입사일:\(row.joinDate))"
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
            
            let state = UISegmentedControl(items: ["재직중", "휴직", "퇴사"])
            state.frame.origin.x = self.view.frame.width - state.frame.width - 10
            state.frame.origin.y = 10
            state.selectedSegmentIndex = row.stateCd.rawValue
            
            state.tag = row.empCd
            state.addTarget(self, action: #selector(self.changeState(_:)), for: .valueChanged)
            cell?.contentView.addSubview(state)
            
            return cell!
        }
    }
    
    @objc func changeState(_ sender: UISegmentedControl) {
        let empCd = sender.tag
        let stateCd = EmpStateType(rawValue: sender.selectedSegmentIndex)
        
        if self.empDAO.editState(empCd: empCd, stateCd: stateCd!) {
            let alert = UIAlertController(title: nil, message: "재직상태 변경", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
