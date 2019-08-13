//
//  ViewController.swift
//  Chapter03-TabBar
//
//  Created by Park Jae Han on 29/07/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭표시 레이블
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        title.text = "First Tab"
        title.textColor = UIColor.orange
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.sizeToFit()   // 내용에 맞게 사이즈 변경
        title.center.x = self.view.frame.width / 2  // frame.width = get only, frame.size.width = get set
        self.view.addSubview(title)
        
        //// 탭바아이템 등록
        //self.tabBarItem.image = "calendar.png"
        //self.tabBarItem.title = "Calendar"
        
    }
    
    // 탭바 터치해서 숨기기
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let taBbar = self.tabBarController?.tabBar
        // taBbar?.isHidden = taBbar?.isHidden == true ? false : true // 탭바 히든 토글
        
        UIView.animate(withDuration: TimeInterval(0.15)) {
            taBbar?.alpha = (taBbar?.alpha == 0) ? 1 : 0
        }
    }

}

