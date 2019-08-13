//
//  ListViewController.swift
//  Chapter05-UserDefaults
//
//  Created by Park Jae Han on 03/08/2019.
//

import UIKit

class ListViewController: UITableViewController {

    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
    
    // 이름레이블에 액션메소드 적용
    @IBAction func edit(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
        alert.addTextField(){
            $0.text = self.name.text
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
            let value = alert.textFields?[0].text
            let plist = UserDefaults.standard
            plist.setValue(value, forKey: "name")
            plist.synchronize()
            self.name.text = value
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        // UserDefaults에 저장
        let plist = UserDefaults.standard
        plist.set(value, forKey: "gender")
        plist.synchronize()
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        let plist = UserDefaults.standard
        plist.set(value, forKey: "married")
        plist.synchronize()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
//            alert.addTextField() {
//                $0.text = self.name.text
//            }
//            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
//                let value = alert.textFields?[0].text
//                let plist = UserDefaults.standard
//                plist.setValue(value, forKey: "name")
//                plist.synchronize()
//                self.name.text = value
//            })
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    override func viewDidLoad() {
        let plist = UserDefaults.standard
        
        // 값을 꺼내 컨트롤에 설정
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
    }
}
