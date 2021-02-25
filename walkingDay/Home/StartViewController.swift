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
        measuringStationApi(apiKey: apiKey, province: province, city: city) { (resultTmX, resultTmY) in
            let resultTmX = resultTmX
            let resultTmY = resultTmY
            self.searchMeasuringStationApi(apiKey: self.apiKey, resultTmX: resultTmX, resultTmY: resultTmY) { (result) in
                let result = result
                self.airApi(apiKey: self.apiKey, measuringStation: result) { [self] pm10Grade,pm10Value,pm25Grade,pm25Value,no2Grade,no2Value,o3Grade,o3Value,coGrade,coValue,so2Grade,so2Value  in
                    
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
    
    //MARK: weather api 그룹
    func weatherAipGroup(action: @escaping () -> Void) {
        weatherLoationApi(apiKey: apiKey, province: province, city: city) { (resultDmX, resultDmY) in
            let resultDmX = resultDmX
            let resultDmY = resultDmY
       
            self.weatherApi(resultDmX: resultDmX, resultDmY: resultDmY) { [self] weather,currentTemp,feelsLikeTemp,humidityText,windText  in
                    
                ad?.weather = weather
                ad?.currentTemp = currentTemp
                ad?.feelsLikeTemp = feelsLikeTemp
                ad?.humidityText = humidityText
                ad?.windText = windText
                action()
            }
            
        }
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
//        toHomeViewCon()
        
        //위치 디비 isChecked 체크
        LocationDbManagerIsChecked {
            //위치 권한 체크 및 요청
            checkCoorLatitudeAndCoorLongitude(latitude: latitude, longitude: longitude, coorLatitude: coorLatitude, coorLongitude: coorLongitude) { (province, city) in
                self.province = province
                self.city = city
                self.airAipGroup {
                    self.weatherAipGroup{
                        self.toHomeViewCon()
                    }
                }
            }
        } action2: {
            let LocationDbManagerIsChecked = LocationDbManager.shared.locationList()?.filter("isChecked == true")
            province = LocationDbManagerIsChecked?.first?.provinces ?? "서울특별시"
            city = LocationDbManagerIsChecked?.first?.city ?? "중구"
            self.airAipGroup {
                self.weatherAipGroup{
                    self.toHomeViewCon()
                }
            }
        }
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
