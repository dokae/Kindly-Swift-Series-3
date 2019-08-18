//
//  CSLogButton.swift
//  MyMemory
//
//  Created by Park Jae Han on 31/07/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit

public enum CSLogType: Int {
    case basic
    case title
    case tag
}

public class CSLogButton: UIButton {

    public var logType: CSLogType = .basic
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setBackgroundImage(UIImage(named: "button-bg"), for: .normal)
        self.tintColor = UIColor.white
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    
    @objc func logging(_ sender: UIButton) {
        switch self.logType {
        case .basic:
            NSLog("Button Clicked(BASIC)")
        case .title:
            let btnTitle = sender.titleLabel?.text ?? "no title"
            NSLog("\(btnTitle) Clicked(TITLE)")
        case .tag:
            NSLog("\(sender.tag) Clicked(TAG)")
        }
    }
}
