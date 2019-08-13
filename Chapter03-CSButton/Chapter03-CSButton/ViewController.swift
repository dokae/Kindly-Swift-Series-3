//
//  ViewController.swift
//  Chapter03-CSButton
//
//  Created by Park Jae Han on 30/07/2019.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let frame = CGRect(x: 30, y: 50, width: 150, height: 30)
        let csBtn = CSButton(frame: frame)
        self.view.addSubview(csBtn)
        
        let csBtn2 = CSButton()
        csBtn2.frame = CGRect(x: 30, y: 300, width: 150, height: 30)
        self.view.addSubview(csBtn2)
        
        let rectBtn = CSButton(type: .rect)
        rectBtn.frame = CGRect(x: 30, y: 200, width: 150, height: 30)
        self.view.addSubview(rectBtn)
        
        let circleBtn = CSButton(type: .circle)
        circleBtn.frame = CGRect(x: 200, y: 200, width: 150, height: 30)
        self.view.addSubview(circleBtn)
        circleBtn.style = .rect
    }


}

