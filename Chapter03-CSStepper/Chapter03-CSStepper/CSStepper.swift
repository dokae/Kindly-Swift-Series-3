//
//  CSStepper.swift
//  Chapter03-CSStepper
//
//  Created by Park Jae Han on 31/07/2019.
//

import UIKit
@IBDesignable // 아래 클래스를 스토리보드에서 미리보기 처리
public class CSStepper: UIControl {
    
    public var leftBtn = UIButton(type: .system)
    public var rightBtn = UIButton(type: .system)
    public var centerLabel = UILabel()
    
    @IBInspectable // 증감단위
    public var stepValue: Int = 1
    
    @IBInspectable // 최대값
    public var maximumValue: Int = 100
    
    @IBInspectable // 최소값
    public var minimumValue: Int = -100
    
    @IBInspectable // 버튼 타이틀
    public var leftTitle: String = "-" {
        didSet {
            self.leftBtn.setTitle(leftTitle, for: .normal)
        }
    }
    
    @IBInspectable // 버튼 타이틀
    public var rightTitle: String = "+" {
        didSet {
            self.rightBtn.setTitle(rightTitle, for: .normal)
        }
    }
    
    @IBInspectable // 스테퍼 현재값
    public var value: Int = 0 {
        didSet {
            self.centerLabel.text = String(value)
            self.sendActions(for: .valueChanged) // 이 클래스를 사용하는 객체에게 valueChanged 이벤트 신호를 보내줌
        }
    }
    
    @IBInspectable // 센터 컬러
    public var bgColor: UIColor = UIColor.cyan {
        didSet {
            self.centerLabel.backgroundColor = bgColor
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        
        let borderWidth: CGFloat = 0.5
        let borderColor = UIColor.blue.cgColor
        
        // 좌측 버튼
        self.leftBtn.tag = -1
        self.leftBtn.setTitle(self.leftTitle, for: .normal)
        self.leftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.leftBtn.layer.borderWidth = borderWidth
        self.leftBtn.layer.borderColor = borderColor
        
        // 우측 버튼
        self.rightBtn.tag = 1
        self.rightBtn.setTitle(self.rightTitle, for: .normal)
        self.rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.rightBtn.layer.borderWidth = borderWidth
        self.rightBtn.layer.borderColor = borderColor
        
        // 중앙 레이블
        self.centerLabel.text = String(value)
        self.centerLabel.font = UIFont.systemFont(ofSize: 15)
        self.centerLabel.textAlignment = .center
        self.centerLabel.backgroundColor = self.bgColor
        self.centerLabel.layer.borderWidth = borderWidth
        self.centerLabel.layer.borderColor = borderColor
        
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        self.addSubview(self.centerLabel)
        
        self.leftBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
    }
    
    // layoutSubviews는 뷰의 크기가 변할때 호출되는 메소드
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let btnWidth = self.frame.height
        let lblWidth = self.frame.width - (btnWidth * 2)
        self.leftBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        self.centerLabel.frame = CGRect(x: btnWidth, y: 0, width: lblWidth, height: btnWidth)
        self.rightBtn.frame = CGRect(x: btnWidth + lblWidth, y: 0, width: btnWidth, height: btnWidth)
    }
    
    @objc public func valueChange(_ sender: UIButton) {
        
        // sum을 만들어서 max or min보다 크거나 작으면 메소드 종료
        let sum = self.value + (sender.tag * self.stepValue)
        if sum > self.maximumValue {
            return
        }
        if sum < self.minimumValue {
            return
        }
        
        self.value += sender.tag * self.stepValue
    }
}
