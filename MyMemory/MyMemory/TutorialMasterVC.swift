//
//  TutorialMasterVC.swift
//  MyMemory
//
//  Created by Park Jae Han on 06/08/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import Foundation

class TutorialMasterVC: UIViewController {
    
    var pageVC: UIPageViewController!
    
    // 컨텐츠뷰컨에 들어갈 타이틀, 이미지
    var contentTitles = ["STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    var contentImages = ["Page0", "Page1", "Page2", "Page3"]
    
    @IBAction func close(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial)
        ud.synchronize()
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    // 컨텐츠뷰컨 생성
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        guard self.contentTitles.count >= idx && self.contentTitles.count > 0 else {
            return nil
        }
        guard let cvc = self.instanceTutorialVC(name: "ContentsVC") as? TutorialContentsVC else {
            return nil
        }
        cvc.titleText = self.contentTitles[idx]
        cvc.imageFile = self.contentImages[idx]
        cvc.pageIndex = idx
        return cvc
    }
    
    
    override func viewDidLoad() {
        // 페이지뷰컨 객체 생성
        self.pageVC = self.instanceTutorialVC(name: "PageVC") as! UIPageViewController
        self.pageVC.dataSource = self
        // 기본페이지 지정
        let startContentVC = self.getContentVC(atIndex: 0)!
        self.pageVC.setViewControllers([startContentVC], direction: .forward, animated: true, completion: nil)
        // 출력영역 지정
        self.pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 50
        // 마스터뷰의 자식컨으로 지정
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self)
    }
}

extension TutorialMasterVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! TutorialContentsVC).pageIndex else {
            return nil
        }
        guard index > 0 else {
            return nil
        }
        index -= 1
        return self.getContentVC(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! TutorialContentsVC).pageIndex else {
            return nil
        }
        index += 1
        guard index < self.contentTitles.count else {
            return nil
        }
        return self.getContentVC(atIndex: index)
    }
    
    // 페이지 인디케이터
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contentTitles.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
