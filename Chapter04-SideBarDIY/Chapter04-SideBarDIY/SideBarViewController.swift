//
//  SideBarViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Park Jae Han on 01/08/2019.
//

import UIKit

class SideBarViewController: UITableViewController {
    
    let titles = [
        "Menu 01",
        "Menu 02",
        "Menu 03",
        "Menu 04",
        "Menu 05"]
    
    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 계정영역
        let accountLabel = UILabel()
        accountLabel.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 30)
        accountLabel.text = "account@email.com"
        accountLabel.textColor = UIColor.white
        accountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        v.backgroundColor = UIColor.blue
        v.addSubview(accountLabel)
        
        // 생성한 뷰를 테이블뷰 헤더영역에 등록
        self.tableView.tableHeaderView = v
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id = "menucell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)

        return cell
    }
}
