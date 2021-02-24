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
    func measuringStationApi(apiKey:String, province: String, city: String, after: @escaping (_ resultDmX: String, _ resultDmY: String) -> ()) {
        
        var province = province
        let city = city
        //도시 이름 세팅
        if province == "서울특별시" {
            if city != "광진구" {
                province = "서울"
            }
        }
        if province == "경기도" {
            if city != "가평군" || city != "양평군" {
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
            if city != "영양군" || city != "청송군" || city != "예천군" || city != "봉화군" || city != "성주군" {
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
            if city != "담양군" || city != "고흥군" || city != "장흥군" || city != "강진군" || city != "해남군" || city != "무안군" || city != "함평군" || city != "완도군" || city != "진도군" {
                province = "전남"
            }
        }
        if province == "제주도" {
            province = "제주"
        }
        
        let provinceAndCity = province + " " + city
        
        //url은 한글을 인코딩해야함
        let provinceAndCityEncoding = provinceAndCity.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getMsrstnList?&addr=\(provinceAndCityEncoding!)&pageNo=1&numOfRows=10&ServiceKey=\(apiKey)&_returnType=json"
        
        //미세먼지 api
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let resultDmX = json["list"][0]["dmX"].stringValue
                let resultDmY = json["list"][0]["dmY"].stringValue
                after(resultDmX, resultDmY)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: 측정소찾기 api
    func searchMeasuringStationApi(apiKey:String, resultDmX: String, resultDmY: String, after: @escaping (_ stationName: String) -> ()) {
     
        let resultDmX = resultDmX
        let resultDmY = resultDmY
        
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getNearbyMsrstnList?tmX=\(resultDmX)&tmY=\(resultDmY)&pageNo=1&numOfRows=10&ServiceKey=\(apiKey)&_returnType=json"
        
        //미세먼지 api
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let stationName = json["list"][0]["stationName"].stringValue
                after(stationName)
             
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: 미세먼지 api
    func airApi(apiKey:String, measuringStation: String, after: @escaping (_ pm10Grade:String,_  pm10Value:String,_ pm25Grade:String,_ pm25Value:String,_ no2Grade:String,_ no2Value:String,_ o3Grade:String,_ o3Value:String,_ coGrade:String,_ coValue:String,_ so2Grade:String,_ so2Value:String) -> ()) {
        
        let measuringStation = measuringStation
        
        //url은 한글을 인코딩해야함
        let airMeasuringStationEncoding = measuringStation.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let  url = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName=\(airMeasuringStationEncoding!)&dataTerm=daily&pageNo=1&numOfRows=1&ServiceKey=\(apiKey)&_returnType=json&ver=1.3"
        
        //미세먼지 api
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                //pm10(미세먼지) 결과 1:좋음 2:보통 3:나쁨 4:매우나쁨
                var pm10Grade = json["list"][0]["pm10Grade"].stringValue
                //pm10(미세먼지) 값
                var pm10Value = json["list"][0]["pm10Value"].stringValue
                //pm25(초미세먼지) 결과 1:좋음 2:보통 3:나쁨 4:매우나쁨
                var pm25Grade = json["list"][0]["pm25Grade"].stringValue
                //pm25(초미세먼지) 값
                var pm25Value = json["list"][0]["pm25Value"].stringValue
                //no2(이산화질소) 결과 1:좋음 2:보통 3:나쁨 4:매우나쁨
                var no2Grade = json["list"][0]["no2Grade"].stringValue
                //no2(이산화질소) 값
                var no2Value = json["list"][0]["no2Value"].stringValue
                //o3(오존) 결과 1:좋음 2:보통 3:나쁨 4:매우나쁨
                var o3Grade = json["list"][0]["o3Grade"].stringValue
                //o3(오존) 값
                var o3Value = json["list"][0]["o3Value"].stringValue
                //co(일산화탄소) 결과 1:좋음 2:보통 3:나쁨 4:매우나쁨
                var coGrade = json["list"][0]["coGrade"].stringValue
                //co(일산화탄소) 값
                var coValue = json["list"][0]["coValue"].stringValue
                //so2(이산황) 결과 1:좋음 2:보통 3:나쁨 4:매우나쁨
                var so2Grade = json["list"][0]["so2Grade"].stringValue
                //so2(이산황) 값
                var so2Value = json["list"][0]["so2Value"].stringValue
                
                if pm10Grade == "1" || pm25Grade == "1" || no2Grade == "1" || o3Grade == "1" || coGrade == "1" || so2Grade == "1" {
                    pm10Grade = "좋음"
                    pm25Grade = "좋음"
                    no2Grade = "좋음"
                    o3Grade = "좋음"
                    coGrade = "좋음"
                    so2Grade = "좋음"
                    
                } else if pm10Grade == "2" || pm25Grade == "2" || no2Grade == "2" || o3Grade == "2" || coGrade == "2" || so2Grade == "2" {
                    pm10Grade = "보통"
                    pm25Grade = "보통"
                    no2Grade = "보통"
                    o3Grade = "보통"
                    coGrade = "보통"
                    so2Grade = "보통"
                } else if pm10Grade == "3" || pm25Grade == "3" || no2Grade == "3" || o3Grade == "3" || coGrade == "3" || so2Grade == "3" {
                    pm10Grade = "나쁨"
                    pm25Grade = "나쁨"
                    no2Grade = "나쁨"
                    o3Grade = "나쁨"
                    coGrade = "나쁨"
                    so2Grade = "나쁨"
                } else if pm10Grade == "4" || pm25Grade == "4" || no2Grade == "4" || o3Grade == "4" || coGrade == "4" || so2Grade == "4" {
                    pm10Grade = "매우 나쁨"
                    pm25Grade = "매우 나쁨"
                    no2Grade = "매우 나쁨"
                    o3Grade = "매우 나쁨"
                    coGrade = "매우 나쁨"
                    so2Grade = "매우 나쁨"
                }
                
                pm10Value = pm10Value + "㎍/m³"
                pm25Value = pm25Value + "㎍/m³"
                no2Value = no2Value + "ppm"
                o3Value = o3Value + "ppm"
                coValue = coValue + "ppm"
                so2Value = so2Value + "ppm"
                
                after(pm10Grade,pm10Value,pm25Grade,pm25Value,no2Grade,no2Value,o3Grade,o3Value,coGrade,coValue,so2Grade,so2Value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
