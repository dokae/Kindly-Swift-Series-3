//
//  FrontViewController.swift
//  Chapter04-SideBar
//
//  Created by Park Jae Han on 31/07/2019.
//

import UIKit

class FrontViewController: UIViewController {

    @IBOutlet var sideBarButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // 메인 컨트롤러의 참조정보
        if let revealVC = self.revealViewController() {
            self.sideBarButton.target = revealVC
            self.sideBarButton.action = #selector(revealVC.revealToggle(_:)) // 버튼 클릭시 revealToggle 호출
            
            // 제스쳐를 뷰에 추가
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
        

    }
    


}
