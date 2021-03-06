//
//  Extension.swift
//  test
//
//  Created by HongInJun on 2021/01/31.
//

extension UIViewController {
    
    func setBg() {
    }
    
    //다국어 지원 메서드
    func localize(_ whenUseLocalizedStringThiskey : String) -> String {
        return NSLocalizedString(whenUseLocalizedStringThiskey, comment: "")
    }
    
    //데이터피커 모드: 휠
    func datePickerWheels(picker: UIDatePicker) {
        if #available(iOS 13.4, *) {
            picker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            picker.preferredDatePickerStyle = .wheels
        }
    }
    //MARK: 메모리스트 구현
    //현재 달력 날짜 데이터
    func calenderDateSet(_ calenderDate: String) -> String {
        let format = DateFormatter() // date <-> string
        format.dateFormat = "yyyy-MM-dd"
        let currentDate = format.string(from: Date())
        var calenderDateSet = ""
        if calenderDate == "" {
            calenderDateSet = currentDate
        } else {
            calenderDateSet = calenderDate
        }
        return calenderDateSet
    }
    
    //MARK: 현제 페이지 네트워크 체크
    func selfCheckDeviceNetworkStatus() {
        if(DeviceManager.shared.networkStatus) {
        } else {
            let alert: UIAlertController = UIAlertController(title: "네트워크 상태 확인", message: "네트워크가 불안정 합니다.", preferredStyle: .alert)
            let action: UIAlertAction = UIAlertAction(title: "다시 시도", style: .default, handler: { (action) in
                self.selfCheckDeviceNetworkStatus()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //위치 권한 체크
    @objc func locationCheck(after: @escaping () -> ()) {
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alter = UIAlertController(title: "위치 권한 설정이 '허용 안 함'으로 되어있습니다.", message: "앱 설정 화면으로 가시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
                after()
            }
            let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive){
                (action: UIAlertAction) in
                after()
            }
            alter.addAction(logNoAction)
            alter.addAction(logOkAction)
            self.present(alter, animated: true, completion: nil)
        }
    }
    
    //위치 디비 isChecked 체크
    func LocationDbManagerIsChecked(checkCoorLatitudeAndCoorLongitude: () -> Void, fail: () -> Void) {
        if LocationDbManager.shared.locationList()?.filter("id == 0").first?.isChecked == true {
            //위치 권한 체크 및 요청
            checkCoorLatitudeAndCoorLongitude()
        } else {
            fail()
        }
    }
    
    //버튼 한개 알럿
    func showAlertBtn1(title: String, message: String, btnTitle: String, action: @escaping () -> Void)  {
        //1. Alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //2. AlertAction 생성
        let btn1 = UIAlertAction(title: btnTitle, style: .default) { (_) in
            print("버튼1 클릭함")
            action()
        }
        //3. Alert + AlerAction
        alert.addAction(btn1)
        
        //4.Alert Present
        present(alert, animated: true) {
            print("Alert이 잘 작동됨")
        }
    }
    
    //날씨 배경 이미지 호출 함수
    func gifSet(gifName: String, imgView: UIImageView) {
        let gifName = gifName
        let gif = try! UIImage(gifName: gifName)
        imgView.setGifImage(gif, loopCount: -1) // Will loop forever
    }
    
    func dateLblSet(lbl: UILabel) {
        let formatter = DateFormatter() // 특정 포맷으로 날짜를 보여주기 위한 변수 선언
        formatter.dateFormat = "yyyy년 MM월 dd일" // 날짜 포맷 지정
        lbl.text = formatter.string(from: Date())
    }
    
    func toMenuBtnAction() {
        let sb = UIStoryboard(name: "Menu", bundle: nil)
        let navi = sb.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        navi.backingImage = self.view.asImage() //현재 화면 캡쳐 이미지
        navigationController?.pushViewController(navi, animated: false)
    }
    
    
}

//MARK: 유아이_컬러 extension
extension UIColor {
    var textColor888888 : UIColor {
        return UIColor(named: "textColor888888")!
    }
    var textColor555555 : UIColor {
        return UIColor(named: "textColor555555")!
    }
    var textColorAAAAAA : UIColor {
        return UIColor(named: "textColorAAAAAA")!
    }
    var colorEEEEEE : UIColor {
        return UIColor(named: "colorEEEEEE")!
    }
    var mainColorOrange : UIColor {
        return UIColor(named: "mainColorOrange")!
    }
    var sub01ColorDarkOrange : UIColor {
        return UIColor(named: "sub01ColorDarkOrange")!
    }
    var sub01ColorYellow : UIColor {
        return UIColor(named: "sub01ColorYellow")!
    }
    var sub01Colorblue : UIColor {
        return UIColor(named: "sub01Colorblue")!
    }
}

//MARK: 유아이_이미지 extension
extension UIImage {
}

//MARK: 유아이_폰트 extension
extension UIFont {
    var semibold16 : UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    var semibold18 : UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    var bold15 : UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    var bold18 : UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    var regular13 : UIFont {
        return UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    var regular14 : UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    var regular16 : UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}

//MARK: 유아이_뷰 extension
extension UIView  {
    //뷰의 범위 내에서 뷰를 렌더링한 후 이미지로 캡처(현제화면 캡쳐 준비 과정) //위로 나오는 팝업 시 필요
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image(actions: { rendererContext in
            layer.render(in: rendererContext.cgContext)
        })
    }
    
    //SubViewBackgroundDesign 뷰의 쉐도우 디자인 세팅
    func cellBackgroundViewDesign(_ subBgView: UIView,cornerRadius: Int, height: Double, shadowRadius: Int, shadowOpacity: Double ) {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOpacity = Float(shadowOpacity)
    }
}

//MARK: 데이트 extension
extension Date {
    static var yesterday: Date {
        return Date().dayBefore
    }
    static var twoDaysAgo: Date {
        return Date().twoDaysAgo
    }
    static var threeDaysAgo: Date {
        return Date().threeDaysAgo
    }
    static var fourDaysAgo: Date {
        return Date().fourDaysAgo
    }
    static var fiveDaysAgo: Date {
        return Date().fiveDaysAgo
    }
    static var sixDaysAgo: Date {
        return Date().sixDaysAgo
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var twoDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var threeDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -3, to: noon)!
    }
    var fourDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -4, to: noon)!
    }
    var fiveDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -5, to: noon)!
    }
    var sixDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -6, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

//MARK: 네비게이션컨트롤러 extension
extension UINavigationController {
    
    //이전 스텍 체크하는 함수
    func previousViewController() -> UIViewController?{
        
        let lenght = self.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        
        return previousViewController
    }
    
}

//MARK: 유아이라벨 extension
extension UILabel {
    //text: 라벨의 텍스트 , lineHeight: 
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style
            ]
                
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
        
    }
}
