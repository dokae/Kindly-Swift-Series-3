//
//  ViewController.swift
//  Chapter08-APITest
//
//  Created by Park Jae Han on 14/08/2019.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var currentTIme: UILabel!
    @IBOutlet var userId: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var responseView: UITextView!
    
    // GET
    @IBAction func callCurrentTime(_ sender: Any) {
        do {
            let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")
            let response = try String(contentsOf: url!)
            self.currentTIme.text = response
            self.currentTIme.sizeToFit()
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    // POST
    @IBAction func post(_ sender: Any) {
        // 전송값 준비
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        let param = "userId=\(userId)&name=\(name)"
        let paramData = param.data(using: .utf8)
        
        // URL객체 정의
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")
        
        // URLRequest객체 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // HTTP메시지 헤더 설정
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        // URLSession 객체를 통해 전송, 응답처리 로직
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let e = error {
                NSLog("An error has occurred: \(e.localizedDescription)")
                return
            }
            // 메인스레드에서 비동기로 처리
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디: \(userId!)" + "\n" +
                            "이름: \(name!)" + "\n" +
                            "응답시간: \(timestamp!)" + "\n" +
                        "요청방식: x-www-form-urlencoded" + "\(result!)"
                    }
                } catch let e as NSError {
                    print("An error has occurred while parsing JSONObject: \(e.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    // POST(JSON)
    @IBAction func json(_ sender: Any) {
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        let param = ["userId" : userId, "name" : name]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let e = error {
                NSLog("An error has occurred: \(e.localizedDescription)")
                return
            }
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else { return }
                    
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "ID:\(userId!), NAME:\(name!)\n\(timestamp!), application/json. \(result!)"
                    }
                    
                } catch let e as NSError {
                    print("error has occurred : \(e.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    @IBAction func alamoGet(_ sender: Any) {
        let url = "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime"
        Alamofire.request(url).responseString(){ response in
            print("성공여부:\(response.result.isSuccess)")
            print("결과값 :\(response.result.value!)")
        }
    }
    
    @IBAction func alamoPost(_ sender: Any) {
        let url = "http://swiftapi.rubypaper.co.kr:2029/practice/echo"
        let param: Parameters = ["userId" : "aaa", "name" : "bbb"]
        let alamo = Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)
        
        alamo.responseJSON(){ response in
            print("JSON=\(response.result.value!)")
            if let jsonObject = response.result.value as? [String : Any] {
                print("userID = \(jsonObject["userId"]!)")
                print("name   = \(jsonObject["name"]!)")
            }
        }
    }
}

