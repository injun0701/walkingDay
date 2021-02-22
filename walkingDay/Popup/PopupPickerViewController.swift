//
//  PopupPickerViewViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/15.
//

import UIKit

class PopupPickerViewController: UIViewController {
    //전 화면 캡쳐 이미지
    @IBOutlet var backingImageView: UIImageView!
    var backingImage: UIImage?
    //투명한 검정 배경
    @IBOutlet var bgBlackView: UIView!
    @IBOutlet var popupTitleLbl: UILabel!
    @IBOutlet var categoryPv: UIPickerView!
    @IBOutlet var backgroundWhiteView: NSLayoutConstraint!
    @IBOutlet var saveBtn: UIButton!
    
    //전 페이지에서 넘어온 값
    var categoryVlaue = ""
    var categoryVlaueResult = ""
    var titleTfText = ""
    var memoText = ""
    
    var categoryList = ["유산소 운동", "무산소 운동", "기타"]
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //로드 전 세팅
        viewDidLoadSet()
        disignSet()
        //backgroundView 터치 이벤트
        backgroundBlackViewAddGestureRecognizer()
    }
    
    func viewDidLoadSet() {
        //전 화면 캡쳐 이미지
        backingImageView.image = backingImage
 
        categoryPv.delegate = self
        categoryPv.dataSource = self
        
        popupTitleLbl.font = UIFont().semibold18
        categoryVlaueResult = "유산소 운동"
    }
    
    func disignSet() {
        popupTitleLbl.font = UIFont().semibold18
        saveBtn.titleLabel?.font = UIFont().bold15
        saveBtn.titleLabel?.textColor = UIColor.white
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.backgroundColor = UIColor().mainColorOrange
    }
    
    //MARK: 데이터 저장 및 저장 버튼
    @IBAction func savePickerViewBtnAction(_ sender: UIButton) {
        dataPost()
        closePage()
    }
    
    //페이지 닫기
    @IBAction func closeBtn(_ sender: UIButton) {
        valueBack() 
        dataPost()
        closePage()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        backgroundViewTransition()
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
    
    //피커뷰 바뀐값 취소하는 함수
    func valueBack() {
        categoryVlaueResult = categoryVlaue
    }
    
    //데이터 전달 함수
    func dataPost() {
        if memoText == "내용을 입력해주세요." {
            memoText = ""
        }
        //"PopupPickerViewControllerDateReceived"이란 이름을 지닌 NotificationCenter으로 데이터 전송
        NotificationCenter.default.post(name: NSNotification.Name("PopupPickerViewControllerDateReceived"), object: self, userInfo: ["categoryList": categoryVlaueResult, "titleTfText": titleTfText, "textViewText": memoText])
    }
    
    //백그라운드 트랜지션
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
        //백그라운드 트랜지션
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

//MARK: 피커뷰 구현
extension PopupPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //데이터피커 열
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //데이터피커 행
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    //데이터피커 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    //선택시 액션
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryVlaueResult = categoryList[row]
    }
}
