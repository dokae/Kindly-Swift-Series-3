//
//  AppDelegate.swift
//  Chapter03-TabBar
//
//  Created by Park Jae Han on 29/07/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 루트뷰컨트롤러를 UItabBarController로 캐스팅
        if let tbC = self.window?.rootViewController as? UITabBarController {
            // 탭바로부터 탭바 아이템 배열을 가져옴
            if let tbItems = tbC.tabBar.items {
                tbItems[0].title = "Calendar"
                tbItems[1].title = "File"
                tbItems[2].title = "Photo"

                tbItems[0].image = UIImage(named: "designbump")?.withRenderingMode(.alwaysOriginal)
                tbItems[1].image = UIImage(named: "rss")?.withRenderingMode(.alwaysOriginal)
                tbItems[2].image = UIImage(named: "facebook")?.withRenderingMode(.alwaysTemplate)

                // 탭바아이템을 순회하며 selectedImage 속성 설정
                for tbItem in tbItems {
                    let image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysOriginal)
                    tbItem.selectedImage = image
                    
                    /*// 외형 프록시 구문으로 대체
                    tbItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.green], for: .normal)
                    tbItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .selected)
                    tbItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                                                   NSAttributedString.Key.foregroundColor : UIColor.blue], for: .normal) // 폰트와 컬러 동시에 적용해야함
                    */
                }
                
                // 외형 프록시를 이용한 설정
                let tbItemProxy = UITabBarItem.appearance()
                tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.green], for: .normal)
                tbItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .selected)
                
                
                
            }
            
            /*// 외형 프록시 구문으로 대체
            // tbC.tabBar.tintColor = UIColor.white    // 활성화된 탭바 아이템 색상 변경
            // tbC.tabBar.backgroundImage = UIImage(named: "homes_119.png")
            // tbC.tabBar.clipsToBounds = true // 클리핑
            // tbC.tabBar.backgroundImage = UIImage(named: "connectivity-bar")?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 16) // 스트레쳐블이미지
            // tbC.tabBar.barTintColor = UIColor.black
            // tbC.tabBar.barTintColor = UIColor(patternImage: UIImage(named: "homes_119.png")!)
            */
            
            // 외형 프록시를 이용한 설정
            let tbProxy = UITabBar.appearance()
            tbProxy.tintColor = UIColor.white   // 활성화된 탭바 아이템 색상 변경
            tbProxy.backgroundImage = UIImage(named: "menubar-bg-mini")
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

