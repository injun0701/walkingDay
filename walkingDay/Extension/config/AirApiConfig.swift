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
    func measuringStationApi(apiKey:String, province: String, city: String, after: @escaping (_ resultDmX: String, _ resultDmY: String) -> (), after2: @escaping () -> ()) {
        
        var province = province
        var city = city
        //도시 이름 세팅
        if province == "인천광역시" {
            if city == "미추홀구" {
                city = "남구"
            }
        }
        if province == "제주도" {
            province = "제주특별자치도"
        }
        
        let cityPrefix = String(city.prefix(2))
        
        let provinceAndCity = province + " " + cityPrefix
        
        //url은 한글을 인코딩해야함
        let provinceAndCityEncoding = provinceAndCity.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getTMStdrCrdnt?serviceKey=\(apiKey)&numOfRows=10&pageNo=1&umdName=\(provinceAndCityEncoding!)&_returnType=json"
        
        //미세먼지 api
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let resultTmX = json["list"][0]["tmX"].stringValue
                let resultTmY = json["list"][0]["tmY"].stringValue
                after(resultTmX, resultTmY)
                
            case .failure(let error):
                after2()
                print(error)
            }
        }
    }
    
    //MARK: 측정소찾기 api
    func searchMeasuringStationApi(apiKey:String, resultTmX: String, resultTmY: String, after: @escaping (_ stationName: String) -> ()) {
     
        let resultTmX = resultTmX
        let resultTmY = resultTmY
        
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getNearbyMsrstnList?tmX=\(resultTmX)&tmY=\(resultTmY)&pageNo=1&numOfRows=10&ServiceKey=\(apiKey)&_returnType=json"
        
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
                print("JSON: \(json)")
                
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
