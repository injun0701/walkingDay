//
//  SettingsViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/27.
//

class SettingsViewController: UIViewController {

    @IBOutlet var sattingTableView: UITableView!
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func hambergerMenuBtnAction(_ sender: UIButton) {
        toMenuBtnAction()
    }
    
    var settings : [String] = []
    let locationSetting = "위치 설정"
    let questionSetting = "문의/앱 버전"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableViewSet()
        settingTableViewData()
    }

    //테이블뷰 세팅
    func settingTableViewSet() {
        sattingTableView.delegate = self
        sattingTableView.dataSource = self
        sattingTableView.separatorStyle = .none
        sattingTableView.register(UINib(nibName: "SingleTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleTableViewCell")
    }
    //테이블뷰 데이터 세팅
    func settingTableViewData() {
        settings = [locationSetting, questionSetting]
    }
}

//MARK: 테이블뷰 구현
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTableViewCell", for: indexPath) as? SingleTableViewCell else {
            return UITableViewCell()
        }
        cell.leftImgView.isHidden = true
        cell.contentLbl.isHidden = true
        cell.titleLbl.text = settings[indexPath.row]
        cell.rightImgView.image = UIImage(named: "arrow_right")
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settings[indexPath.row] == locationSetting {
            let sb = UIStoryboard(name: "Location", bundle: nil)
            guard let navi = sb.instantiateViewController(withIdentifier: "LocationListViewController") as? LocationListViewController else { return }
            self.navigationController?.pushViewController(navi, animated: false)
            
        } else if  settings[indexPath.row] == questionSetting  {
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            guard let navi = sb.instantiateViewController(withIdentifier: "SettingsDetailViewController") as? SettingsDetailViewController else { return }
            self.navigationController?.pushViewController(navi, animated: false)
                
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
