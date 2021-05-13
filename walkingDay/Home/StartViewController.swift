//
//  StartViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/19.
//

import SwiftyGif

class StartViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var loadingImg: UIImageView!
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    var bgView: UIView!
    let gradient = CAGradientLayer()
    
    let healthStore = HKHealthStore()
    
    //로케이션 매니저
    var locationManager:CLLocationManager!
    //위경도
    var latitude = 0.0
    var longitude = 0.0
    //위경도 값
    var coorLatitude = 0.0
    var coorLongitude = 0.0
    
    //지역 위치값
    var province = "위치"
    var city = ""
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        designSet()
        //앱이 처음으로 시작하면 현재위치 레코드 추가
        currentLocationListCheck()
        //네트워크 체크
        selfCheckDeviceNetworkStatus()
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
    }
    
    //로딩 이미지 세팅
    func lodingGifSet(gifName: String) {
        let gif = try! UIImage(gifName: gifName)
        self.loadingImg.setGifImage(gif, loopCount: -1) // Will loop forever
    }
    
    //앱이 처음으로 시작하면 현재위치 레코드 추가
    func currentLocationListCheck() {
        if LocationDbManager.shared.locationList()?.count == 0 {
            LocationDbManager.shared.locationListInsert(provinces: "현재 위치", city: "", isChecked: true)
            toIntroPage()
        }
    }
    
    func toIntroPage() {
        let sb = UIStoryboard(name: "Intro", bundle: nil)
        let navi = sb.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        navigationController?.pushViewController(navi, animated: false)
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //위치 디비 isChecked 체크
        LocationDbManagerIsChecked {
            //위치 권한 체크 및 요청
            checkCoorLatitudeAndCoorLongitude(latitude: latitude, longitude: longitude, coorLatitude: coorLatitude, coorLongitude: coorLongitude) { (province, city) in
                self.province = province
                self.city = city
                //Api 모음
                self.ApiGroup()
            }
        } fail: {
            let LocationDbManagerIsChecked = LocationDbManager.shared.locationList()?.filter("isChecked == true")
            province = LocationDbManagerIsChecked?.first?.provinces ?? "서울특별시"
            city = LocationDbManagerIsChecked?.first?.city ?? "중구"
            //Api 모음
            ApiGroup()
        }
    }
    
    //Api 모음
    func ApiGroup() {
        self.airApiGroup(province: province, city: city) {
            self.weatherApiGroup(province: self.province, city: self.city) {
                self.toHomeViewCon()
            }
        } fail: {
            self.toHomeViewCon()
        }
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.locationCheck {
                self.showAlertBtn1(title: "서버 통신 오류", message: "현재 위치, 날씨 등의 데이터를 불러올 수 없습니다.", btnTitle: "확인") {
                    self.toHomeViewCon()
                }
            }
        }
    }
    
    func toHomeViewCon() {
        //네이게이션 페이지로 이동
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //옵션 FullScreen
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        vc.province = self.province
        vc.city = self.city
        if HKHealthStore.isHealthDataAvailable() {
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
        } else {
            present(nav, animated: true, completion: nil)
        }
    }
}
