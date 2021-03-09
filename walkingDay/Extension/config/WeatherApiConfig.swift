//
//  AirApi.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/24.
//

import Alamofire
import SwiftyJSON

extension UIViewController {
    
    //MARK: 측정소 위치 api
    func weatherLoationApi(apiKey:String, province: String, city: String, after: @escaping (_ resultDmX: String, _ resultDmY: String) -> (), after2: @escaping () -> ()) {
        
        var province = province
        let city = city
        //도시 이름 세팅
        if province == "서울특별시" {
            if city != "광진구" {
                province = "서울"
            }
        }
        if province == "경기도" {
            if city != "가평군" && city != "양평군" {
                province = "경기"
            }
        }
        if province == "인천광역시" {
            province = "인천"
        }
        if province == "강원도" {
            if city == "춘천시" || city == "원주시" || city == "강릉시" || city == "동해시" || city == "삼척시" || city == "평창군" || city == "정선군" {
                province = "강원"
            }
        }
        if province == "충청북도" {
            if city == "옥천군" || city == "증평군" {
                province = "충북"
            }
        }
        if province == "충청남도" {
            if city == "당진시" || city == "금산군" || city == "부여군" || city == "예산군" || city == "태안군" {
                province = "충남"
            }
        }
        if province == "대전광역시" {
            province = "대전"
        }
        if province == "경상북도" {
            if city != "영양군" && city != "청송군" && city != "예천군" && city != "봉화군" && city != "성주군" {
                province = "경북"
            }
        }
        if province == "경상남도" {
            if city == "거창군" || city == "합천군" || city == "김해시" || city == "의령군" || city == "함안군" || city == "창녕군" || city == "하동군" || city == "산청군" {
                province = "경남"
            }
        }
        if province == "대구광역시" {
            if city != "달성군" {
                province = "대구"
            }
        }
        if province == "울산광역시" {
            province = "울산"
        }
        if province == "부산광역시" {
            if city != "부산진구" {
                province = "부산"
            }
        }
        if province == "광주광역시" {
            province = "광주"
        }
        if province == "전라북도" {
            if city == "남원시" || city == "김제시" || city == "진안군" {
                province = "전북"
            }
        }
        if province == "전라남도" {
            if city != "담양군" && city != "고흥군" && city != "장흥군" && city != "강진군" && city != "해남군" && city != "무안군" && city != "함평군" && city != "완도군" && city != "진도군" {
                province = "전남"
            }
        }
        if province == "제주도" {
            province = "제주"
        }
        
        let cityPrefix = String(city.prefix(2))
        
        let provinceAndCity = province + " " + cityPrefix
        
        //url은 한글을 인코딩해야함
        let provinceAndCityEncoding = provinceAndCity.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getMsrstnList?&addr=\(provinceAndCityEncoding!)&pageNo=1&numOfRows=10&ServiceKey=\(apiKey)&_returnType=json"
        
        //날씨 api
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let resultDmX = json["list"][0]["dmX"].stringValue
                let resultDmY = json["list"][0]["dmY"].stringValue
                after(resultDmX, resultDmY)
                
            case .failure(let error):
                after2()
                print(error)
            }
        }
    }
    
    //MARK: 측정소찾기 api
    func weatherApi(resultDmX: String, resultDmY: String, after: @escaping (_ weather: String,_ currentTemp: Double,_ feelsLikeTemp: Double,_ humidityText: String,_ windText:String) -> ()) {
     
        let resultDmX = resultDmX
        let resultDmY = resultDmY
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(resultDmX)&lon=\(resultDmY)&appid=444f718e32c501dfdd68127290a21160"
       
        //미세먼지 api
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                var weather = json["weather"][0]["description"].stringValue
                
                if weather == "clear sky" {
                    weather = "맑음"
                } else if weather == "shower rain" || weather == "rain" || weather == "thunderstorm" {
                    weather = "비"
                } else if weather == "snow" {
                    weather = "눈"
                } else if weather == "mist" {
                    weather = "안개"
                } else {
                    weather = "구름"
                }
                
                let currentTemp = json["main"]["temp"].doubleValue - 273.15
                let feelsLikeTemp = json["main"]["feels_like"].doubleValue - 273.15
                
                let humidity = json["main"]["humidity"].doubleValue
                let humidityText = "\(humidity)% 습도"
                
                let wind = json["wind"]["speed"].doubleValue
                let windText = "\(round(wind * 100) / 100)m/s의 바람"
                
                
                after(weather,currentTemp,feelsLikeTemp,humidityText,windText)
                
            case .failure(let error):
                print(error)
            }
        }
    }
   
}
