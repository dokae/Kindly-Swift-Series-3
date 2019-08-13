//
//  ViewController.swift
//  Chapter02-InputForm
//
//  Created by Park Jae Han on 28/07/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 입력용 컨트롤
    var paramEmail: UITextField!
    var paramUpdate: UISwitch!
    var paramInterval: UIStepper!
    
    // 출력용 레이블
    var txtUpdate: UILabel!
    var txtInterval: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // 폰트 실제이름 찾기
        for family in UIFont.familyNames {
            print("\(family)")
            
            for names in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        } */
 
        
        // 내비바 타이틀
        self.navigationItem.title = "Settings"
        
        // 이메일 레이블
        let lblEmail = UILabel()
        lblEmail.frame = CGRect(x: 30, y: 100, width: 100, height: 30)
        lblEmail.text = "Email"
        lblEmail.font = UIFont(name: "SDMiSaeng", size: 14) // 커스텀폰트 적용
        self.view.addSubview(lblEmail)
        
        // 자동갱신 레이블
        let lblUpdate = UILabel()
        lblUpdate.frame = CGRect(x: lblEmail.frame.origin.x, y: 150, width: 100, height: 30)
        lblUpdate.text = "Auto Update"
        lblUpdate.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(lblUpdate)
        
        // 갱신주기 레이블
        let lblInterval = UILabel()
        lblInterval.frame = CGRect(x: lblEmail.frame.origin.x, y: 200, width: 100, height: 30)
        lblInterval.text = "Update Interval"
        lblInterval.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(lblInterval)
        
        // 텍스트필드
        self.paramEmail = UITextField()
        self.paramEmail.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        self.paramEmail.font = UIFont.systemFont(ofSize: 13)
        self.paramEmail.borderStyle = .roundedRect
        self.paramEmail.autocapitalizationType = .none
        self.view.addSubview(self.paramEmail)

        // 스위치
        self.paramUpdate = UISwitch()
        self.paramUpdate.frame = CGRect(x: self.paramEmail.frame.origin.x, y: 150, width: 50, height: 30)
        self.paramUpdate.setOn(true, animated: true)
        self.view.addSubview(self.paramUpdate)
        
        // 스테퍼
        self.paramInterval = UIStepper()
        self.paramInterval.frame = CGRect(x: self.paramEmail.frame.origin.x, y: 200, width: 50, height: 30)
        self.paramInterval.minimumValue = 0
        self.paramInterval.maximumValue = 100
        self.paramInterval.stepValue = 1
        self.paramInterval.value = 0
        self.view.addSubview(self.paramInterval)
        
        // 스위치 표시 레이블
        self.txtUpdate = UILabel()
        self.txtUpdate.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        self.txtUpdate.font = UIFont.systemFont(ofSize: 12)
        self.txtUpdate.textColor = UIColor.red
        self.txtUpdate.text = "갱신함"
        self.view.addSubview(self.txtUpdate)
        
        // 스페터 표시 레이블
        self.txtInterval = UILabel()
        self.txtInterval.frame = CGRect(x: self.txtUpdate.frame.origin.x, y: 200, width: 100, height: 30)
        self.txtInterval.font = UIFont.systemFont(ofSize: 12)
        self.txtInterval.textColor = UIColor.red
        self.txtInterval.text = "0분마다"
        self.view.addSubview(self.txtInterval)
        
        // 이벤트와 메소드 연결
        self.paramUpdate.addTarget(self, action: #selector(presentUpdateValue(_:)), for: .valueChanged)
        self.paramInterval.addTarget(self, action: #selector(presentIntervalValue(_:)), for: .valueChanged)
        
        // 네비바 버튼에 메소드 연결
        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(submit(_:)))
        self.navigationItem.rightBarButtonItem = submitBtn
    }
    
    // 스위치 인터랙션
    @objc func presentUpdateValue(_ sender: UISwitch) {
        self.txtUpdate.text = sender.isOn == true ? "갱신함" : "갱신안함"
    }

    // 스테퍼 인터랙션
    @objc func presentIntervalValue(_ sender: UIStepper) {
        self.txtInterval.text = ("\(Int(sender.value))분 마다")
    }
    
    // 네비바 버튼
    @objc func submit(_ sender: Any) {
        let rvc = ReadViewController()
        rvc.pEmail = self.paramEmail.text
        rvc.pUpdate = self.paramUpdate.isOn
        rvc.pInterval = self.paramInterval.value

        self.navigationController?.pushViewController(rvc, animated: true)
    }

}

