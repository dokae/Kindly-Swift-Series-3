//
//  UserInfoManager.swift
//  MyMemory
//
//  Created by Park Jae Han on 05/08/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit
import Alamofire

// 저장에 사용할 키
struct UserInfoKey {
    static let loginId = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
    static let tutorial = "TUTORIAL"
}

// 계정&사용자정보를 저장, 관리하는 클래스
class UserInfoManager {
    
    var loginid: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginId)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.loginId)
            ud.synchronize()
        }
    }
    
    var account: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.account)
            ud.synchronize()
        }
    }
    
    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    
    var profile: UIImage? {
        get {
            let ud = UserDefaults.standard
            if let _profile = ud.data(forKey: UserInfoKey.profile) {
                return UIImage(data: _profile)
            } else {
                return UIImage(named: "account.jpg")
            }
        }
        set(v) {
            if v != nil {
                let ud = UserDefaults.standard
                ud.set(v!.pngData(), forKey: UserInfoKey.profile)
                ud.synchronize()
                
            }
        }
    }
    
    var isLogin: Bool {
        //로긴아이디가 0이거나 계정이 nil이면
        if self.loginid == 0 || self.account == nil {
            return false
        } else {
            return true
        }
    }

    
    func login(account: String, passwd: String, success: (() -> Void)? = nil, fail: ((String) -> Void)? = nil) {
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/login"
        let param: Parameters = ["account" : account, "passwd" : passwd]
        
        let call = Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
        
        call.responseJSON(){ res in
            guard let jsonObject = res.result.value as? NSDictionary else {
                fail?("잘못된 응답형식입니다 :\(res.result.value!)")
                return
            }
            
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                let user = jsonObject["user_info"] as! NSDictionary
                self.loginid = user["user_id"] as! Int
                self.account = user["account"] as? String
                self.name = user["name"] as? String
                
                if let path = user["profile_path"] as? String {
                    if let imageData = try? Data(contentsOf: URL(string: path)!) {
                        self.profile = UIImage(data: imageData)
                    }
                }
                let accessToken = jsonObject["access_token"] as! String
                let refreshToken = jsonObject["refresh_token"] as! String
                
                let tk = TokenUtils()
                tk.save("kr.co.rubypaper.MyMemory", account: "accessToken", value: accessToken)
                tk.save("kr.co.rubypaper.MyMemory", account: "refreshToken", value: refreshToken)
                
                success?()
                
            } else {
                let msg = (jsonObject["error_msg"] as? String) ?? "로그인이 실패했습니다."
                fail?(msg)
            }
        }
        
    }
    
    func localLogout() {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        
        let tokenUtils = TokenUtils()
        tokenUtils.delete("kr.co.rubypaper.MyMemory", account: "refreshToken")
        tokenUtils.delete("kr.co.rubypaper.MyMemory", account: "accessToken")
    }
    
    func logout(completion: (() -> Void)? = nil) {
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/logout"
        let tokenUtils = TokenUtils()
        let header = tokenUtils.getAuthorizationHeader()
        let call = Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        call.responseJSON(){ _ in
            self.localLogout()
            completion?()
        }
    }
    
    func newProfile(_ profile: UIImage?, success: (() -> Void)? = nil, fail: ((String) -> Void)? = nil) {
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/profile"
        let tk = TokenUtils()
        let header = tk.getAuthorizationHeader()
        
        let profileData = profile!.pngData()?.base64EncodedString()
        let param: Parameters = ["profile_image" : profileData!]
        
        let call = Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header)
        call.responseJSON(){ res in
            guard let jsonObject = res.result.value as? NSDictionary else {
                fail?("올바른 응답이 아닙니다")
                return
            }
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                self.profile = profile
                success?()
            } else {
                let msg = (jsonObject["error_msg"] as? String) ?? "이미지 프로필 변경 실패"
                fail?(msg)
            }
        }
    }
}
