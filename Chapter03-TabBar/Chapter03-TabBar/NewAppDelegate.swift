//
//  NewAppDelegate.swift
//  Chapter03-TabBar
//
//  Created by Park Jae Han on 29/07/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit

@UIApplicationMain
class NewAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 탭바 컨트롤러 생성
        let tbC = UITabBarController()
        tbC.view.backgroundColor = .white
        
        // 탭바컨트롤러를 루트뷰 컨트롤러로 등록
        self.window?.rootViewController = tbC
        
        // 탭바아이템에 연결될 뷰컨트롤러 객체 생성
        let view01 = ViewController()
        let view02 = SecondViewController()
        let view03 = ThirdViewController()
        
        // 탭바에 등록
        tbC.setViewControllers([view01, view02, view03], animated: true)
        
        // 개별 탭바아이템 속성 지정
        view01.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(named: "calendar"), selectedImage: nil)
        view02.tabBarItem = UITabBarItem(title: "File", image: UIImage(named: "file-tree"), selectedImage: nil)
        view03.tabBarItem = UITabBarItem(title: "Photo", image: UIImage(named: "photo"), selectedImage: nil)
        
        
        return true
    }
    
}
