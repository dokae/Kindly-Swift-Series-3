//
//  CSTabBarController.swift
//  Chapter03-CSTabBar
//
//  Created by Park Jae Han on 31/07/2019.
//

import UIKit

class CSTabBarController: UITabBarController {
    
    let csView = UIView()
    let tabItem01 = UIButton(type: .system)
    let tabItem02 = UIButton(type: .system)
    let tabItem03 = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        // 기존 탭바 숨기기
        self.tabBar.isHidden = true
        
        // 커스텀 탭바 만들기
        let width = self.view.frame.width
        let height: CGFloat = 50
        let x: CGFloat = 0
        let y = self.view.frame.height - height
        self.csView.frame = CGRect(x: x, y: y, width: width, height: height)
        self.csView.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.csView)
        
        // 탭바 아이템
        let tabBtnWidth = self.csView.frame.size.width / 3
        let tabBtnHeight = self.csView.frame.size.height
        
        self.tabItem01.frame = CGRect(x: 0, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem02.frame = CGRect(x: tabBtnWidth, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem03.frame = CGRect(x: tabBtnWidth * 2, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        
        self.addTabBarBtn(btn: self.tabItem01, title: "1st Btn", tag: 0)
        self.addTabBarBtn(btn: self.tabItem02, title: "2nd Btn", tag: 1)
        self.addTabBarBtn(btn: self.tabItem03, title: "3rd Btn", tag: 2)
        
        self.onTabBarItemClick(self.tabItem01)
    }
    
    // 버튼 속성 만들기
    func addTabBarBtn(btn: UIButton, title: String, tag: Int) {
        btn.setTitle(title, for: .normal)
        btn.tag = tag
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.yellow, for: .selected)
        btn.addTarget(self, action: #selector(onTabBarItemClick(_:)), for: .touchUpInside)
        self.csView.addSubview(btn)
    }
    
    // 버튼 클릭시 호출
    @objc func onTabBarItemClick(_ sender: UIButton) {
        self.tabItem01.isSelected = false
        self.tabItem02.isSelected = false
        self.tabItem03.isSelected = false
        sender.isSelected = true
        
        self.selectedIndex = sender.tag
    }



}
