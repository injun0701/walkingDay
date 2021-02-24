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
    @IBOutlet var airValueLbl: UILabel!
    @IBOutlet var airView: SubViewBackgroundDesignBtn!
    
    @IBOutlet var backgroundImg: UIImageView!
    @IBOutlet var walkBarContainerWidth: NSLayoutConstraint!
    
    @IBOutlet var walkTitleLbl: UILabel!
    @IBOutlet var walkCountLbl: UILabel!
    @IBOutlet var walkBar: UIView!
    
    @IBOutlet var walkCollectionView: UICollectionView!
    
    @IBAction func reloadBtnAction(_ sender: UIButton) {
        LoadingHUD.show()
        //네트워크 체크
        selfCheckDeviceNetworkStatus()
        //로케이션 세팅 + 미세먼지 api
        loctionFuncGroupPlusAirAip()

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
            LoadingHUD.hide()
        }
        //걸음수 바 애니매이션 함수
        walkBarWightTransition()
        locationCheck()
    }
    
    @IBAction func hambergerMenuBtnAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Menu", bundle: nil)
        let navi = sb.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        navi.backingImage = self.view.asImage() //현재 화면 캡쳐 이미지
        navigationController?.pushViewController(navi, animated: false)
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
    
    //api 소스
    let apiKey = "tHdaFkeZaI9Bkc1GCSnDqZ76KjZQGbNNh4kX38IzDT2GmbD3McHV%2BzZV5%2F5ygds3p%2BVZ3rOtvxHCJcoCAzlmTg%3D%3D"
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //날씨 배경 이미지 세팅
        backgroundImgSet()
        //디자인 세팅
        DesignSet()
        //컬랙션뷰 데이터 세팅
        walkCollectionViewData()
        //컬랙션뷰 세팅
        walkCollectionViewSet()
        
        //MARK: LocationList으로 이동
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(locationViewTapped))
        locationView.addGestureRecognizer(tapGestureRecognizer)
        
        //MARK: AirDetail로 이동
        let tapGestureRecognizerAir = UITapGestureRecognizer(target: self, action: #selector(airViewTapped))
        airView.addGestureRecognizer(tapGestureRecognizerAir)
    }
    
    @objc func locationViewTapped(sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Location", bundle: nil)
        guard let navi = sb.instantiateViewController(withIdentifier: "LocationListViewController") as? LocationListViewController else { return }
        navi.currentLocationValue = locationLbl.text!
        self.navigationController?.pushViewController(navi, animated: true)
    }
    
    @objc func airViewTapped(sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Air", bundle: nil)
        guard let navi = sb.instantiateViewController(withIdentifier: "AirDetailViewController") as? AirDetailViewController else { return }
        navi.cityTitle = locationLbl.text!
        self.navigationController?.pushViewController(navi, animated: true)
    }
    
    //MARK: 미세먼지 api 그룹
    func airAipGroup(action: @escaping () -> Void) {
        measuringStationApi(apiKey: apiKey, province: province, city: city) { (resultDmX, resultDmY) in
            let resultDmX = resultDmX
            let resultDmY = resultDmY
            self.searchMeasuringStationApi(apiKey: self.apiKey, resultDmX: resultDmX, resultDmY: resultDmY) { (result) in
                let result = result
                self.airApi(apiKey: self.apiKey, measuringStation: result) { pm10Grade,pm10Value,pm25Grade,pm25Value,no2Grade,no2Value,o3Grade,o3Value,coGrade,coValue,so2Grade,so2Value  in
                    self.airValueLbl.text = pm10Grade
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
    
    //날씨 배경 이미지 세팅
    func backgroundImgSet() {
        gifSet(gifName: "rainMask@3x.gif")
    }
    
    //날씨 배경 이미지 호출 함수
    func gifSet(gifName: String) {
        let gif = try! UIImage(gifName: gifName)
        self.backgroundImg.setGifImage(gif, loopCount: -1) // Will loop forever
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
        let ad = UIApplication.shared.delegate as? AppDelegate
        if checkCityChange == ad?.checkCityChange {
            loctionFuncGroupPlusAirAip()
            print("미세먼지 작동!")
            ad?.checkCityChange = false
        } else {
            loctionFuncGroup()
            print("미세먼지 작동 안함!!1!")
        }
    }
    
    //로케이션 세팅
    func loctionFuncGroup() {
        let ad = UIApplication.shared.delegate as? AppDelegate
        //위치 디비 isChecked 체크
        LocationDbManagerIsChecked {
            //위치 권한 체크 및 요청
            checkCoorLatitudeAndCoorLongitude(latitude: latitude, longitude: longitude, coorLatitude: coorLatitude, coorLongitude: coorLongitude) { (province, city) in
                self.locationLbl.text = province + " " + city
                self.airValueLbl.text = ad?.pm10Grade
                LoadingHUD.hide()
            }
        } action2: {
            let locationDbManagerIsChecked = LocationDbManager.shared.locationList()?.filter("isChecked == true")
            province = locationDbManagerIsChecked?.first?.provinces ?? "서울특별시"
            city = locationDbManagerIsChecked?.first?.city ?? "중구"
            self.locationLbl.text = province + " " + city
            self.airValueLbl.text = ad?.pm10Grade
            LoadingHUD.hide()
        }
    }
    
    //로케이션 세팅 + 미세먼지 api
    func loctionFuncGroupPlusAirAip() {
        LocationDbManagerIsChecked {
            //위치 권한 체크 및 요청
            checkCoorLatitudeAndCoorLongitude(latitude: latitude, longitude: longitude, coorLatitude: coorLatitude, coorLongitude: coorLongitude) { (province, city) in
                self.locationLbl.text = province + " " + city
                self.airAipGroup {
                    LoadingHUD.hide()
                }
            }
        } action2: {
            let LocationDbManagerIsChecked = LocationDbManager.shared.locationList()?.filter("isChecked == true")
            province = LocationDbManagerIsChecked?.first?.provinces ?? "서울특별시"
            city = LocationDbManagerIsChecked?.first?.city ?? "중구"
            self.locationLbl.text = province + " " + city
            airAipGroup {
                LoadingHUD.hide()
            }
        }
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

struct WalkModel {
    var text: String
    var date: String
    
    init(text: String, date: String) {
        self.text = text
        self.date = date
    }
}
