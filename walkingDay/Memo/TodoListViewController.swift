//
//  TosViewController.swift
//  LoginTest
//
//  Created by HongInJun on 2020/11/11.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import FSCalendar
import RealmSwift

class TodoListViewController: UIViewController {

    @IBOutlet var calender: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewBottom: NSLayoutConstraint!
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func hambergerMenuBtnAction(_ sender: UIButton) {
        toMenuBtnAction()
    }
    
    let realm = try! Realm()
 
    //날짜 데이터 초기값
    var calenderDate = ""
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        LoadingHUD.show()
        //테이블뷰 세팅
        tableViewSet()
        //아이폰x 이상 오토레이아웃 변경
        autolayout()
        //달력 위, 아래 스와이핑
        calenderAddGestureRecognizer()
        //달력 디자인
        calenderDesign()
        tableView.reloadData()
        calender.reloadData()
        LoadingHUD.hide()
    }
    
    //테이블뷰 세팅
    func tableViewSet() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoTableViewCell")
        tableView.register(UINib(nibName: "TodoInsertTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoInsertTableViewCell")
    }
    
    //아이폰x 이상 오토레이아웃 변경
    func autolayout() {
        let screenBounds = UIScreen.main.bounds
        let screenHeight = screenBounds.size.height
        if screenHeight >= 812 { //아이폰x 이상
            tableViewBottom.constant = 34
        }
    }
    
}

//MARK: 달력 구현
extension TodoListViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    //높이값 설정
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    //달력 위, 아래 스와이핑
    func calenderAddGestureRecognizer() {
        let swipUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer (
                    target: self,
                    action: #selector (TodoListViewController.respondToSwipeGesture))
        swipUpGesture.direction = .up
        let swipDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer (
                    target: self,
                    action: #selector (TodoListViewController.respondToSwipeGesture))
        swipDownGesture.direction = .down
        //달력에 변수 추가
        calender.addGestureRecognizer(swipUpGesture)
        calender.addGestureRecognizer(swipDownGesture)
    }
    
    //달력 위, 아래 스와이핑 함수
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        // 만일 제스쳐가 있다면
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            // 위, 아래의 스와이프 이벤트
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.up :
                    print ("swiped up")
                    calender.setScope (.week, animated: true)
                case UISwipeGestureRecognizer.Direction.down :
                    print ("swiped down")
                    calender.setScope (.month, animated: true)
                default:
                    break
            }
        }
    }
    
    //캘랜더 클릭시 이벤트
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 날짜를 원하는 형식으로 저장하기 위한 방법입니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calenderDate = dateFormatter.string(from: date)
        self.calenderDate = calenderDate
        print(calenderDate)

        tableView.reloadData()
    }
    
    //캘랜더 메모 개수 표현
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //날짜 포맷
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
               
        //events배열 생성
        var events: [Date] = []
        let listDate = realm.objects(MemoList.self)
        for i in 0..<listDate.count {
            events.append(formatter.date(from:listDate[i].calenderDate)!)
        }

        //events배열에 중복값 카운트
        if events.contains(date) {
            var count = 0
            for i in 0..<events.count{
                if date == events[i] {
                    count = count + 1
                }
            }
            return count
        } else {
            return 0
        }
       
    }
   
    //요일 글자 수정 함수의 그룹, 년도 글자 수정 함수
    func calenderDesign() {
        //한글 처리
        calender.locale = Locale(identifier: "ko_KR")

        calender.appearance.headerDateFormat = "YYYY년 M월"
        calenderTitle(0, "일")
        calenderTitle(1, "월")
        calenderTitle(2, "화")
        calenderTitle(3, "수")
        calenderTitle(4, "목")
        calenderTitle(5, "금")
        calenderTitle(6, "토")
  
        calender.appearance.headerMinimumDissolvedAlpha = 0
        calender.appearance.headerTitleFont = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        calender.appearance.weekdayFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        calender.appearance.titleFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        calender.appearance.titleWeekendColor = UIColor(red: 140/255, green: 140/255, blue: 180/255, alpha: 1)
    }
    
    //요일 글자수정 함수
    func calenderTitle(_ weekTitleNum: Int,_ weekTitle: String) {
        calender.calendarWeekdayView.weekdayLabels[weekTitleNum].text = weekTitle
    }
    
}

//MARK: 테이블뷰 구현
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return MemoListManager.shared.memoListFilter(calenderDate: calenderDateSet(calenderDate))?.count ?? 0
            
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if indexPath.section == 0 {
            //셀 클래스 선언
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as? TodoTableViewCell else {
                return UITableViewCell()
            }
            
            let todo = MemoListManager.shared.memoListFilter(calenderDate: calenderDateSet(calenderDate))![indexPath.row]
            
            //TODO: 셀 업데이트 하기
            if todo.category == "유산소 운동" {
                cell.categoryImg.image = UIImage(named: "category1")
                cell.categoryImg.isHidden = false
            } else if todo.category == "무산소 운동" {
                cell.categoryImg.image = UIImage(named: "category2")
                cell.categoryImg.isHidden = false
            } else {
                cell.categoryImg.isHidden = true
            }
            cell.titleLbl.text = todo.title
            cell.memoLbl.text = todo.memo

            //timeLabel 텍스트
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            //문자열을 데이트로 변환
            let timeS = dateFormatter.date(from: todo.timeStart)
            let timeE = dateFormatter.date(from: todo.timeEnd)
            //시작부터 끝나는 시간을 초 단위 인트로로 변환
            let useTime = Int(timeE!.timeIntervalSince(timeS!))
            
            if (useTime/60)/60 <= 0 {
                cell.timeLbl.text = todo.timeStart + " ~ " + todo.timeEnd + "  \((useTime/60)%60)분"
            } else if (useTime/60)%60 <= 0 {
                cell.timeLbl.text = todo.timeStart + " ~ " + todo.timeEnd + "  \((useTime/60)/60)시간"
            } else {
                cell.timeLbl.text = todo.timeStart + " ~ " + todo.timeEnd + "  \((useTime/60)/60)시간\((useTime/60)%60)분"
            }
            
            //deleteButtonHandler 작성
            cell.deleteButtonTapHandler = {
                //레코드 삭제
                MemoListManager.shared.memoDelete(memoList: MemoListManager.shared.memoListFilter(calenderDate: self.calenderDateSet(self.calenderDate)), memoIndexPathRow: indexPath.row)
                self.calender.reloadData()
                self.tableView.reloadData()
            }
         
            //셀 삭제 알럿 델리게이트
            cell.delegate = self
            //셀 선택 스타일 논
            cell.selectionStyle = .none
            return cell
            
        } else {
            //셀 클래스 선언
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoInsertTableViewCell", for: indexPath) as? TodoInsertTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //네이게이션
        guard let navi = self.storyboard?.instantiateViewController(withIdentifier: "TodoListDetailViewController") as? TodoListDetailViewController else { return }
        
        if indexPath.section == 0 {
            let todo = MemoListManager.shared.memoListFilter(calenderDate: calenderDateSet(calenderDate))![indexPath.row]
            //테이블의 값을 네비로 다음 클래스에 넘기기
            navi.categoryText = todo.category
            navi.titleText = todo.title
            navi.memoText = todo.memo
            navi.timeStartValue = todo.timeStart
            navi.timeEndValue = todo.timeEnd
            //cellIndex는 Todo업데이트 할때 필요
            navi.cellIndex = indexPath.row
            navi.tableSection = indexPath.section
            navi.calenderDate = self.calenderDate
            
            self.navigationController?.pushViewController(navi, animated: true)
            
        } else {
            //테이블의 값을 네비로 다음 클래스에 넘기기
            navi.tableSection = indexPath.section
            navi.calenderDate = self.calenderDate
            self.navigationController?.pushViewController(navi, animated: true)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.section == 1 {
            height = 110
            return height
        }
        return UITableView.automaticDimension
    }
}
