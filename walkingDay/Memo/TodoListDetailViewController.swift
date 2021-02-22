//
//  TosViewController.swift
//  LoginTest
//
//  Created by HongInJun on 2020/11/11.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import RealmSwift

class TodoListDetailViewController: UIViewController {
    
    @IBOutlet var titleDateLbl: UILabel!
    @IBOutlet var categoryImg: UIImageView!
    @IBOutlet var categoryTf: UITextField!
    @IBOutlet var categoryAction: SubViewBackgroundDesign!
    @IBOutlet var titleTf: UITextField!
    @IBOutlet var memoTv: UITextView!
    @IBOutlet var timeStart: UILabel!
    @IBOutlet var timeEnd: UILabel!
    @IBOutlet var fullTime: UILabel!
    @IBOutlet var saveBtn: DefaultBtn!
    
    @IBAction func titleTextAction(_ sender: UIButton) {
        saveBtnOn()
    }
    
    @IBAction func timeStartAction(_ sender: UIButton) {
        timeStart.textColor = UIColor.darkGray
        naviToPopUpView(timeStart, titleText: "시작시간")
    }
    
    @IBAction func timeEndAction(_ sender: UIButton) {
        timeEnd.textColor = UIColor.darkGray
        naviToPopUpView(timeEnd, titleText: "끝나는 시간")
    }
    
    //테이블에서 넘어올 값 변수 선언
    var categoryText = ""
    var titleText = ""
    var memoText = ""
    var cellIndex = 0
    var tableSection = 0
    
    //타임 데이터 초기값
    var timeStartValue = "13:00"
    var timeEndValue = "14:00"
    
    //날짜 데이터 초기값
    var calenderDate = ""
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //디자인 세팅
        designSet()
        //MARK: PopUpPickerView으로 이동
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(categoryActionTapped))
        categoryAction.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func categoryActionTapped(sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "PopupView", bundle: nil)
        guard let navi = sb.instantiateViewController(withIdentifier: "PopupPickerViewController") as? PopupPickerViewController else { return }
        navi.backingImage = self.view.asImage() //현재 화면 캡쳐 이미지
        navi.categoryVlaue = categoryTf.text ?? ""
        navi.categoryVlaueResult = categoryTf.text ?? ""
        navi.titleTfText = titleTf.text ?? ""
        navi.memoText = memoTv.text!
        self.navigationController?.pushViewController(navi, animated: false)
    }
    
    //디자인 세팅
    func designSet() {
        //제목 날짜 세팅
        currntDateSetting()
        titleDateLbl.text = calenderDate
        titleDateLbl.font = UIFont().semibold18
        categoryTf.font = UIFont().semibold16
        titleTf.font = UIFont().semibold16
        timeStart.font = UIFont().regular14
        timeStart.textColor = UIColor().textColorAAAAAA
        timeEnd.font = UIFont().regular14
        timeEnd.textColor = UIColor().textColorAAAAAA
        fullTime.font = UIFont().regular14
        fullTime.textColor = UIColor().textColorAAAAAA
        saveBtn.titleLabel?.font = UIFont().bold15
        saveBtn.titleLabel?.textColor = UIColor.white
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.backgroundColor = UIColor().mainColorOrange
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingHUD.show()
        //TextView Place Holder 첫번째 로드
        placeholderSetting()
        //테이블에서 넘어온 값
        ValueFromTable()
        //데이터피커에서 넘어온 값
        timeValueFromPop()
        //피커뷰에서 넘어온 값
        pickerValueFromPop()
        //카테고리 이미지 세팅
        categoryImgSetting()
        //카테고리 텍스트필드 세팅
        categoryTfSetting()
        //카테고리 텍스트필드 세팅
        textViewSetting()
        LoadingHUD.hide()
    }
    
    //현재 날짜
    func currntDateSetting() {
        let format = DateFormatter() // date <-> string
        format.dateFormat = "yyyy-MM-dd"
        let currentDate = format.string(from: Date())
        if self.calenderDate == "" {
            calenderDate = currentDate
        }
    }
    
    //테이블에서 넘어온 값
    func ValueFromTable() {
        if tableSection == 0 {
            categoryTf.text = self.categoryText
            titleTf.text = self.titleText
            memoTv.text = self.memoText
            saveBtn.setTitle("수정", for: UIControl.State.normal)
        }
    }
    
    //MARK: PopUpDatePickerView데이터피커에서 넘어온 값
    func timeValueFromPop() {
        NotificationCenter.default.addObserver(self, selector: #selector(PopupDatePickerViewControllerDateReceived), name: NSNotification.Name("PopupDatePickerViewControllerDateReceived"), object: nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        //문자열을 데이트로 변환
        let timeS = dateFormatter.date(from: timeStartValue)
        let timeE = dateFormatter.date(from: timeEndValue)
        //시작부터 끝나는 시간을 초 단위 인트로로 변환
        var useTime = Int(timeE!.timeIntervalSince(timeS!))
        
        if useTime <= 0 {
            let message = "시작 시간과 끝나는 시간을 확인해주세요."
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            let timeSPlusHour = Date(timeInterval: 3600, since: timeS!) //시작 시간에서 한시간 더한 시간
            timeStart.text = timeStartValue
            timeEnd.text = dateFormatter.string(from: timeSPlusHour) //데이터 포맷을 이용하여 데이트를 문자열로 변환
            //fullTime의 문자열 실행 함수
            useTime = Int(timeSPlusHour.timeIntervalSince(timeS!))
            fullTimeCalc(useTime)
            
        } else {
            timeStart.text = timeStartValue
            timeEnd.text = timeEndValue
            //fullTime의 문자열 실행 함수
            fullTimeCalc(useTime)
        }
    }
    
    @objc func PopupDatePickerViewControllerDateReceived(data : NSNotification) {
        let timeStartValueResult = data.userInfo!["timeStartValueResult"] as! String
        let timeEndValueResult = data.userInfo!["timeEndValueResult"] as! String
        let titleTfText = data.userInfo!["titleTfText"] as! String
        let textViewText = data.userInfo!["textViewText"] as! String
        timeStartValue = timeStartValueResult
        timeEndValue = timeEndValueResult
        titleText = titleTfText
        memoText = textViewText
        saveBtnOn()
    }
    
    //시간 계산
    func fullTimeCalc(_ useTime: Int) {
        if (useTime/60)/60 <= 0 {
            fullTime.text = "\((useTime/60)%60)분"
        } else if (useTime/60)%60 <= 0 {
            fullTime.text = "\((useTime/60)/60)시간"
        } else {
            fullTime.text = "\((useTime/60)/60)시간\((useTime/60)%60)분"
        }
    }
    
    //MARK: PopUpPickerView데이터피커에서 넘어온 값
    func pickerValueFromPop() {
        NotificationCenter.default.addObserver(self, selector: #selector(PopupPickerViewControllerDateReceived), name: NSNotification.Name("PopupPickerViewControllerDateReceived"), object: nil)
    }
    
    @objc func PopupPickerViewControllerDateReceived(data : NSNotification) {
        let categoryList = data.userInfo!["categoryList"] as! String
        let titleTfText = data.userInfo!["titleTfText"] as! String
        let textViewText = data.userInfo!["textViewText"] as! String
        print(categoryList)
        categoryText = categoryList
        titleText = titleTfText
        memoText = textViewText
        saveBtnOn()
    }
    
    //카테고리 이미지 세팅 함수
    func categoryImgSetting() {
        if categoryText == "유산소 운동" {
            self.categoryImg.image = UIImage(named: "category1")
            categoryImg.isHidden = false
        } else if categoryText == "무산소 운동" {
            categoryImg.image = UIImage(named: "category2")
            categoryImg.isHidden = false
        } else {
            categoryImg.isHidden = true
        }
    }
    
    //카테고리 텍스트필드 세팅
    func categoryTfSetting() {
        categoryTf.text = categoryText
    }
    
    //카테고리 텍스트필드 세팅
    func textViewSetting() {
        memoTv.text = memoText
        memoTv.textColor = UIColor.black
        saveBtnOn() 
        textViewDidEndEditing(memoTv)
    }
    
    //버튼 비활성화, 활성화
    func saveBtnOn() {
        if titleTf.text?.isEmpty == true || memoTv.text == "내용을 입력해주세요." || categoryTf.text?.isEmpty == true  {
            saveBtn.isOn = .Off
        } else {
            saveBtn.isOn = .On
        }
    }
    
    //MARK: PopUpDatePickerView으로 이동 함수
    func naviToPopUpView(_ text: UILabel, titleText: String) {
        timeEnd.textColor = UIColor.darkGray
        let sb = UIStoryboard(name: "PopupView", bundle: nil)
        guard let navi = sb.instantiateViewController(withIdentifier: "PopupDatePickerView") as? PopupDatePickerViewController else { return }
        navi.backingImage = self.view.asImage() //현재 화면 캡쳐 이미지
        navi.timeVlaue = text.text!
        navi.timeStartValue = timeStart.text!
        navi.timeEndValue = timeEnd.text!
        navi.timeStartValueResult = timeStart.text!
        navi.timeEndValueResult = timeEnd.text!
        navi.popupTitleText = titleText
        navi.titleTfText = titleTf.text ?? ""
        navi.memoText = memoTv.text!
        self.navigationController?.pushViewController(navi, animated: false)
        saveBtnOn()
    }
    
    //MARK: 저장 및 수정 버튼
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        //Todo 태스크 추가
        let category = categoryTf.text
        let title = titleTf.text
        let timeStart = self.timeStart.text
        let timeEnd = self.timeEnd.text
        let memo = memoTv.text
        let calenderDate  = self.calenderDate
        let memoIndexPathRow = self.cellIndex

        //Todo, TodoDate 생성 밑 업데이트
        if tableSection == 0 { //섹션0
            //메모 수정
            MemoListManager.shared.memoUpdate(memoList: MemoListManager.shared.memoListFilter(calenderDate: calenderDateSet(calenderDate)), memoIndexPathRow: memoIndexPathRow, category: category!, title: title!, timeStart: timeStart!, timeEnd: timeEnd!, memo: memo!)
        } else { //섹션1
            //메모 생성
            MemoListManager.shared.memoInsert(category: category!, title: title!, timeStart: timeStart!, timeEnd: timeEnd!, memo: memo!, calenderDate: calenderDate)
        }
        //리셋
        reset()
        //키보드 내리기
        self.view.endEditing(true)
        //전 네이게이션 페이지로 이동
        navigationController?.popViewController(animated: true)
    }
    
    func reset() {
        //텍스트 필드 초기화
        categoryTf.text = ""
        titleTf.text = ""
        memoTv.text = ""
        //timeStartValue, timeEndValue 초기화
        timeStartValue = "13:00"
        timeEndValue = "14:00"
    }
    
    //페이지 닫기
    @IBAction func closeBtn(_ sender: UIButton) {
        //timeStartValue, timeEndValue 초기화
        timeStartValue = "13:00"
        timeEndValue = "14:00"
        navigationController?.popViewController(animated: true)
    }
  
    //BG 탭했을때, 키보드 내려오게 하기
    @IBAction func tapBG(_ sender: UIButton) {
        self.view.endEditing(true)
    }
}

//MARK: 텍스트뷰 구현
extension TodoListDetailViewController: UITextViewDelegate {
    
    //TextView Place Holder 첫번째 로드
    func placeholderSetting() {
        memoTv.delegate = self // textView가 유저가 선언한 outlet
        memoTv.text = "내용을 입력해주세요."
        memoTv.textColor = UIColor.lightGray
        saveBtnOn()
    }
    
    //TextView Place Holder 입력했을때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = self.memoText
            textView.textColor = UIColor.black
            saveBtnOn()
        }
    }
    
    //TextView Place Holder 값이 없을때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요."
            textView.textColor = UIColor.lightGray
            saveBtnOn()
        }
    }
}
