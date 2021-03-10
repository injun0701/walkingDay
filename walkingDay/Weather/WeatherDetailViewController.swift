//
//  WeatherDetailViewController.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/26.
//

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet var cityTitleLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var weatherImgView: UIImageView!
    @IBOutlet var weatherLbl: UILabel!
    @IBOutlet var contentLbl: UILabel!
    @IBOutlet var weatherTableView: UITableView!
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func hambergerMenuBtnAction(_ sender: UIButton) {
        toMenuBtnAction()
    }
    
    var weather: [Weather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherSet()
        dateLblSet(lbl: dateLbl)
        weatherTableViewSet()
        weatherTableViewData()
    }
    
    //날씨 배경 이미지 세팅
    func weatherSet() {
        cityTitleLbl.text = UserDefaults.standard.string(forKey:  "cityTitle")
        let ad = UIApplication.shared.delegate as? AppDelegate
        if ad?.weather == "맑음" {
            gifSet(gifName: "weather_sun@3x.gif", imgView: weatherImgView)
            contentLbl.text = "오늘 하늘이 해가 떠서 맑아요.  밖에 나가서 놀아볼까요?"
        } else if ad?.weather == "비" {
            gifSet(gifName: "weather_rain@3x.gif", imgView: weatherImgView)
            contentLbl.text = "오늘은 구름이 있고 비가 내려요.  우산 꼭 챙기세요!"
        } else if ad?.weather == "눈" {
            gifSet(gifName: "weather_snow@3x.gif", imgView: weatherImgView)
            contentLbl.text = "오늘은 구름이 있고 눈이 내려요.  우산 꼭 챙기세요!"
        } else {
            gifSet(gifName: "weather_cloudy@3x.gif", imgView: weatherImgView)
            contentLbl.text = "구름이 있어서 날씨가 조금 흐리네요.  간단한 산책 어떠세요?"
        }
        weatherLbl.text = ad?.weather
    }
    
    
    //테이블뷰 세팅
    func weatherTableViewSet() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.separatorStyle = .none
        weatherTableView.register(UINib(nibName: "SingleBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleBoxTableViewCell")
    }
    
    //테이블뷰 데이터 세팅
    func weatherTableViewData() {
        let ad = UIApplication.shared.delegate as? AppDelegate
        let currentTempToDouble = Double(ad!.currentTemp) ?? 0.0
        let tempText = String(format: "%.0f", currentTempToDouble)+"℃(체감온도:"+String(format: "%.0f", ad!.feelsLikeTemp)+"℃)"
        let humidityText = "\(ad!.humidityText)% 습도"
        let windText = ad!.windText+"m/s의 바람"
        weather = [
            Weather(text: tempText),
            Weather(text: humidityText),
            Weather(text: windText)
          
       ]
    }
    
}

extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleBoxTableViewCell", for: indexPath) as? SingleBoxTableViewCell else {
            return UITableViewCell()
        }
        cell.imgView.isHidden = true
        cell.titleLbl.text = weather[indexPath.row].text
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

struct Weather {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}

