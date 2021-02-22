//
//  PopUpView.swift
//  TodoList
//
//  Created by HongInJun on 2021/01/12.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

class PopupDatePickerViewController: UIViewController {
    //전 화면 캡쳐 이미지
    @IBOutlet var backingImageView: UIImageView!
    var backingImage: UIImage?
    //투명한 검정 배경
    @IBOutlet var bgBlackView: UIView!
    @IBOutlet var popupTitleLbl: UILabel!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var backgroundWhiteView: NSLayoutConstraint!
    @IBOutlet var saveBtn: UIButton!
    
    //전 페이지에서 넘어온 값
    var timeVlaue = ""
    var timeStartValue = "13:00"
    var timeEndValue = "14:00"
    var timeStartValueResult = "13:00"
    var timeEndValueResult = "14:00"
    var popupTitleText = ""
    var titleTfText = ""
    var memoText = ""
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //로드 전 세팅
        viewDidLoadSet()
        disignSet()
        //데이트피커 초기값
        datePickerInitialValue()
        //데이트피커 변경했을 때 감지
        datePickerAddTarget()
        //backgroundView 터치 이벤트
        backgroundBlackViewAddGestureRecognizer()
    }
    
    //로드 전 세팅
    func viewDidLoadSet() {
        //전 화면 캡쳐 이미지
        backingImageView.image = backingImage
        //타이틀 라벨
        popupTitleLbl.text = popupTitleText
    }
    
    func disignSet() {
        popupTitleLbl.font = UIFont().semibold18
        saveBtn.titleLabel?.font = UIFont().bold15
        saveBtn.titleLabel?.textColor = UIColor.white
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.backgroundColor = UIColor().mainColorOrange
    }
    
    //데이트피커 초기값
    func datePickerInitialValue() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        let date = dateFormatter.date(from: "\(timeVlaue)")
        timePicker.date = date!
    }
    
    //데이트피커 변경했을 때 감지
    func datePickerAddTarget() {
        timePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    //데이트피커 변경했을 때 함수
    @objc func datePickerChanged(picker: UIDatePicker) {
        let timeFormatter: DateFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if timeVlaue == timeStartValue {
            timeStartValueResult = timeFormatter.string(from: picker.date)
        } else {
            timeEndValueResult = timeFormatter.string(from: picker.date)
        }
    
    }
    
    //MARK: 데이터 저장 및 저장 버튼
    @IBAction func saveTimePickerBtnAction(_ sender: UIButton) {
        dataPost()
        closePage()
    }
    
    //페이지 닫기
    @IBAction func closeBtn(_ sender: UIButton) {
        valueBack()
        dataPost()
        closePage()
    }
    
    //backgroundBlackView 터치 이벤트
    func backgroundBlackViewAddGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        bgBlackView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //backgroundBlackView 터치 이벤트 함수
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        valueBack()
        dataPost()
        closePage()
    }
    
    //데이터 피커 바뀐값 취소하는 함수
    func valueBack() {
        timeStartValueResult = timeStartValue
        timeEndValueResult = timeEndValue
    }
    
    //데이터 전달 함수
    func dataPost() {
        if memoText == "내용을 입력해주세요." {
            memoText = ""
        }
        //"PopupDatePickerViewControllerDateReceived"이란 이름을 지닌 NotificationCenter으로 데이터 전송
        NotificationCenter.default.post(name: NSNotification.Name("PopupDatePickerViewControllerDateReceived"), object: self, userInfo: ["timeStartValueResult": timeStartValueResult, "timeEndValueResult": timeEndValueResult, "titleTfText": titleTfText, "textViewText": memoText])
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        backgroundViewTransition()
    }
    
    //백그라운드 시작 트랜지션
    private func backgroundViewTransition() {
        view.layoutIfNeeded()
        bgBlackView.alpha = 0
        backgroundWhiteView.constant = -424
        
        backgroundViewAlphaTransition(alpha: 0.2)
        UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            self.view.layoutIfNeeded()
            self.backgroundWhiteView.constant = 34
        }.startAnimation()
    }
    
    //백그라운드 알파값 트랜지션
    func backgroundViewAlphaTransition(alpha: Double) {
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            self.bgBlackView.alpha = CGFloat(alpha)
        }.startAnimation()
    }
    
    //페이지 닫기 함수
    func closePage() {
        //백그라운드 끝 트랜지션
        backgroundViewAlphaTransition(alpha: 0.0)
        UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            self.backgroundWhiteView.constant = 424
            self.view.layoutIfNeeded()
        }.startAnimation()
        //딜레이
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            //전 네이게이션 페이지로 이동
            self.navigationController?.popViewController(animated: false)
        }
    }
    
}
