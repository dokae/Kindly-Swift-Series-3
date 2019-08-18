//
//  TutorialContentsVC.swift
//  MyMemory
//
//  Created by Park Jae Han on 06/08/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import Foundation

class TutorialContentsVC: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bgImageView: UIImageView!
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        self.titleLabel.text = self.titleText
        self.titleLabel.sizeToFit()
        
        self.bgImageView.image = UIImage(named: self.imageFile)
    }
}
