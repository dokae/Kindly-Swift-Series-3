//
//  DepartPickerVC.swift
//  Chapter06-HR
//
//  Created by Park Jae Han on 08/08/2019.
//

import UIKit

class DepartPickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let departDAO = DepartmentDAO()
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]!
    var pickerView: UIPickerView!
    
    // 선택된 부서코드 로드
    var selectedDepartCd: Int {
        let row = self.pickerView.selectedRow(inComponent: 0)
        return self.departList[row].departCd
    }
    
    override func viewDidLoad() {
        self.departList = self.departDAO.find()
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.view.addSubview(self.pickerView)
        
        let pWidth = self.pickerView.frame.width
        let pHeight = self.pickerView.frame.height
        self.preferredContentSize = CGSize(width: pWidth, height: pHeight)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.departList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var titleView = view as? UILabel
        if titleView == nil {
            titleView = UILabel()
            titleView?.font = UIFont.systemFont(ofSize: 14)
            titleView?.textAlignment = .center
        }
        titleView?.text = "\(self.departList[row].departTitle)(\(self.departList[row].departAddr))"
        
        return titleView!
    }
    
    
}
