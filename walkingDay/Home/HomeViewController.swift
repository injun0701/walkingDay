//
//  HomeViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/15.
//

import Alamofire
import SwiftyJSON
import SwiftyGif

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var locationView: UIView!
    @IBOutlet var weatherLbl: UILabel!
    @IBOutlet var weatherTemperLbl: UILabel!
    @IBOutlet var airValueLbl: UILabel!
    @IBOutlet var weatherView: SubViewBackgroundDesignBtn!
    @IBOutlet var airView: SubViewBackgroundDesignBtn!
    @IBOutlet var weatherDetailLbl: UILabel!
    
    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var walkBarContainerWidth: NSLayoutConstraint!
    
    @IBOutlet var walkTitleLbl: UILabel!
    @IBOutlet var walkCountLbl: UILabel!
    @IBOutlet var walkBar: UIView!
    
    @IBOutlet var walkCollectionView: UICollectionView!
    
    @IBAction func reloadBtnAction(_ sender: UIButton) {
        reload()
    }
    
    func reload() {
        //네트워크 체크
        selfCheckDeviceNetworkStatus()
        //위치 권한 허용 체크
        locationCheck {}
        //로케이션 세팅 + 미세먼지 api
        loctionFuncGroup() {
            self.airApiCroupFun() {
                //날씨 배경 이미지 세팅
                self.backgroundImgSet()
                LoadingHUD.hide()
            }
        }
        if HKHealthStore.isHealthDataAvailable() {
            //healthStore에서 걸음수 가져오기
            getTodaySteps(healthStore: self.healthStore) { (result) in
                self.todayWalkCountVelue = "\(result)"
                self.walkCountLbl.text = "\(result)"
            }
            getSteps(healthStore: healthStore) { (result) in
                self.stepCountVelueDayBefore = result
            } stepCountVelueTwoDaysAgo: { (result) in
                self.stepCountVelueTwoDaysAgo = result
            } stepCountVelueThreeDaysAgo: { (result) in
                self.stepCountVelueThreeDaysAgo = result
            } stepCountVelueFourDaysAgo: { (result) in
                self.stepCountVelueFourDaysAgo = result
            } stepCountVelueFiveDaysAgo: { (result) in
                self.stepCountVelueFiveDaysAgo = result
            } stepCountVelueSixDaysAgo: { (result) in
                self.stepCountVelueSixDaysAgo = result
                self.walkCollectionViewData()
                self.walkCollectionView.reloadData()
            }
        }
        //걸음수 바 애니매이션 함수
        walkBarWightTransition()
    }
    
    @IBAction func hambergerMenuBtnAction(_ sender: UIButton) {
        toMenuBtnAction()
    }
    
    @IBAction func toDetailBtnAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let navi = sb.instantiateViewController(withIdentifier: "WalkDetailViewController") as! WalkDetailViewController
        navi.walkCountDateValue = 10
        navi.walkCountValue = walkCountLbl.text!
        navi.todayWalkCountVelue = todayWalkCountVelue
        navi.stepCountVelueDayBefore =  walk[0].text
        navi.stepCountVelueTwoDaysAgo = walk[1].text
        navi.stepCountVelueThreeDaysAgo = walk[2].text
        navi.stepCountVelueFourDaysAgo = walk[3].text
        navi.stepCountVelueFiveDaysAgo = walk[4].text
        navi.stepCountVelueSixDaysAgo = walk[5].text
        navigationController?.pushViewController(navi, animated: true)
    }
    
    @IBAction func toMemoBtnAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Todo", bundle: nil)
        let navi = sb.instantiateViewController(withIdentifier: "TodoListViewController") as! TodoListViewController
        navigationController?.pushViewController(navi, animated: true)
    }
    
    //앱델리게이트
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    //헬스킷 스토어
    let healthStore = HKHealthStore()
    
    //걸음 수 배열
    var walk : [WalkModel] = []
    //이전 화면에서 넘어온 값들 수 배열
    var todayWalkCountVelue = "0"
    var stepCountVelueDayBefore = "0"
    var stepCountVelueTwoDaysAgo = "0"
    var stepCountVelueThreeDaysAgo = "0"
    var stepCountVelueFourDaysAgo = "0"
    var stepCountVelueFiveDaysAgo = "0"
    var stepCountVelueSixDaysAgo = "0"
    
    //컬렉션뷰 셀의 현재 인덱스
    var currentIdx: CGFloat = 0.0
    
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
    
    //날씨 온도 초기값
    var currentTempC = ""
    var currentTempF = ""
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //디자인 세팅
        DesignSet()
        //배경 세팅
        backgroundImgSet()
        //컬랙션뷰 데이터 세팅
        walkCollectionViewData()
        //컬랙션뷰 세팅
        walkCollectionViewSet()
        
        //MARK: LocationList으로 이동
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(locationViewTapped))
        locationView.addGestureRecognizer(tapGestureRecognizer)
        
        //MARK: AirDetail로 이동
        let tapGestureRecognizerWeather = UITapGestureRecognizer(target: self, action: #selector(weatherViewTapped))
        weatherView.addGestureRecognizer(tapGestureRecognizerWeather)
        
        //MARK: AirDetail로 이동
        let tapGestureRecognizerAir = UITapGestureRecognizer(target: self, action: #selector(airViewTapped))
        airView.addGestureRecognizer(tapGestureRecognizerAir)
    }
    
    @objc func locationViewTapped(sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Location", bundle: nil)
        guard let navi = sb.instantiateViewController(withIdentifier: "LocationListViewController") as? LocationListViewController else { return }
        navi.latitude = latitude
        navi.longitude = longitude
        navi.coorLatitude = coorLatitude
        navi.coorLongitude = coorLongitude
        self.navigationController?.pushViewController(navi, animated: true)
    }
    
    @objc func weatherViewTapped(sender: UITapGestureRecognizer) {
        if ad?.weather == "" {
            showAlertBtn1(title: "서버 통신 오류", message: "날씨 서버의 데이터를 불러올 수 없습니다.", btnTitle: "확인") {}
        } else {
            let sb = UIStoryboard(name: "Weather", bundle: nil)
            guard let navi = sb.instantiateViewController(withIdentifier: "WeatherDetailViewController") as? WeatherDetailViewController else { return }
            self.navigationController?.pushViewController(navi, animated: true)
        }
    }
    
    @objc func airViewTapped(sender: UITapGestureRecognizer) {
        if ad?.pm10Grade == "" {
            showAlertBtn1(title: "서버 통신 오류", message: "미세먼지 서버의 데이터를 불러올 수 없습니다.", btnTitle: "확인") {}
        } else {
            let sb = UIStoryboard(name: "Air", bundle: nil)
            guard let navi = sb.instantiateViewController(withIdentifier: "AirDetailViewController") as? AirDetailViewController else { return }
            self.navigationController?.pushViewController(navi, animated: true)
        }
    }
    
    //날씨 배경 이미지 세팅
    func backgroundImgSet() {
        if ad?.weather == "맑음" {
            if ad?.pm10Grade == "나쁨" || ad?.pm10Grade == "매우 나쁨" {
                homeGifSet(gifName: "sunMask@3x.gif")
                weatherDetailLblText(text: "오늘 날씨는 맑은데 미세먼지가 있네요.  마스크 챙기세요!")
                backgroundView.backgroundColor = UIColor().colorEEEEEE
            } else {
                homeGifSet(gifName: "sun@3x.gif")
                weatherDetailLblText(text: "해가 떠서 맑고 미세먼지도 깨끗해요.  산책 나가 볼까요?")
                backgroundView.backgroundColor = UIColor().sub01ColorYellow
            }
        } else if ad?.weather == "비" {
            if ad?.pm10Grade == "나쁨" || ad?.pm10Grade == "매우 나쁨" {
                homeGifSet(gifName: "rainMask@3x.gif")
                weatherDetailLbl.text = "우산하고 마스크 꼭 챙기세요!"
                backgroundView.backgroundColor = UIColor().colorEEEEEE
            } else {
                homeGifSet(gifName: "rain@3x.gif")
                weatherDetailLbl.text = "우산 꼭 챙기세요!"
                backgroundView.backgroundColor = UIColor().sub01Colorblue
            }

        } else if ad?.weather == "눈" {
            if ad?.pm10Grade == "나쁨" || ad?.pm10Grade == "매우 나쁨" {
                homeGifSet(gifName: "snowMask@3x.gif")
                weatherDetailLbl.text = "우산하고 마스크 꼭 챙기세요!"
                backgroundView.backgroundColor = UIColor().colorEEEEEE
            } else {
                homeGifSet(gifName: "snow@3x.gif")
                weatherDetailLbl.text = "우산 꼭 챙기세요!"
                backgroundView.backgroundColor = UIColor().sub01Colorblue
            }
        } else if ad?.weather == "" {
            homeGifSet(gifName: "sun@3x.gif")
            weatherDetailLblText(text: "서버 통신 오류로 날씨 및 미세먼지  데이터를 불러올 수 없습니다.")
            backgroundView.backgroundColor = UIColor().colorEEEEEE
        } else {
            if ad?.pm10Grade == "나쁨" || ad?.pm10Grade == "매우 나쁨" {
                homeGifSet(gifName: "sunMask@3x.gif")
                weatherDetailLblText(text: "날씨가 흐리고 미세먼지가 있네요.  마스크 챙기세요!")
            } else {
                homeGifSet(gifName: "sun@3x.gif")
                weatherDetailLblText(text: "구름이 있어서 날씨가 조금 흐리네요.  간단한 산책 어떠세요?")
            }
            backgroundView.backgroundColor = UIColor().colorEEEEEE
        }
    }
    
    func weatherDetailLblText(text: String) {
        weatherDetailLbl.setTextWithLineHeight(text: text, lineHeight: 28)
    }
    
    //날씨 배경 이미지 호출 함수
    func homeGifSet(gifName: String) {
        let gifName = gifName
        let gif = try? UIImage(gifName: gifName)
        let gifDefult = try! UIImage(gifName: "sun@3x.gif")
        self.backgroundImg.setGifImage(gif ?? gifDefult, loopCount: -1) // Will loop forever
    }
    
    //디자인세팅
    func DesignSet() {
        locationLbl.text = province + " " + city
        walkBar.layer.cornerRadius = 3
        walkBar.layer.masksToBounds = false
        walkBar.layer.backgroundColor = UIColor().mainColorOrange.cgColor
    }
    
    //컬랙션뷰 데이터 세팅
    func walkCollectionViewData() {
        let formatter = DateFormatter() // 특정 포맷으로 날짜를 보여주기 위한 변수 선언
        formatter.dateFormat = "yyyy MM dd" // 날짜 포맷 지정
        
        walk = [
            WalkModel(text: stepCountVelueDayBefore, date: formatter.string(from: Date().dayBefore)),
            WalkModel(text: stepCountVelueTwoDaysAgo, date: formatter.string(from: Date().twoDaysAgo)),
            WalkModel(text: stepCountVelueThreeDaysAgo, date: formatter.string(from: Date().threeDaysAgo)),
            WalkModel(text: stepCountVelueFourDaysAgo, date: formatter.string(from: Date().fourDaysAgo)),
            WalkModel(text: stepCountVelueFiveDaysAgo, date: formatter.string(from: Date().fiveDaysAgo)),
            WalkModel(text: stepCountVelueSixDaysAgo, date: formatter.string(from: Date().sixDaysAgo))
       ]
    }
    
    //컬랙션뷰 세팅
    func walkCollectionViewSet() {
        walkCollectionView.delegate = self
        walkCollectionView.dataSource = self
        walkCollectionView.decelerationRate = .fast
        walkCollectionView.isPagingEnabled = false
        walkCollectionView.register(UINib(nibName: "WalkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WalkCollectionViewCell")
    }
 
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //네트워크 체크
        selfCheckDeviceNetworkStatus()
        //healthStore에서 걸음수 가져오기
        getTodaySteps(healthStore: self.healthStore) { (result) in
            self.todayWalkCountVelue = "\(result)"
            self.walkCountLbl.text = "\(result)"
        }
        LoadingHUD.show()
        //네트워크 체크
        selfCheckDeviceNetworkStatus()
       
        viewWillAppearSet()
    }
    
    //MARK: 로케이션 viewWillAppear 세팅
    func viewWillAppearSet() {
        //위치 리스트 체크값이 변경되는지 체크
        let checkCityChange = true
        if checkCityChange == ad?.checkCityChange {
            //로케이션 세팅 + 미세먼지 api
            loctionFuncGroup() {
                self.airApiCroupFun() {
                    //날씨 배경 이미지 세팅
                    self.backgroundImgSet()
                    LoadingHUD.hide()
                }
            }
            print("미세먼지 작동!")
            ad?.checkCityChange = false
        } else {
            //로케이션 세팅
            loctionFuncGroup() {
                //날씨 배경 이미지 세팅
                self.backgroundImgSet()
                LoadingHUD.hide()
            }
            print("미세먼지 작동 안함!!")
        }
    }
    
    //로케이션 세팅
    func loctionFuncGroup(after: @escaping () -> ()) {
        //위치 디비 isChecked 체크
        LocationDbManagerIsChecked { //id가 0이면(현재위치이면)
            //위치 권한 체크 및 요청
            checkCoorLatitudeAndCoorLongitude(latitude: latitude, longitude: longitude, coorLatitude: coorLatitude, coorLongitude: coorLongitude) { (province, city) in
                self.textLblSet()
                self.locationLbl.text = province + " " + city
                UserDefaults.standard.set(self.locationLbl.text!, forKey: "cityTitle")
                self.province = province
                self.city = city
                after()
                
            }
        } fail: {//현재위치가 아니면
            let locationDbManagerIsChecked = LocationDbManager.shared.locationList()?.filter("isChecked == true")
            province = locationDbManagerIsChecked?.first?.provinces ?? "서울특별시"
            city = locationDbManagerIsChecked?.first?.city ?? "중구"
            textLblSet()
            after()
        }
    }
    
    func textLblSet(){
        self.locationLbl.text = province + " " + city
        self.airValueLbl.text = ad?.pm10Grade
        self.weatherLbl.text = ad?.weather
        if ad!.currentTemp != "" {
            let currentTempToDouble = Double(ad!.currentTemp) ?? 0.0
            currentTempC = String(format: "%.0f", currentTempToDouble+0)
            currentTempF = String(format: "%.0f", (currentTempToDouble+273.15))
        }
        self.weatherTemperLbl.text = "\(currentTempC)℃/\(currentTempF)°F"
        UserDefaults.standard.set(locationLbl.text!, forKey: "cityTitle")
    }
    
    //대기정보 api 모음
    func airApiCroupFun(after: @escaping () -> ()) {
        airApiGroup(province: province, city: city) { [self] in
            weatherApiGroup(province: province, city: city) { [self] in
                //날씨라벨, 온도라벨 세팅
                weatherlblAndWeatherTemperLblSetting()
                after()
            }
        } fail: {}
    }
    
    //날씨라벨, 온도라벨 세팅
    func weatherlblAndWeatherTemperLblSetting() {
        if ad!.currentTemp != "" {
            let currentTempToDouble = Double(ad!.currentTemp) ?? 0.0
            currentTempC = String(format: "%.0f", currentTempToDouble+0)
            currentTempF = String(format: "%.0f", (currentTempToDouble+273.15))
        }
        weatherLbl.text = ad?.weather
        weatherTemperLbl.text = "\(currentTempC)℃/\(currentTempF)°F"
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        LoadingHUD.hide()
        //걸음수 바 애니매이션 함수
        walkBarWightTransition()
    }
    
    //걸음수 바 애니매이션 함수
    func walkBarWightTransition() {
        //걸음수
        var walkCount = Double(todayWalkCountVelue) ?? 0
        if walkCount > 10000 {
            walkCount = 10000
        }
        walkCount = walkCount * 0.01
        
        let padding = 20.0 * 2
        //걸음수 당 퍼센트 공식: (스크린 가로 - 패딩) * 걸음수 퍼센트 * 0.01
        var walkBarContainerWidthPercent = Double(CGFloat(Double(Int(UIScreen.main.bounds.width)) - padding)) * Double(walkCount) * 0.01
        
        if walkBarContainerWidthPercent <= 16 {
            walkBarContainerWidthPercent = 16
        }
        //딜레이 0.4초
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            //애니메이션 준비
            self.view.layoutIfNeeded()
            self.walkBarContainerWidth.constant = 16
            //애니메이션 동작
            UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut) {
                self.walkBarContainerWidth.constant = CGFloat(walkBarContainerWidthPercent)
                self.view.layoutIfNeeded()
            }.startAnimation()
        }
    }
}

//MARK: 콜렉션뷰 구현
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walk.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkCollectionViewCell", for: indexPath) as? WalkCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.walkCountLbl.text = walk[indexPath.row].text
        cell.walkDateLbl.text = walk[indexPath.row].date
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navi = self.storyboard?.instantiateViewController(withIdentifier: "WalkDetailViewController") as? WalkDetailViewController else { return }
        navi.walkCountDateValue = indexPath.row
        navi.walkCountValue =  walk[indexPath.row].text
        navi.todayWalkCountVelue = self.todayWalkCountVelue
        navi.stepCountVelueDayBefore =  walk[0].text
        navi.stepCountVelueTwoDaysAgo = walk[1].text
        navi.stepCountVelueThreeDaysAgo = walk[2].text
        navi.stepCountVelueFourDaysAgo = walk[3].text
        navi.stepCountVelueFiveDaysAgo = walk[4].text
        navi.stepCountVelueSixDaysAgo = walk[5].text
        self.navigationController?.pushViewController(navi, animated: true)
        
    }
    
    //컬랙션뷰 가로 스크롤 한번에 셀 크기씩 이동
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if let cv = scrollView as? UICollectionView {
            let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
            
            var offset = targetContentOffset.pointee
            let idx = round((offset.x + layout.sectionInset.left + 10) / cellWidth)
            
            if idx > currentIdx {
                currentIdx += 1
            } else if idx < currentIdx {
                if currentIdx != 0 {
                    currentIdx -= 1
                }
            }
            offset = CGPoint(x: currentIdx * (cellWidth + layout.sectionInset.left + 10), y: 0)
            targetContentOffset.pointee = offset
        }
    }
}

//걸음수 모델
struct WalkModel {
    var text: String
    var date: String
    
    init(text: String, date: String) {
        self.text = text
        self.date = date
    }
}
