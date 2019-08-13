//
//  ViewController.swift
//  Chapter03-CSStepper
//
//  Created by Park Jae Han on 31/07/2019.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let stepper = CSStepper()
        stepper.frame = CGRect(x: 30, y: 100, width: 130, height: 30)
        stepper.addTarget(self, action: #selector(logging(_:)), for: .valueChanged)
        self.view.addSubview(stepper)
        stepper.bgColor = UIColor.brown
        stepper.stepValue = 8
        stepper.rightTitle = "1"
        stepper.minimumValue = -20
    }
    
    @objc func logging(_ sender: CSStepper) {
        print("stepper value is: \(sender.value)")
    }


}

