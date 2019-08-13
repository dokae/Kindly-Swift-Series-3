//
//  CSButton.swift
//  Chapter03-CSButton
//
//  Created by Park Jae Han on 30/07/2019.
//

import UIKit

// 버튼 타입
public enum CSButtonType {
    case rect
    case circle
}

class CSButton: UIButton {
    
    var style: CSButtonType = .rect {
        didSet {
            
            switch style {
            case .rect:
                self.backgroundColor = UIColor.black
                self.layer.cornerRadius = 0
                self.setTitle("Rect Button", for: .normal)
            case .circle:
                self.backgroundColor = UIColor.black
                self.layer.cornerRadius = 30
                self.setTitle("Round Button", for: .normal)
            }
        }
    }
    
    // 스토리 보드용 초기화
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.backgroundColor = UIColor.green
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("BTN", for: .normal)
    }
    
    // 코딩용 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("Code Init BTN", for: .normal)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.gray
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("Init.zero BTN", for: .normal)
    }
    
    // 스타일 선택 버튼
    convenience init(type: CSButtonType) {
        self.init()
        
        switch type {
        case .rect:
            self.backgroundColor = UIColor.black
            self.layer.cornerRadius = 0
            self.setTitle("Rect Button", for: .normal)
        case .circle:
            self.backgroundColor = UIColor.black
            self.layer.cornerRadius = 30
            self.setTitle("Round Button", for: .normal)
        }
        
        self.addTarget(self, action: #selector(counting(_:)), for: .touchUpInside)
    }
    
    // 버튼 카운트 메소드
    @objc func counting(_ sender: UIButton) {
        sender.tag = sender.tag + 1
        sender.setTitle("\(sender.tag)th touched", for: .normal)
    }
    
}
