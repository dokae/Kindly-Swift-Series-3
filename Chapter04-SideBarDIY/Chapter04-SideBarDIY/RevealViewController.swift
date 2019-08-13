//
//  RevealViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Park Jae Han on 01/08/2019.
//

import UIKit

class RevealViewController: UIViewController {

    var contentVC: UIViewController?
    var sideVC: UIViewController?
    var isSideBarShowing = false
    let SLIDE_TIME = 0.3
    let SIDEBAR_WIDTH: CGFloat = 260
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    // 초기 화면
    func setupView() {
        // 1. _프론트컨트롤러 객체를 읽어옴
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_front") as? UINavigationController {
            // 2. 읽어온 컨트롤러를 클래스 전체에서 참조할 수 있도록 contentVC 속성에 저장
            self.contentVC = vc
            // 3. _프론트컨트롤러 객체를 메인 컨트롤러의 자식으로 등록
            self.addChild(vc)   // _프론트컨트롤러를 메인 컨트롤러의 자식 뷰컨트롤러로 등록
            self.view.addSubview(vc.view)   // _프론트컨트롤러의 뷰를 메인 컨트롤러의 서브뷰로 등록
            vc.didMove(toParent: self)      // _프론트컨트롤러에 부모 뷰 컨트롤러가 바뀌었음을 알려줌
            // 4. 프론트컨트롤러의 델리게이트변수에 참조정보를 넣어줌
            let frontVC = vc.viewControllers[0] as? FrontViewController
            frontVC?.delegate = self
        }
    }
    
    // 사이드바뷰를 읽어옴
    func getSideView() {
        if self.sideVC == nil {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_rear") {
                self.sideVC = vc
                self.addChild(vc)
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
                self.view.bringSubviewToFront((self.contentVC?.view)!) // _프론트뷰를 맨앞으로 올림
            }
        }
    }
    
    //  콘텐츠뷰에 그림자효과
    func setShadowEffect(shadow: Bool, offset: CGFloat) {
        if shadow == true {
            self.contentVC?.view.layer.cornerRadius = 10
            self.contentVC?.view.layer.shadowOpacity = 0.8
            self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor
            self.contentVC?.view.layer.shadowOffset = CGSize(width: offset, height: offset)
        
        } else {
            self.contentVC?.view.layer.cornerRadius = 0.0
            self.contentVC?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    
    // 사이드바를 오픈
    func openSideBar(_ complete:(() -> Void)?) {
        self.getSideView()
        self.setShadowEffect(shadow: true, offset: -2)
        // 애니메이션 옵션
        let options = UIView.AnimationOptions(arrayLiteral: [.curveEaseInOut, .beginFromCurrentState])
        UIView.animate(
            withDuration: TimeInterval(self.SLIDE_TIME),
            delay: TimeInterval(0),
            options: options,
            animations: {
                self.contentVC?.view.frame = CGRect(x: self.SIDEBAR_WIDTH, y: 0, width: self.view.frame.width, height: self.view.frame.height)},
            completion: {
                if $0 == true {
                    self.isSideBarShowing = true
                    complete?()
                }})
    }
    
    // 사이드바 클로즈
    func closeSideBar(_ complete:(() -> Void)?) {
        let options = UIView.AnimationOptions(arrayLiteral: [.curveEaseInOut, .beginFromCurrentState])
        UIView.animate(
            withDuration: TimeInterval(self.SLIDE_TIME),
            delay: TimeInterval(0),
            options: options,
            animations: {
                self.contentVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)},
            completion: {
                if $0 == true {
                    self.sideVC?.view.removeFromSuperview()
                    self.sideVC = nil
                    self.isSideBarShowing = false
                    self.setShadowEffect(shadow: false, offset: 0)
                    complete?()
                }})
    }
    

}
