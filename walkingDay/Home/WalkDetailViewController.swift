//
//  WalkDetailViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/18.
//

class WalkDetailViewController: UIViewController {
    
    @IBOutlet var view01DateLbl: UILabel!
    @IBOutlet var view01WalkBarContainerWidth: NSLayoutConstraint!
    @IBOutlet var view01WalkCountLbl: UILabel!
    @IBOutlet var view01WalkBar: UIView!
    
    @IBOutlet var view02FoodLbl: UILabel!
    @IBOutlet var view02FoodImg: UIImageView!
    @IBOutlet var view02FoodImgLbl: UILabel!
    
    @IBOutlet var view03WalkCountLbl: UILabel!
    @IBOutlet var view03WalkTextLble: UILabel!
    
    @IBOutlet var view03TodayView: UIView!
    @IBOutlet var view03DayBeforeView: UIView!
    @IBOutlet var view03TwoDaysAgoView: UIView!
    @IBOutlet var view03ThreeDaysAgoView: UIView!
    @IBOutlet var view03FourDaysAgoView: UIView!
    @IBOutlet var view03FiveDaysAgoView: UIView!
    @IBOutlet var view03SixDaysAgoView: UIView!
    
    @IBOutlet var view03TodayViewHeight: NSLayoutConstraint!
    @IBOutlet var view03DayBeforeViewHeight: NSLayoutConstraint!
    @IBOutlet var view03TwoDaysAgoVIewHeight: NSLayoutConstraint!
    @IBOutlet var view03ThreeDaysAgoVIewHeight: NSLayoutConstraint!
    @IBOutlet var view03FourDaysAgoVIewHeight: NSLayoutConstraint!
    @IBOutlet var view03FiveDaysAgoVIewHeight: NSLayoutConstraint!
    @IBOutlet var view03SixDaysAgoVIewHeight: NSLayoutConstraint!
    
    @IBOutlet var view03TodayLbl: UILabel!
    @IBOutlet var view03DayBeforeLbl: UILabel!
    @IBOutlet var view03TwoDaysAgoLbl: UILabel!
    @IBOutlet var view03ThreeDaysAgoLbl: UILabel!
    @IBOutlet var view03FourDaysAgoLbl: UILabel!
    @IBOutlet var view03FiveDaysAgoLbl: UILabel!
    @IBOutlet var view03SixDaysAgoLbl: UILabel!
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //이전 화면에서 넘어온 값들
    var walkCountDateValue = 10
    var walkCountValue = ""
    //이전 화면에서 넘어온 값들
    var todayWalkCountVelue = ""
    var stepCountVelueDayBefore = ""
    var stepCountVelueTwoDaysAgo = ""
    var stepCountVelueThreeDaysAgo = ""
    var stepCountVelueFourDaysAgo = ""
    var stepCountVelueFiveDaysAgo = ""
    var stepCountVelueSixDaysAgo = ""
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        LoadingHUD.show()
        
        //view01디자인 세팅
        view01Set()
        //view02 세팅
        view02Set()
        //view03 세팅
        view03Set()
     
        LoadingHUD.hide()
    }
    
    //MARK: view01 세팅
    func view01Set() {
        view01WalkCountLbl.text = walkCountValue
        
        view01WalkBar.layer.cornerRadius = 3
        view01WalkBar.layer.masksToBounds = false
        view01WalkBar.layer.backgroundColor = UIColor().mainColorOrange.cgColor
        view01TextSet()
    }
    
    //view01텍스트 세팅
    func view01TextSet() {
        let format = DateFormatter() // date <-> string
        format.dateFormat = "yyyy년 MM월 dd일"
        if walkCountDateValue == 10 {
            let dateSet = format.string(from: Date())
            view01DateLbl.text = "\(dateSet) 오늘 동안 총"
        } else if walkCountDateValue == 0 {
            let dateSet = format.string(from: Date().dayBefore)
            view01DateLbl.text = "\(dateSet) 어제 동안 총"
        } else if walkCountDateValue == 1 {
            let dateSet = format.string(from: Date().twoDaysAgo)
            view01DateLbl.text = "\(dateSet) 그저께 동안 총"
        } else if walkCountDateValue == 2 {
            let dateSet = format.string(from: Date().threeDaysAgo)
            view01DateLbl.text = "\(dateSet) 동안 총"
        } else if walkCountDateValue == 3 {
            let dateSet = format.string(from: Date().fourDaysAgo)
            view01DateLbl.text = "\(dateSet) 동안 총"
        } else if walkCountDateValue == 4 {
            let dateSet = format.string(from: Date().fiveDaysAgo)
            view01DateLbl.text = "\(dateSet) 동안 총"
        } else if walkCountDateValue == 5 {
            let dateSet = format.string(from: Date().sixDaysAgo)
            view01DateLbl.text = "\(dateSet) 동안 총"
        }
    }
    
    //MARK: view02 세팅
    func view02Set() {
        let walkCountValueInt = Int(walkCountValue) ?? 0
        if walkCountValueInt >= 1175 && walkCountValueInt < 2655 {
            view02TextLblSet(text: "귤1개(39칼로리)", imgText: "귤1개(100g 기준)", imgNamed: "food_tangerine")
        } else if walkCountValueInt >= 2655 && walkCountValueInt < 5150 {
            view02TextLblSet(text: "바나나1개(88칼로리)", imgText: "바나나1개 100g 기준", imgNamed: "food_banana")
        } else if walkCountValueInt >= 5150 && walkCountValueInt < 10000 {
            view02TextLblSet(text: "사과3개(171칼로리)", imgText: "사과3개(150g 기준)", imgNamed: "food_apple")
        } else if walkCountValueInt >= 10000 {
            view02TextLblSet(text: "밥한공기(330칼로리)", imgText: "밥한공기(264g 기준)", imgNamed: "food_rice")
        } else {
            view02TextLblSet(text: "공기(0칼로리)", imgText: "공기(0g 기준)", imgNamed: "food_air")
        }
    }
    
    //view02텍스트라벨 세팅
    func view02TextLblSet(text: String, imgText: String, imgNamed: String) {
        view02FoodLbl.text = text
        view02FoodImgLbl.text = imgText
        view02FoodImg.image = UIImage(named: imgNamed)
    }
    
    //MARK: view03 세팅
    func view03Set() {
        view03TextSet()
        view03titleSet()
        
        view03TodayView.layer.cornerRadius = 3
        view03TodayView.layer.masksToBounds = false
        view03DayBeforeView.layer.cornerRadius = 3
        view03DayBeforeView.layer.masksToBounds = false
        view03TwoDaysAgoView.layer.cornerRadius = 3
        view03TwoDaysAgoView.layer.masksToBounds = false
        view03ThreeDaysAgoView.layer.cornerRadius = 3
        view03ThreeDaysAgoView.layer.masksToBounds = false
        view03FourDaysAgoView.layer.cornerRadius = 3
        view03FourDaysAgoView.layer.masksToBounds = false
        view03FiveDaysAgoView.layer.cornerRadius = 3
        view03FiveDaysAgoView.layer.masksToBounds = false
        view03SixDaysAgoView.layer.cornerRadius = 3
        view03SixDaysAgoView.layer.masksToBounds = false
        
        let colorAAA = UIColor().textColorAAAAAA
        let mainColor = UIColor().mainColorOrange
        
        if walkCountDateValue == 10 {
            chartViewSet(TodayView: mainColor, DayBeforeView: colorAAA, TwoDaysAgoVIew: colorAAA, ThreeDaysAgoVIew: colorAAA, FourDaysAgoVIew: colorAAA, FiveDaysAgoVIew: colorAAA, SixDaysAgoVIew: colorAAA)
        } else if walkCountDateValue == 0 {
            chartViewSet(TodayView: colorAAA, DayBeforeView: mainColor, TwoDaysAgoVIew: colorAAA, ThreeDaysAgoVIew: colorAAA, FourDaysAgoVIew: colorAAA, FiveDaysAgoVIew: colorAAA, SixDaysAgoVIew: colorAAA)
        } else if walkCountDateValue == 1 {
            chartViewSet(TodayView: colorAAA, DayBeforeView: colorAAA, TwoDaysAgoVIew: mainColor, ThreeDaysAgoVIew: colorAAA, FourDaysAgoVIew: colorAAA, FiveDaysAgoVIew: colorAAA, SixDaysAgoVIew: colorAAA)
        } else if walkCountDateValue == 2 {
            chartViewSet(TodayView: colorAAA, DayBeforeView: colorAAA, TwoDaysAgoVIew: colorAAA, ThreeDaysAgoVIew: mainColor, FourDaysAgoVIew: colorAAA, FiveDaysAgoVIew: colorAAA, SixDaysAgoVIew: colorAAA)
        } else if walkCountDateValue == 3 {
            chartViewSet(TodayView: colorAAA, DayBeforeView: colorAAA, TwoDaysAgoVIew: colorAAA, ThreeDaysAgoVIew: colorAAA, FourDaysAgoVIew: mainColor, FiveDaysAgoVIew: colorAAA, SixDaysAgoVIew: colorAAA)
        } else if walkCountDateValue == 4 {
            chartViewSet(TodayView: colorAAA, DayBeforeView: colorAAA, TwoDaysAgoVIew: colorAAA, ThreeDaysAgoVIew: colorAAA, FourDaysAgoVIew: colorAAA, FiveDaysAgoVIew: mainColor, SixDaysAgoVIew: colorAAA)
        } else if walkCountDateValue == 5 {
            chartViewSet(TodayView: colorAAA, DayBeforeView: colorAAA, TwoDaysAgoVIew: colorAAA, ThreeDaysAgoVIew: colorAAA, FourDaysAgoVIew: colorAAA, FiveDaysAgoVIew: colorAAA, SixDaysAgoVIew: mainColor)
        }
    }
    
    //view03텍스트 세팅
    func view03TextSet() {
        let format = DateFormatter() // date <-> string
        format.dateFormat = "MM.dd"
        view03TodayLbl.text = format.string(from: Date())
        view03DayBeforeLbl.text = format.string(from: Date().dayBefore)
        view03TwoDaysAgoLbl.text = format.string(from: Date().twoDaysAgo)
        view03ThreeDaysAgoLbl.text = format.string(from: Date().threeDaysAgo)
        view03FourDaysAgoLbl.text = format.string(from: Date().fourDaysAgo)
        view03FiveDaysAgoLbl.text = format.string(from: Date().fiveDaysAgo)
        view03SixDaysAgoLbl.text = format.string(from: Date().sixDaysAgo)
        
       
    }
    //view03타이틀 세팅
    func view03titleSet() {
        let walkCountToday = Int(todayWalkCountVelue) ?? 0
        let walkCount01 = Int(stepCountVelueDayBefore) ?? 0
        let walkCount02 = Int(stepCountVelueTwoDaysAgo) ?? 0
        let walkCount03 = Int(stepCountVelueThreeDaysAgo) ?? 0
        let walkCount04 = Int(stepCountVelueFourDaysAgo) ?? 0
        let walkCount05 = Int(stepCountVelueFiveDaysAgo) ?? 0
        let walkCount06 = Int(stepCountVelueSixDaysAgo) ?? 0
        
        let WalkCountAverage = (walkCountToday + walkCount01 + walkCount02 + walkCount03 + walkCount04 + walkCount05 + walkCount06) / 7
        
        
        if walkCountDateValue == 10 {
            walkCountDateValueCal(WalkCountAverage: WalkCountAverage, WalkCountValue: walkCountToday)
        } else if walkCountDateValue == 0 {
            walkCountDateValueCal(WalkCountAverage: WalkCountAverage, WalkCountValue: walkCount01)
        } else if walkCountDateValue == 1 {
            walkCountDateValueCal(WalkCountAverage: WalkCountAverage, WalkCountValue: walkCount02)
        } else if walkCountDateValue == 2 {
            walkCountDateValueCal(WalkCountAverage: WalkCountAverage, WalkCountValue: walkCount03)
        } else if walkCountDateValue == 3 {
            walkCountDateValueCal(WalkCountAverage: WalkCountAverage, WalkCountValue: walkCount04)
        } else if walkCountDateValue == 4 {
            walkCountDateValueCal(WalkCountAverage: WalkCountAverage, WalkCountValue: walkCount05)
        } else if walkCountDateValue == 5 {
            walkCountDateValueCal(WalkCountAverage: WalkCountAverage, WalkCountValue: walkCount06)
        }
    }
    
    //걸음수 평균 비교 계산 함수
    func walkCountDateValueCal(WalkCountAverage: Int, WalkCountValue: Int) {
        if WalkCountAverage < WalkCountValue {
            view03WalkCountLbl.text = "\(WalkCountValue - WalkCountAverage)"
            view03WalkTextLble.text = "더 높아요!"
        } else {
            view03WalkCountLbl.text = "\(WalkCountAverage - WalkCountValue)"
            view03WalkTextLble.text = "낮아요..."
        }
    }
    
    
    //차트 개별 뷰 생상 세팅
    func chartViewSet(TodayView: UIColor, DayBeforeView: UIColor, TwoDaysAgoVIew: UIColor, ThreeDaysAgoVIew: UIColor, FourDaysAgoVIew: UIColor, FiveDaysAgoVIew: UIColor, SixDaysAgoVIew: UIColor) {
        view03TodayView.backgroundColor  = TodayView
        view03DayBeforeView.backgroundColor  = DayBeforeView
        view03TwoDaysAgoView.backgroundColor  = TwoDaysAgoVIew
        view03ThreeDaysAgoView.backgroundColor  = ThreeDaysAgoVIew
        view03FourDaysAgoView.backgroundColor  = FourDaysAgoVIew
        view03FiveDaysAgoView.backgroundColor  = FiveDaysAgoVIew
        view03SixDaysAgoView.backgroundColor  = SixDaysAgoVIew
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        //걸음수 바 애니매이션 함수
        walkBarWightTransition()
        //차트 바 애니매이션 함수
        chartTransition() 
    }
    
    //걸음수 바 애니매이션 함수
    func walkBarWightTransition() {
        
        //걸음수
        var walkCount = Double(walkCountValue) ?? 0.0
        if walkCount > 10000.0 {
            walkCount = 10000.0
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
            self.view01WalkBarContainerWidth.constant = 16
            //애니메이션 동작
            UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut) {
                self.view01WalkBarContainerWidth.constant = CGFloat(walkBarContainerWidthPercent)
                self.view.layoutIfNeeded()
            }.startAnimation()
        }
    }
    
    //차트 바 애니매이션 함수
    func chartTransition() {
       
        //딜레이 0.4초
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            //애니메이션 준비
            self.view.layoutIfNeeded()
            
            self.view03TodayViewHeight.constant = 6
            self.view03DayBeforeViewHeight.constant = 6
            self.view03TwoDaysAgoVIewHeight.constant = 6
            self.view03ThreeDaysAgoVIewHeight.constant = 6
            self.view03FourDaysAgoVIewHeight.constant = 6
            self.view03FiveDaysAgoVIewHeight.constant = 6
            self.view03SixDaysAgoVIewHeight.constant = 6
            
            //애니메이션 동작
            UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut) {
                self.view03TodayViewHeight.constant = CGFloat(self.charViewHeightPercent(value: self.todayWalkCountVelue))
                self.view03DayBeforeViewHeight.constant = CGFloat(self.charViewHeightPercent(value: self.stepCountVelueDayBefore))
                self.view03TwoDaysAgoVIewHeight.constant = CGFloat(self.charViewHeightPercent(value: self.stepCountVelueTwoDaysAgo))
                self.view03ThreeDaysAgoVIewHeight.constant = CGFloat(self.charViewHeightPercent(value: self.stepCountVelueThreeDaysAgo))
                self.view03FourDaysAgoVIewHeight.constant = CGFloat(self.charViewHeightPercent(value: self.stepCountVelueFourDaysAgo))
                self.view03FiveDaysAgoVIewHeight.constant = CGFloat(self.charViewHeightPercent(value: self.stepCountVelueFiveDaysAgo))
                self.view03SixDaysAgoVIewHeight.constant = CGFloat(self.charViewHeightPercent(value: self.stepCountVelueSixDaysAgo))
                self.view.layoutIfNeeded()
            }.startAnimation()
        }
    }
    
    //charViewHeightCGFloat 내용
    func charViewHeightPercent(value: String) -> Double {
        //걸음수 당 퍼센트 공식:  전체 * 걸음수 * 0.01
        var chartViewHeightPercent = 172.0 * Double(view03WalkCount(walkCountValue: value)) * 0.01
        if chartViewHeightPercent <= 6 {
            chartViewHeightPercent = 6
        }
        return chartViewHeightPercent
    }
    
    //걸음수 값 세팅
    func view03WalkCount(walkCountValue: String) -> Double {
        //걸음수
        var walkCount = Double(walkCountValue) ?? 0.0
        if walkCount > 10000.0 {
            walkCount = 10000.0
        }
        walkCount = walkCount * 0.01
        return walkCount
    }
    
}
