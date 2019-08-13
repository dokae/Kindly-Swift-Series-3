//
//  FrontViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by Park Jae Han on 01/08/2019.
//

import UIKit

class FrontViewController: UIViewController {

    var delegate: RevealViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btnSideBar = UIBarButtonItem(image: UIImage(named: "sidemenu.png"), style: .plain, target: self, action: #selector(moveSide(_:)))
        self.navigationItem.leftBarButtonItem = btnSideBar
        
        // 제스쳐 - 패닝
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(moveSide(_:)))
        dragLeft.edges = UIRectEdge.left
        self.view.addGestureRecognizer(dragLeft)
        
        // 제스처 - 스와이프
        let dragRight = UISwipeGestureRecognizer(target: self, action: #selector(moveSide(_:)))
        dragRight.direction = .left
        self.view.addGestureRecognizer(dragRight)
    }
    
    @objc func moveSide(_ sender: Any) {
        
        if sender is UIScreenEdgePanGestureRecognizer {
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.delegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem {
            if self.delegate?.isSideBarShowing == false {
                self.delegate?.openSideBar(nil)
            } else {
                self.delegate?.closeSideBar(nil)
            }
        }
    }
}
