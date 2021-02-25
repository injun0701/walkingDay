//
//  LocationListViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/23.
//

class LocationListViewController: UIViewController {

    @IBOutlet var locationListTableView: UITableView!
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //현재 주소 도시값
    var currentLocationValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSet()
    }
    
    //테이블뷰 세팅
    func tableViewSet() {
        locationListTableView.delegate = self
        locationListTableView.dataSource = self
        locationListTableView.separatorStyle = .none
        locationListTableView.register(UINib(nibName: "LocationListTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationListTableViewCell")
        locationListTableView.register(UINib(nibName: "TodoInsertTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoInsertTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        locationListTableView.reloadData()
    }
}

//MARK: 테이블뷰 구현
extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return LocationDbManager.shared.locationList()?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if indexPath.section == 0 {
            //셀 클래스 선언
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTableViewCell", for: indexPath) as? LocationListTableViewCell else {
                return UITableViewCell()
            }
            let cellList = LocationDbManager.shared.locationList()[indexPath.row]
            
            if cellList.isChecked == true {
                cell.starBtn.setImage(UIImage(named: "star_fill"), for: UIControl.State.normal)
            } else {
                cell.starBtn.setImage(UIImage(named: "star_line"), for: UIControl.State.normal)
            }
            
            cell.titleLbl.text = cellList.provinces
            if indexPath.row == 0 {
                cell.contentLbl.text = currentLocationValue
                cell.deleteBtn.isHidden = true
            } else {
                cell.contentLbl.text = cellList.city
                cell.deleteBtn.isHidden = false
            }
            
            //starButtonTapHandler 작성
            cell.starButtonTapHandler = {
                let ad = UIApplication.shared.delegate as? AppDelegate
                if LocationDbManager.shared.locationIdCheckIndex() == indexPath.row {
                    ad?.checkCityChange = false
                } else {
                    ad?.checkCityChange = true
                }
                for i in 0..<LocationDbManager.shared.locationList()!.count {
                    LocationDbManager.shared.locationListCheckUpdate(LocationListIndexPathRow: i, isChecked: false)
                }
                LocationDbManager.shared.locationListCheckUpdate(LocationListIndexPathRow: indexPath.row, isChecked: true)
                self.locationListTableView.reloadData()
               
            }
            
            //deleteButtonHandler 작성
            cell.deleteButtonTapHandler = {
                if cellList.isChecked == true {
                    self.showAlertBtn1(title: "리스트 삭제 오류", message: "체크된 리스트는 삭제하실 수 없습니다.", btnTitle: "확인") {}
                } else {
                    //레코드 삭제
                    LocationDbManager.shared.locationListDelete(LocationListIndexPathRow: indexPath.row)
                    self.locationListTableView.reloadData()
                }
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
        guard let navi = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearchViewController") as? LocationSearchViewController else { return }
        
        if indexPath.section == 0 {
            if indexPath.row != 0 {
                let cellList = LocationDbManager.shared.locationList()[indexPath.row]
                //테이블의 값을 네비로 다음 클래스에 넘기기
                navi.titleText = cellList.provinces
                navi.contentText = cellList.city
                navi.cellIndex = indexPath.row
                navi.tableSection = indexPath.section
                self.navigationController?.pushViewController(navi, animated: true)
            }
        } else {
            //테이블의 값을 네비로 다음 클래스에 넘기기
            navi.tableSection = indexPath.section
            self.navigationController?.pushViewController(navi, animated: true)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
