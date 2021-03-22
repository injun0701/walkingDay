//
//  LocationSearchViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/23.
//

class LocationSearchViewController: UIViewController {
    
    @IBOutlet var cellCountLbl: UILabel!
    @IBOutlet var locationSearchTableView: UITableView!
    
    @IBOutlet var searchTf: UITextField!
    @IBOutlet var saveBtn: DefaultBtn!
    
    @IBAction func searchTfAction(_ sender: UITextField) {
        searchTfActionFunc()
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        let locationCityFilter = LocationDbManager.shared.locationList()?.filter("city == '\(cityValue)'")
        let locationProvincesFilter = LocationDbManager.shared.locationList()?.filter("provinces == '\(provincesValue)'")
        let locationProvincesFilterOptional = locationProvincesFilter?.first?.provinces ?? ""
        //도시 중복 확인 및 처리 함수
        if tableSection == 0 { //섹션0
            if cityValue == contentText && provincesValue == titleText{
                navigationController?.popViewController(animated: true)
            } else if locationCityFilter?.first?.city != cityValue || locationProvincesFilterOptional != provincesValue {
                //메모 수정
                LocationDbManager.shared.locationListUpdate(LocationListIndexPathRow: cellIndex, provinces: provincesValue, city: cityValue)
                navigationController?.popViewController(animated: true)
            } else {
                showAlertBtn1(title: "리스트 저장 오류", message: "이미 같은 지역 리스트가 존재합니다.", btnTitle: "확인") {}
            }
        } else { //섹션1
            if locationCityFilter?.first?.city != cityValue || locationProvincesFilterOptional != provincesValue {
                //메모 생성
                LocationDbManager.shared.locationListInsert(provinces: provincesValue, city: cityValue, isChecked: false)
                navigationController?.popViewController(animated: true)
            } else {
                showAlertBtn1(title: "리스트 저장 오류", message: "이미 같은 지역 리스트가 존재합니다.", btnTitle: "확인") {}
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    var locationDatas: [locationData] = []
    var locationDataFilterValue: [locationData] = []
    
    //텍스트 필드에서 입력한 '도'/'시'를 저장
    var provincesValue = ""
    var cityValue = ""
    
    //테이블에서 넘어올 값 변수 선언
    var titleText = ""
    var contentText = ""
    var cellIndex = 0
    var tableSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingHUD.show()
        saveBtn.isOn = .Off
        locationDatasSet()
        tableViewSet()
        ValueFromTable()
        LoadingHUD.hide()
    }
    
    //테이블뷰 세팅
    func tableViewSet() {
        locationSearchTableView.delegate = self
        locationSearchTableView.dataSource = self
        locationSearchTableView.separatorStyle = .none
        locationSearchTableView.register(UINib(nibName: "SingleTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleTableViewCell")
    }
    
    //테이블에서 넘어온 값
    func ValueFromTable() {
        if tableSection == 0 {
            searchTf.text = titleText + " " + contentText
            saveBtn.setTitle("수정", for: UIControl.State.normal)
            searchTfActionFunc()
        }
    }
    
    //서치바 액션 함수
    func searchTfActionFunc() {
        LoadingHUD.show()
        locationDataFilterValue = locationDatas.filter {
            "\($0.province) \($0.city)".contains(searchTf.text ?? "")
        }
        cellCountLbl.text = "\(locationDataFilterValue.count)"
        locationSearchTableView.reloadData()
        if searchTf.text == "\(locationDataFilterValue.first?.province ?? "") \(locationDataFilterValue.first?.city ?? "")" {
            saveBtn.isOn = .On
        } else {
            saveBtn.isOn = .Off
        }
        
        let str =  searchTf.text
        let arr =  str?.components(separatedBy: " ")
        let arr2 =  str?.components(separatedBy: " ")
        if arr?.count ?? 0 >= 2 {
            provincesValue = arr![0]
            print(provincesValue)
        }
        if arr2?.count ?? 0 >= 2 {
            cityValue = arr![1]
            print(cityValue)
        }
        LoadingHUD.hide()
    }
}

//MARK: 테이블뷰 구현
extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationDataFilterValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        //셀 클래스 선언
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleTableViewCell", for: indexPath) as? SingleTableViewCell else {
            return UITableViewCell()
        }
        cell.leftImgView.isHidden = true
        cell.titleLbl.text = locationDataFilterValue[indexPath.row].province
        cell.contentLbl.text = locationDataFilterValue[indexPath.row].city
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let provincesValue = locationDataFilterValue[indexPath.row].province
        let cityValue = locationDataFilterValue[indexPath.row].city
        searchTf.text = provincesValue + " " + cityValue
        self.provincesValue = provincesValue
        self.cityValue = cityValue
        searchTfActionFunc()
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

struct locationData {
    var province: String
    var city: String
    
    init(province: String, city: String) {
        self.province = province
        self.city = city
    }
}

//MARK: 로케이션 데이터
extension LocationSearchViewController {
    func locationDatasSet() {
        let provinces = ["서울특별시","경기도","인천광역시","강원도","충청북도","충청남도","대전광역시","세종특별자치시","경상북도","경상남도","대구광역시","울산광역시","부산광역시","광주광역시","전라북도","전라남도","제주도"]

        let cityOfSeoul = ["강남구","강동구","강북구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구","은평구","종로구","중구","중랑구"]
        let cityOfGyeonggido = ["고양시","과천시","광명시","광주시","구리시","군포시","김포시","남양주시","동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","여주시","오산시","용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시","가평군","양평군","연천군"]

        let cityOfIncheon = ["중구","동구","미추홀구","연수구","남동구","부평구","계양구","서구","강화군","옹진군"]
        let cityOfGangwondo = ["춘천시","원주시","강릉시","동해시","태백시","속초시","삼척시","홍천군","횡성군","영월군","평창군","정선군","철원군","화천군","양구군","인제군","고성군","양양군"]
        let cityOfChungcheongbukdo = ["청주시","충주시","제천시","보은군","옥천군","영동군","증평군","진천군","괴산군","음성군","단양군"]
        let cityOfChungcheongnamdo = ["천안시","공주시","보령시","아산시","서산시","논산시","계룡시","당진시","금산군","부여군","서천군","청양군","홍성군","예산군","태안군"]
        let cityOfDaejeon = ["동구","중구","서구","유성구","대덕구"]
        let cityOfGyeongsangbukdo = ["경산시","영천시","경주시","영덕군","영양군","청송군","안동시","의성군","군위군","칠곡군","김천시","상주시","예천군","영주시","봉화군","문경시","성주군","고령군","청도군","구미시","울릉군"]
        let cityOfGyeongsangnamdo = ["창원시","양산시","고성군","함양군","남해군","밀양시","통영시","거제시","진주시","거창군","합천군","사천시","김해시","의령군","함안군","창녕군","하동군","산청군"]
        let cityOfDaegu = ["중구","동구","서구","남구","북구","수성구","달서구","달성군"]
        let cityOfUlsan = ["중구","남구","동구","북구","울주군"]
        let cityOfBusan = ["중구","서구","동구","영도구","부산진구","동래구","남구","북구","강서구","해운대구","사하구","금정구","연제구","수영구","사상구","기장군"]
        let cityOfGwangju = ["동구","서구","남구","북구","광산구"]
        let cityOfJeollabukdo = ["전주시","군산시","익산시","정읍시","남원시","김제시","완주군","진안군","무주군","장수군","임실군","순창군","고창군","부안군"]
        let cityOfJeollanamdo = ["목포시","여수시","순천시","나주시","광양시","담양군","곡성군","구례군","고흥군","보성군","화순군","장흥군","강진군","해남군","영암군","무안군","함평군","영광군","장성군","완도군","진도군","신안군"]

        let cityOfJeju = ["제주시","서귀포시"]

        var seoul: [locationData] = []
        var gyeonggido: [locationData] = []
        var incheon: [locationData] = []
        var gangwondo: [locationData] = []
        var chungcheongbukdo: [locationData] = []
        var chungcheongnamdo: [locationData] = []
        var daejeon: [locationData] = []
        let sejong = locationData(province: provinces[7], city: "")
        var gyeongsangbukdo: [locationData] = []
        var gyeongsangnamdo: [locationData] = []
        var daegu: [locationData] = []
        var ulsan: [locationData] = []
        var busan: [locationData] = []
        var gwangju: [locationData] = []
        var jeollabukdo: [locationData] = []
        var jeollanamdo: [locationData] = []
        var jeju: [locationData] = []

        for i in 0..<cityOfSeoul.count {
            seoul.append(locationData(province: provinces[0], city: cityOfSeoul[i]))
        }
        for i in 0..<cityOfGyeonggido.count {
            gyeonggido.append(locationData(province: provinces[1], city: cityOfGyeonggido[i]))
        }
        for i in 0..<cityOfIncheon.count {
            incheon.append(locationData(province: provinces[2], city: cityOfIncheon[i]))
        }
        for i in 0..<cityOfGangwondo.count {
            gangwondo.append(locationData(province: provinces[3], city: cityOfGangwondo[i]))
        }
        for i in 0..<cityOfChungcheongbukdo.count {
            chungcheongbukdo.append(locationData(province: provinces[4], city: cityOfChungcheongbukdo[i]))
        }
        for i in 0..<cityOfChungcheongnamdo.count {
            chungcheongnamdo.append(locationData(province: provinces[5], city: cityOfChungcheongnamdo[i]))
        }
        for i in 0..<cityOfDaejeon.count {
            daejeon.append(locationData(province: provinces[6], city: cityOfDaejeon[i]))
        }
        for i in 0..<cityOfGyeongsangbukdo.count {
            gyeongsangbukdo.append(locationData(province: provinces[8], city: cityOfGyeongsangbukdo[i]))
        }
        for i in 0..<cityOfGyeongsangnamdo.count {
            gyeongsangnamdo.append(locationData(province: provinces[9], city: cityOfGyeongsangnamdo[i]))
        }
        for i in 0..<cityOfDaegu.count {
            daegu.append(locationData(province: provinces[10], city: cityOfDaegu[i]))
        }
        for i in 0..<cityOfUlsan.count {
            ulsan.append(locationData(province: provinces[11], city: cityOfDaegu[i]))
        }
        for i in 0..<cityOfBusan.count {
            busan.append(locationData(province: provinces[12], city: cityOfBusan[i]))
        }
        for i in 0..<cityOfGwangju.count {
            gwangju.append(locationData(province: provinces[13], city: cityOfGwangju[i]))
        }
        for i in 0..<cityOfJeollabukdo.count {
            jeollabukdo.append(locationData(province: provinces[14], city: cityOfJeollabukdo[i]))
        }
        for i in 0..<cityOfJeollanamdo.count {
            jeollanamdo.append(locationData(province: provinces[15], city: cityOfJeollanamdo[i]))
        }
        for i in 0..<cityOfJeju.count {
            jeju.append(locationData(province: provinces[16], city: cityOfJeju[i]))
        }
        let locationDatas01 = seoul+gyeonggido+incheon+gangwondo
        let locationDatas02 = chungcheongbukdo+chungcheongnamdo+daejeon+[sejong]
        let locationDatas03 = gyeongsangbukdo+gyeongsangnamdo+daegu
        let locationDatas04 = ulsan+busan+gwangju+jeollabukdo+jeollanamdo+jeju
        locationDatas = locationDatas01+locationDatas02+locationDatas03+locationDatas04
    }
}
