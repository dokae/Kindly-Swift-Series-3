//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by Park Jae Han on 28/07/2019.
//  Copyright © 2019 Park Jae Han. All rights reserved.
//

import UIKit

class MemoFormVC: UIViewController {

    var subject: String!
    lazy var dao = MemoDAO()
    
    @IBOutlet var contents: UITextView!
    @IBOutlet var preview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contents.delegate = self // 텍스트뷰 델리게이트
        
        // 배경이미지 설정
        let bgImage = UIImage(named: "memo-background@2x.png")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        // 텍스트뷰 투명하게
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        // 텍스트뷰 행간: 속성설정 후
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.contents.text = ""
        
    }
    
    @IBAction func pick(_ sender: Any) {
        // 이미지 피커 생성과 표시
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        // 경고창에 사용될 컨텐츠뷰컨트롤러(경고창에 이미지넣기)
        let alertV = UIViewController()
        let iconImage = UIImage(named: "warning-icon-60")
        alertV.view = UIImageView(image: iconImage)
        alertV.preferredContentSize = iconImage?.size ?? CGSize.zero
        
        // 내용 미입력시 얼럿창
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "Input Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.setValue(alertV, forKey: "contentViewController") // 컨텐츠뷰컨트롤러 세팅
            self.present(alert, animated: true)
            
            return
        }
        
        // MemoData객체 생성. 데이터 담음
        let data = MemoData()
        data.title = self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.regdate = Date()
        
        // 앱델리게이트의 memolist배열에 MemoData 객체 추가
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.memolist.append(data)
        
        // 코어 데이터에 추가
        self.dao.insert(data)
        
        // 작성종료, 이전화면으로
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // 터치시 네비바 히든
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        let ts = TimeInterval(0.3)
        UIView.animate(withDuration: ts) {
            bar?.alpha = (bar?.alpha == 0 ? 1 : 0)
        }
    }
}

//MARK:- UITextViewDelegate
extension MemoFormVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트를 15자까지 읽어 내비타이틀에 저장
        let contents = textView.text as NSString
        let length = (contents.length > 15) ? 15 : contents.length
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        self.navigationItem.title = subject
    }
}


//MARK:- UIImagePickerControllerDelegate
extension MemoFormVC: UIImagePickerControllerDelegate {
    
    // 선택완료 후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.preview.image = info[.editedImage] as? UIImage
        picker.dismiss(animated: true)
    }
}

//MARK:- UINavigationControllerDelegate
extension MemoFormVC: UINavigationControllerDelegate {}

