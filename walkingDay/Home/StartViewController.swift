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
    
    //로케이션 매니저
    var locationManager:CLLocationManager!
    //위경도
    var latitude = 0.0
    var longitude = 0.0
    //위경도 값
    var coorLatitude = 0.0
    var coorLongitude = 0.0
    
    //지역 위치값
    var province = "서울특별시"
    var city = "중구"
    
    //api 소스
    let apiKey = "tHdaFkeZaI9Bkc1GCSnDqZ76KjZQGbNNh4kX38IzDT2GmbD3McHV%2BzZV5%2F5ygds3p%2BVZ3rOtvxHCJcoCAzlmTg%3D%3D"
    
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
        //앱이 처음으로 시작하면 현재위치 레코드 추가
        currentLocationListCheck()
        //네트워크 체크
        selfCheckDeviceNetworkStatus()
        
        //위치 디비 isChecked 체크
        LocationDbManagerIsChecked {
            //위치 권한 체크 및 요청
            checkCoorLatitudeAndCoorLongitude(latitude: latitude, longitude: longitude, coorLatitude: coorLatitude, coorLongitude: coorLongitude) { (province, city) in
                self.province = province
                self.city = city
                self.airAipGroup {
                    self.toHomeViewCon()
                }
            }
        } action2: {
            let LocationDbManagerIsChecked = LocationDbManager.shared.locationList()?.filter("isChecked == true")
            province = LocationDbManagerIsChecked?.first?.provinces ?? "서울특별시"
            city = LocationDbManagerIsChecked?.first?.city ?? "중구"
            self.airAipGroup {
                self.toHomeViewCon()
            }
        }
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
        }
    }
    
    //MARK: 미세먼지 api 그룹
    func airAipGroup(action: @escaping () -> Void) {
        measuringStationApi(apiKey: apiKey, province: province, city: city) { (resultDmX, resultDmY) in
            let resultDmX = resultDmX
            let resultDmY = resultDmY
            self.searchMeasuringStationApi(apiKey: self.apiKey, resultDmX: resultDmX, resultDmY: resultDmY) { (result) in
                let result = result
                self.airApi(apiKey: self.apiKey, measuringStation: result) { pm10Grade,pm10Value,pm25Grade,pm25Value,no2Grade,no2Value,o3Grade,o3Value,coGrade,coValue,so2Grade,so2Value  in
                    let ad = UIApplication.shared.delegate as? AppDelegate
                    ad?.pm10Grade = pm10Grade
                    ad?.pm10Value = pm10Value
                    ad?.pm25Grade = pm25Grade
                    ad?.pm25Value = pm25Value
                    ad?.no2Grade = no2Grade
                    ad?.no2Value = no2Value
                    ad?.o3Grade = o3Grade
                    ad?.o3Value = o3Value
                    ad?.coGrade = coGrade
                    ad?.coValue = coValue
                    ad?.so2Grade = so2Grade
                    ad?.so2Value = so2Value
                    action()
                }
            }
        }
    }
    func adAirApiDateSet() {
        
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        toHomeViewCon()
    }
    
    func toHomeViewCon() {
        //딜레이
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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

//MARK: 현재 위치 구현
extension StartViewController: CLLocationManagerDelegate {
    //위치 권한 체크 및 요청
    func checkCoorLatitudeAndCoorLongitude() {
        //위경도 둘 중 하나라도 0.0이면 함수 재실행
        if coorLatitude == 0.0 || coorLongitude == 0.0  {
            //위치 권한 버튼을 클릭해야지 다음 함수 실행
            LocationManager.sharedInstance.runLocationBlock {
                //insert location code here
                self.callLocationManager {
                    //위치 경도 추출
                    self.currentLocation()
                }
            }
        }
    }
    
    //위치 불러오는 함수
    func callLocationManager(after: @escaping () -> ()) {
        locationManager = CLLocationManager()
    
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //배터리에 맞게 권장되는 최적의 정확도
            //locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //위치 업데이트
            locationManager.startUpdatingLocation()
        }
        
        let coor = locationManager.location?.coordinate
        
        coorLatitude = coor?.latitude ?? 0
        coorLongitude = coor?.longitude ?? 0
        after()
    }
    
    //위치 경도 추출
    func currentLocation() {
        //위,경도 가져오기
        latitude = coorLatitude
        longitude = coorLongitude
        
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        //나라 언어 코드
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(
            placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                //address.last?.thoroughfare 00동 or 도로명 //.subLocality 00동 //.stringWithoutDigit 구 //.subThoroughfare 지번 //.locality 00시 //.administrativeArea 00도 //.country 대한민국
                if let name: String = address.last?.administrativeArea, let name2: String = address.last?.locality{
                    //숫자제거
                    let stringWithoutDigit = name.components(separatedBy: ["0","1","2","3","4","5","6","7","8","9"]).joined()
                    let stringWithoutDigit2 = name2.components(separatedBy: ["0","1","2","3","4","5","6","7","8","9"]).joined()
                    self.province = stringWithoutDigit
                    self.city = stringWithoutDigit2
                    
                    self.toHomeViewCon()
                } //전체 주소
            }
        })
    }
}
