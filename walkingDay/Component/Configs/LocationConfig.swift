//
//  LocationConfig.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/21.
//

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    private var locationManager = CLLocationManager()
    private let operationQueue = OperationQueue()

    override init(){
        super.init()

        //Pause the operation queue because
        // we don't know if we have location permissions yet
        operationQueue.isSuspended = true
        locationManager.delegate = self
    }

    //When the user presses the allow/don't allow buttons on the popup dialogue
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        //If we're authorized to use location services, run all operations in the queue
        // otherwise if we were denied access, cancel the operations
        if(status == .authorizedAlways || status == .authorizedWhenInUse){
            self.operationQueue.isSuspended = false
        }else if(status == .denied){
            self.operationQueue.cancelAllOperations()
        }
    }

    //Checks the status of the location permission
    //and adds the callback block to the queue to run when finished checking
    //NOTE: Anything done in the UI should be enclosed in `DispatchQueue.main.async {}`
    func runLocationBlock(callback: @escaping () -> ()){

        //Get the current authorization status
        let authState = CLLocationManager.authorizationStatus()

        //If we have permissions, start executing the commands immediately
        // otherwise request permission
        if(authState == .authorizedAlways || authState == .authorizedWhenInUse){
            self.operationQueue.isSuspended = false
        }else{
            //Request permission
            locationManager.requestAlwaysAuthorization()
        }

        //Create a closure with the callback function so we can add it to the operationQueue
        let block = { callback() }

        //Add block to the queue to be executed asynchronously
        self.operationQueue.addOperation(block)
    }
}

//MARK: CLLocationManagerDelegate extension
extension CLLocationManagerDelegate {
    //MARK: 현재 위치 구현
    //위치 권한 체크 및 요청
    func checkCoorLatitudeAndCoorLongitude(latitude:Double, longitude:Double, coorLatitude: Double, coorLongitude: Double, after: @escaping (_ province: String, _ city: String) -> ()) {
        var latitudeCopy = latitude
        var longitudeCopy = longitude
        var coorLatitudeCopy = coorLatitude
        var coorLongitudeCopy = coorLongitude
        
        if coorLatitude == 0.0 || coorLongitude == 0.0  {
            //위치 권한 버튼을 클릭해야지 다음 함수 실행
            LocationManager.sharedInstance.runLocationBlock {
                
                //insert location code here
                self.callLocationManager(coorLatitude: &coorLatitudeCopy, coorLongitude: &coorLongitudeCopy) {coorLatitude, coorLongitude in
                    //위치 경도 추출
                    var coorLatitudeCopy = coorLatitude
                    var coorLongitudeCopy = coorLongitude
                    self.currentLocation(latitude: &latitudeCopy, longitude: &longitudeCopy, coorLatitude: &coorLatitudeCopy, coorLongitude: &coorLongitudeCopy) {province, city in
                        after(province, city)
                    }
                }
            }
        }
    }
    
    //위치 불러오는 함수
    func callLocationManager(coorLatitude: inout Double, coorLongitude: inout Double, after: @escaping (_ coorLatitude: Double, _ coorLongitude: Double) -> ()) {
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //배터리에 맞게 권장되는 최적의 정확도
            //locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //오차 범위 10미터 이내
            //위치 업데이트
            locationManager.startUpdatingLocation()
        }
        
        let coor = locationManager.location?.coordinate
        
        coorLatitude = coor?.latitude ?? 0
        coorLongitude = coor?.longitude ?? 0
        after(coorLatitude, coorLongitude)
    }
    
    //위치 경도 추출
    func currentLocation(latitude: inout Double, longitude: inout Double,coorLatitude: inout Double, coorLongitude: inout Double, after: @escaping (_ province: String, _ city: String) -> ()) {
        
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
                    let province = name.components(separatedBy: ["0","1","2","3","4","5","6","7","8","9"]).joined()
                    let city = name2.components(separatedBy: ["0","1","2","3","4","5","6","7","8","9"]).joined()
                    after(province, city)
                } //전체 주소
            }
        })
    }
    
}
