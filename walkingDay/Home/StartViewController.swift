//
//  StartViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/19.
//

import SwiftyGif

class StartViewController: UIViewController {

    @IBOutlet var loadingImg: UIImageView!
    
    var bgView: UIView!
    let gradient = CAGradientLayer()
    
    let healthStore = HKHealthStore()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        designSet()
    }
    
    func designSet() {
        bgView = UIView()
        bgView.frame = view.bounds
        
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor().mainColorOrange.cgColor,
            UIColor().sub01ColorDarkOrange.cgColor
        ]
        view.addSubview(bgView)
        bgView.layer.addSublayer(gradient)
        
        view.sendSubviewToBack(bgView)
        lodingGifSet(gifName: "loadong01.gif")
        //LocationList 현재 위치 레코드 추가
        currentLocationListCheck()
        //위치정보 권한 체크
        locationCheck()
    }
    
    //로딩 이미지 세팅
    func lodingGifSet(gifName: String) {
        let gif = try! UIImage(gifName: gifName)
        self.loadingImg.setGifImage(gif, loopCount: -1) // Will loop forever
    }
    
    func currentLocationListCheck() {
        if LocationDbManager.shared.locationList()?.count == 0 {
            LocationDbManager.shared.locationListInsert(provinces: "현재 위치", city: "", isChecked: true)
        }
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        toHomeViewCon()
    }
    
    func toHomeViewCon() {
        //딜레이
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //네이게이션 페이지로 이동
            let sb = UIStoryboard(name: "Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            //옵션 FullScreen
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.getSteps(healthStore: self.healthStore) { (result) in
                vc.stepCountVelueDayBefore = result
            } stepCountVelueTwoDaysAgo: { (result) in
                vc.stepCountVelueTwoDaysAgo = result
            } stepCountVelueThreeDaysAgo: { (result) in
                vc.stepCountVelueThreeDaysAgo = result
            } stepCountVelueFourDaysAgo: { (result) in
                vc.stepCountVelueFourDaysAgo = result
            } stepCountVelueFiveDaysAgo: { (result) in
                vc.stepCountVelueFiveDaysAgo = result
            } stepCountVelueSixDaysAgo: { (result) in
                vc.stepCountVelueSixDaysAgo = result
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}
