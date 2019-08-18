//
//  ProfileVC.swift
//  MyMemory
//
//  Created by Park Jae Han on 02/08/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit
import Alamofire
import LocalAuthentication

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let uinfo = UserInfoManager()
    let profileImage = UIImageView()
    let tv = UITableView()
    var isCalling = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationController?.navigationBar.isHidden = true
        
        // 프로필 이미지
        let image = self.uinfo.profile
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 130)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        self.view.addSubview(self.profileImage)
        
        // 테이블뷰
        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height: 100)
        self.tv.dataSource = self
        self.tv.delegate = self
        self.view.addSubview(self.tv)
        
        // BG이미지
        let bg = UIImage(named: "profile-bg.png")
        let bgImg = UIImageView(image: bg)
        
        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: -100)
        bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
        bgImg.layer.borderWidth = 0
        bgImg.layer.masksToBounds = true
        self.view.addSubview(bgImg)
        
        self.view.bringSubviewToFront(self.tv)
        self.view.bringSubviewToFront(self.profileImage)
        
        self.drawBtn()
        
        // 제스쳐등록
        let tap = UITapGestureRecognizer(target: self, action: #selector(profile(_:)))
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.isUserInteractionEnabled = true
        
        let tk = TokenUtils()
        if let accessToken = tk.load("kr.co.rubypaper.MyMemory", account: "accessToken") {
            print("accessToken=\(accessToken)")
        } else {
            print("accessToken is nil")
        }
        if let refreshToken = tk.load("kr.co.rubypaper.MyMemory", account: "refreshToken") {
            print("refreshToken=\(refreshToken)")
        } else {
            print("refreshToken is nil")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = self.uinfo.name ?? "Login First"
            
        case 1:
            cell.textLabel?.text = "Account"
            cell.detailTextLabel?.text = self.uinfo.account ?? "Login First"
            
        default:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.uinfo.isLogin == false {
            self.doLogin(self.tv)
        }
    }
    
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func doLogin(_ sender: Any) {
        if self.isCalling == true {
            self.alert("응답을 기다리는 중입니다")
            return
        } else {
            self.isCalling = true
        }
        
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        loginAlert.addTextField() {(tf) in
            tf.placeholder = "Your Account"
        }
        loginAlert.addTextField() {(tf) in
            tf.placeholder = "Password"
            tf.isSecureTextEntry = true
        }
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel){ (_) in
            self.isCalling = false
        })
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive) {(_) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let account = loginAlert.textFields?[0].text ?? ""
            let passwd = loginAlert.textFields?[1].text ?? ""
            
            self.uinfo.login(account: account, passwd: passwd, success: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.isCalling = false
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
                
                let sync = DataSync()
                DispatchQueue.global(qos: .background).async {
                    sync.downloadBackupData()
                }
                DispatchQueue.global(qos: .background).async {
                    sync.uploadData()
                }
                
            }, fail: { msg in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.isCalling = false
                self.alert(msg)
            })
        })
        self.present(loginAlert, animated: true)
    }
    
    @objc func doLogout(_ sender: Any) {
        let msg = "Logout Now?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive) {(_) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            self.uinfo.logout() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                // 로그아웃시 처리할 내용
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func drawBtn() {
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        self.view.addSubview(v)
        
        let btn = UIButton(type: .system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2
        btn.center.y = v.frame.size.height / 2
        
        // 로그인일땐 로그아웃 버튼을, 반대일땐 로그인버튼을
        if self.uinfo.isLogin == true {
            btn.setTitle("Logout", for: .normal)
            btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
        } else {
            btn.setTitle("Login", for: .normal)
            btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
        }
        v.addSubview(btn)
    }
    
    func imgPicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @objc func profile(_ sender: UIButton) {
        // 로긴안되있을때 로긴창 띄우며 함수 종료
        guard (self.uinfo.account != nil) else {
            self.doLogin(self)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해 주세요", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default) {(_) in
                self.imgPicker(.camera)
            })
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default) {(_) in
                self.imgPicker(.photoLibrary)
            })
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "Saved Album", style: .default){(_) in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let img = info[.editedImage] as? UIImage {
            self.uinfo.newProfile(img, success: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.profileImage.image = img
         
            }, fail: { msg in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.alert(msg)
            })
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backProfileVC(_ segue: UIStoryboardSegue) {
        
    }
    
}

extension ProfileVC {

    func tokenValidate() {
        URLCache.shared.removeAllCachedResponses()
        
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader() else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/tokenValidate"
        let validate = Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        validate.responseJSON(){ res in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            print(res.result.value!)
            guard let jsonObject = res.result.value as? NSDictionary else {
                self.alert("잘못된 응답입니다")
                return
            }
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode != 0 {
                self.touchID()
            }
        }
    }
    
    func touchID() {
        let context = LAContext()
        var error: NSError?
        let msg = "인증이 필요합니다"
        let deviceAuth = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        if context.canEvaluatePolicy(deviceAuth, error: &error) {
            context.evaluatePolicy(deviceAuth, localizedReason: msg){ (success, e) in
                if success {
                    self.refresh()
                } else {
                    print((e?.localizedDescription)!)
                    switch (e!._code) {
                    case LAError.systemCancel.rawValue:
                        self.alert("시스템에 의해 인증이 취소됨")
                    case LAError.userCancel.rawValue:
                        self.alert("사용자에 의해 인증이 취소됨")
                        self.commonLogout()
                    case LAError.userFallback.rawValue:
                        OperationQueue.main.addOperation {
                            self.commonLogout(true)
                        }
                    default:
                        OperationQueue.main.addOperation {
                            self.commonLogout(true)
                        }
                    }
                }
            }
        } else {
            print(error!.localizedDescription)
            switch (error!.code) {
            case LAError.touchIDNotEnrolled.rawValue:
                print("터치아이디가 등록되어 있지 않습니다")
            case LAError.passcodeNotSet.rawValue:
                print("패스코드 설정 없음")
            default:
                print("터치아이디 사용할수 없음")
            }
            OperationQueue.main.addOperation {
                self.commonLogout(true)
            }
        }
    }
    
    func refresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let tk = TokenUtils()
        let header = tk.getAuthorizationHeader()
        let refreshToken = tk.load("kr.co.rubypaper.MyMemory", account: "refreshToken")
        let param: Parameters = ["refresh_token" : refreshToken!]
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/refresh"
        let refresh = Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header)
        refresh.responseJSON(){ res in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let jsonObject = res.result.value as? NSDictionary else {
                self.alert("잘못된 응답입니다")
                return
            }
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                let accessToken = jsonObject["access_token"] as! String
                tk.save("kr.co.rubypaper.MyMemory", account: "accessToken", value: accessToken)
            } else {
                self.alert("인증이 만료되었으므로 다시 로그인해야 합니다")
                OperationQueue.main.addOperation {
                    self.commonLogout(true)
                }
            }
        }
    }
    
    func commonLogout(_ isLogin: Bool = false) {
        let userInfo = UserInfoManager()
        userInfo.localLogout()
        
        self.tv.reloadData()
        self.profileImage.image = userInfo.profile
        self.drawBtn()
        
        if isLogin {
            self.doLogin(self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tokenValidate()
    }
    
}
