//
//  MapAlertViewController.swift
//  Chapter03-Alert
//
//  Created by Park Jae Han on 29/07/2019.
//

import UIKit
import MapKit

class MapAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 맵뷰 알림창 버튼 생성
        let alertBtn = UIButton(type: .system)
        alertBtn.frame = CGRect(x: 0, y: 150, width: 100, height: 30)
        alertBtn.center.x = self.view.frame.width / 2
        alertBtn.setTitle("Map Alert", for: .normal)
        alertBtn.addTarget(self, action: #selector(mapAlert(_:)), for: .touchUpInside)
        self.view.addSubview(alertBtn)
        
        // 이미지 알림창 버튼
        let imageBtn = UIButton(type: .system)
        imageBtn.frame = CGRect(x: 0, y: 200, width: 100, height: 30)
        imageBtn.center.x = self.view.frame.width / 2
        imageBtn.setTitle("Image Alert", for: .normal)
        imageBtn.addTarget(self, action: #selector(imageAlert(_:)), for: .touchUpInside)
        self.view.addSubview(imageBtn)
        
        // 슬라이더 알림창 버튼
        let sliderBtn = UIButton(type: .system)
        sliderBtn.frame = CGRect(x: 0, y: 250, width: 100, height: 30)
        sliderBtn.center.x = self.view.frame.width / 2
        sliderBtn.setTitle("Slider Alert", for: .normal)
        sliderBtn.addTarget(self, action: #selector(sliderAlert(_:)), for: .touchUpInside)
        self.view.addSubview(sliderBtn)
        
        // 테이블뷰 알림창 버튼
        let listBtn = UIButton(type: .system)
        listBtn.frame = CGRect(x: 0, y: 300, width: 100, height: 30)
        listBtn.center.x = self.view.frame.width / 2
        listBtn.setTitle("List Alert", for: .normal)
        listBtn.addTarget(self, action: #selector(listAlert(_:)), for: .touchUpInside)
        self.view.addSubview(listBtn)
    }
    
    // 맵뷰 얼럿
    @objc func mapAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Is this right?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        // 컨텐츠뷰 컨트롤러
        let contentVC = MapKitViewController()
        alert.setValue(contentVC, forKey: "contentViewController")
        self.present(alert, animated: true, completion: nil)
        
        /*
        // 컨텐츠뷰 컨트롤러
        let contentVC = UIViewController()
        let mapkitView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // 루트뷰에 추가하면 사이즈는 항상 최대
        contentVC.view = mapkitView
        contentVC.preferredContentSize.height = 200
        
        // 맵킷 속성설정
        let pos = CLLocationCoordinate2D(latitude: 37.514322, longitude: 126.894623)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: pos, span: span)
        mapkitView.region = region
        mapkitView.regionThatFits(region)
        
        let point = MKPointAnnotation()
        point.coordinate = pos
        mapkitView.addAnnotation(point)
        
        alert.setValue(contentVC, forKey: "contentViewController")
        self.present(alert, animated: true, completion: nil)
        */
    }
    
    // 이미지 얼럿
    @objc func imageAlert(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Message", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        let contentVC = ImageViewController()
        alert.setValue(contentVC, forKey: "contentViewController")
        self.present(alert, animated: true, completion: nil)
    }
    
    // 슬라이드 얼럿
    @objc func sliderAlert(_ sender: Any) {
        let contentVC = ControlViewController()
        let alert = UIAlertController(title: nil, message: "Message", preferredStyle: .alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            print(">>> sliderValue = \(contentVC.sliderValue)")
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 테이블뷰 얼럿
    @objc func listAlert(_ sender: Any) {
        let contentVC = ListViewController()
        contentVC.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 테이블뷰 델리게이트
    func didSelectRowAt(indexPath: IndexPath) {
        print(">>> Selected Row is \(indexPath.row)")
    }

  
}
