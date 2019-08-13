//
//  ControlViewController.swift
//  Chapter03-Alert
//
//  Created by Park Jae Han on 30/07/2019.
//

import UIKit

class ControlViewController: UIViewController {

    private let slider = UISlider()
    // 슬라이더 값을 읽어올 연산 프로퍼티
    var sliderValue: Float {
        return self.slider.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 슬라이더 정의
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        self.slider.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(slider)
        self.preferredContentSize = CGSize(width: self.slider.frame.width, height: self.slider.frame.height + 10)
    }
    


}
