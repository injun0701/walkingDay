//
//  AirApi.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/24.
//

import Alamofire
import SwiftyJSON

extension UIViewController {
    
    //MARK: 날씨 Dm 좌표 찾기 api
    func provinceAndCityToDmXDmYApi(province: String, city: String, after: @escaping (_ resultDmX: String, _ resultDmY: String) -> (), fail: @escaping () -> ()) {
        
        let province = ProvinceAndcity(province: province, city: city).0
        let city = ProvinceAndcity(province: province, city: city).1
        
        print("\(province), \(city)")
        
        let cityPrefix = String(city.prefix(2))
        
        let provinceAndCity = province + " " + cityPrefix
        
        //url은 한글을 인코딩해야함
        let provinceAndCityEncoding = provinceAndCity.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let url = provinceAndCityToDmXDmYApiUrl(provinceAndCityEncoding: provinceAndCityEncoding!)
        
        //날씨 api
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //응답받은
                let statusCode = response.response?.statusCode ?? 404
                
                //성공 실패 케이스 나누기
                switch statusCode {
                case ProvinceAndCityToDmXDmYStatusCode.success.rawValue:
                    print("도, 시로 Dm 좌표 찾기 성공")
                    
                    let resultDmX = json["response"]["body"]["items"][0]["dmX"].stringValue
                    let resultDmY = json["response"]["body"]["items"][0]["dmY"].stringValue
                    
                    after(resultDmX, resultDmY)
                    
                case ProvinceAndCityToDmXDmYStatusCode.fail.rawValue:
                    print("도, 시로 Dm 좌표 찾기 실패")
                    fail()
                default:
                    print("도, 시로 Dm 좌표 찾기 실패")
                    fail()
                }

            case .failure(let error):
                fail()
                print(error)
            }
        }
    }
    
    //MARK: 날씨 api
    func weatherApi(resultDmX: String, resultDmY: String, after: @escaping (_ weather: String,_ currentTemp: Double,_ feelsLikeTemp: Double,_ humidityText: String,_ windText:String) -> (), fail: @escaping () -> ()) {
     
        let resultDmX = resultDmX
        let resultDmY = resultDmY
        print("resultDmX: \(resultDmX), resultDmY\(resultDmY)")
        
        let url = weatherApiUrl(resultDmX: resultDmX, resultDmY: resultDmY)
        
        //날씨 api
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //응답받은
                let statusCode = response.response?.statusCode ?? 404
                
                //성공 실패 케이스 나누기
                switch statusCode {
                case WeatherApiStatusCode.success.rawValue:
                    print("날씨 정보 받기 성공")
                    
                    var weather = json["weather"][0]["description"].stringValue
                    let weather1 = json["weather"][1]["description"].stringValue
                    
                    let weatherContainRain = weather.contains("rain")
                    let weather1ContainRain = weather1.contains("rain")
                    
                    print("\(weather) | \(weatherContainRain)")
                    print("\(weather1) | \(weather1ContainRain)")
                    
                    if weather == "clear sky" {
                        weather = "맑음"
                    } else if weatherContainRain == true || weather == "thunderstorm" {
                        weather = "비"
                    } else if weather == "snow" {
                        weather = "눈"
                    } else if weather == "mist" || weather == "Haze"{
                        weather = "안개"
                    } else {
                        weather = "구름"
                    }
                    
                    if weather1ContainRain == true || weather1 == "thunderstorm" {
                        weather = "비"
                    }
                    
                    let currentTemp = json["main"]["temp"].doubleValue - 273.15
                    let feelsLikeTemp = json["main"]["feels_like"].doubleValue - 273.15
                    
                    let humidity = json["main"]["humidity"].doubleValue
                    let humidityText = "\(humidity)"
                    
                    let wind = json["wind"]["speed"].doubleValue
                    let windText = "\(round(wind * 100) / 100)"
                    
                    
                    after(weather,currentTemp,feelsLikeTemp,humidityText,windText)
                    
                case WeatherApiStatusCode.fail.rawValue:
                    print("날씨 정보 받기 실패")
                    fail()
                default:
                    print("날씨 정보 받기 실패")
                    fail()
                }
                
            case .failure(let error):
                fail()
                print(error)
            }
        }
    }
    
    //도, 시 값을 받아서 api 값에 맞게 변환
    func ProvinceAndcity(province: String, city: String) -> (String, String){
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
        
        return (province, city)
    }
    
    //MARK: weather api 그룹
    func weatherApiGroup(province: String, city: String, action: @escaping () -> ()) {
        //앱델리게이트
        let ad = UIApplication.shared.delegate as? AppDelegate
        provinceAndCityToDmXDmYApi(province: province, city: city) { (resultDmX, resultDmY) in
            let resultDmX = resultDmX
            let resultDmY = resultDmY
            
            self.weatherApi(resultDmX: resultDmX, resultDmY: resultDmY) { weather,currentTemp,feelsLikeTemp,humidityText,windText  in
                ad?.weather = weather
                ad?.currentTemp = String(currentTemp)
                ad?.feelsLikeTemp = feelsLikeTemp
                ad?.humidityText = humidityText
                ad?.windText = windText
                action()
            } fail: {
                self.showAlertBtn1(title: "서버 통신 오류", message: "날씨 데이터를 불러올 수 없습니다.", btnTitle: "확인") {}
            }
        } fail: {
            self.showAlertBtn1(title: "서버 통신 오류", message: "날씨 데이터를 불러올 수 없습니다.", btnTitle: "확인") {}
        }
    }
}
