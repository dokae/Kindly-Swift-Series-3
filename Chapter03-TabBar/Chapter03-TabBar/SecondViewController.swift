//
//  SecondViewController.swift
//  Chapter03-TabBar
//
//  Created by Park Jae Han on 29/07/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 탭표시 레이블
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        title.text = "Second Tab"
        title.textColor = UIColor.orange
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.sizeToFit()   // 내용에 맞게 사이즈 변경
        title.center.x = self.view.frame.width / 2  // frame.width = get only, frame.size.width = get set
        self.view.addSubview(title)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
