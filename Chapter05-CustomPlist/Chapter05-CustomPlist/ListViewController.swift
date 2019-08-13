//
//  ListViewController.swift
//  Chapter05-CustomPlist
//
//  Created by Park Jae Han on 05/08/2019.
//

import UIKit

class ListViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
    @IBOutlet var account: UITextField!
    var accountlist = [String]()
    var defaultPlist: NSDictionary! // 메인번들plist
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메인번들 userinfo.plist 로드
        if let defaultPListPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defaultPlist = NSDictionary(contentsOfFile: defaultPListPath)
        }
        
        let plist = UserDefaults.standard
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        
        // 피커
        let picker = UIPickerView()
        picker.delegate = self
        self.account.inputView = picker
        
        // 피커 툴바
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolbar.barTintColor = UIColor.lightGray
        self.account.inputAccessoryView = toolbar
        
        // 피커 툴바아이템
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone(_:))
        
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount(_:))
        
        // 스페이스 추가
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([new, flexSpace, done], animated: true)
        
        // 저장소 로드&세팅
        let accountlist = plist.array(forKey: "accountlist") as? [String] ?? [String]()
        self.accountlist = accountlist
        if let account = plist.string(forKey: "selectedAccount") {
            self.account.text = account
            
            // 커스텀plist에서 불러오기
            let customPlist = "\(account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }

        // 계정값이 비었다면 다른항목 비활성화
        if (self.account.text?.isEmpty)! {
            self.account.placeholder = "등록된 계정 없음"
            self.gender.isEnabled = false
            self.married.isEnabled = false
        }
        
        // 내비바 newAccount 버튼
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newAccount(_:)))
        self.navigationItem.rightBarButtonItems = [addBtn]
    }
    
    // 툴바-New
    @objc func newAccount(_ sender: Any) {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "Input New Account", message: nil, preferredStyle: .alert)
        alert.addTextField() {
            $0.placeholder = "newaccount@email.com"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            if let account = alert.textFields?[0].text {
                self.accountlist.append(account)
                self.account.text = account
                
                // 컨트롤 초기화
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                // 계정 목록 저장
                let plist = UserDefaults.standard
                plist.set(self.accountlist, forKey: "accountlist")
                plist.set(account, forKey: "selectedAccount") // 선택한 계정 저장
                plist.synchronize()
                
                // 입력목록 활성화
                self.gender.isEnabled = true
                self.married.isEnabled = true
            }
        })
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
  
        // 커스텀plist 저장 로직 시작
        let customPlist = "\(self.account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        
        // 커스텀plist 저장 로직 시작
        let customPlist = "\(self.account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)
        
        print("custom plist=\(plist)")
    }
    
    // 툴바 - Done
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true)
        
        // 커스텀plist에서 불러오기
        if let _account = self.account.text {
            let customPlist = "\(_account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
    }
    
    // 테이블뷰
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && !(self.account.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: "Input Your Name", preferredStyle: .alert)
            alert.addTextField(){
                $0.text = self.name.text
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                let value = alert.textFields?[0].text
                
                // 커스텀plist 저장 로직 시작
                let customPlist = "\(self.account.text!).plist"
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)
                
                self.name.text = value
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // 피커뷰 컴포넌트 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 피커뷰 목록수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountlist.count
    }
    
    // 피커뷰 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountlist[row]
    }
    
    // 피커row가 선택됐을때
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let account = self.accountlist[row]
        self.account.text = account
        
        // 선택한 계정 저장
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
    }
    
    

    
    
    
    
    
    
 }
