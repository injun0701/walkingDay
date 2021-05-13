//
//  AirApi.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/24.
//

import Alamofire
import SwiftyJSON

extension UIViewController {
    
    //MARK: 미세먼지 측정소 Tm 좌표 찾기 api
    func provinceAndCityToDmApi(province: String, city: String, after: @escaping (_ resultDmX: String, _ resultDmY: String) -> (), fail: @escaping () -> ()) {
        
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
        let url = provinceAndCityToTmXTmYApiUrl(provinceAndCityEncoding: provinceAndCityEncoding!)
        
        //미세먼지 측정소 Tm 좌표 찾기 api
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //응답받은
                let statusCode = response.response?.statusCode ?? 404
                
                //성공 실패 케이스 나누기
                switch statusCode {
                case ProvinceAndCityToTmXTmYStatusCode.success.rawValue:
                    print("도, 시로 Tm 좌표 찾기 성공")
                    
                    let resultTmX = json["list"][0]["tmX"].stringValue
                    let resultTmY = json["list"][0]["tmY"].stringValue
                    after(resultTmX, resultTmY)
                    
                case ProvinceAndCityToTmXTmYStatusCode.fail.rawValue:
                    print("도, 시로 Tm 좌표 찾기 실패")
                    fail()
                default:
                    print("도, 시로 Tm 좌표 찾기 실패")
                    fail()
                }
                
            case .failure(let error):
                fail()
                print(error)
            }
        }
    }
    
    //MARK: 미세먼지 측정소찾기 api
    func tmXTmYToAirMeasuringStationApi(resultTmX: String, resultTmY: String, after: @escaping (_ stationName: String) -> (), fail: @escaping () -> ()) {
     
        let resultTmX = resultTmX
        let resultTmY = resultTmY
        
        let url = tmXTmYToAirMeasuringStationApiUrl(resultTmX: resultTmX, resultTmY: resultTmY)
        
        //미세먼지 api
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                //응답받은
                let statusCode = response.response?.statusCode ?? 404
                
                //성공 실패 케이스 나누기
                switch statusCode {
                case TmXTmYToAirMeasuringStationStatusCode.success.rawValue:
                    print("Tm 좌표로 미세먼지 측정소 찾기 성공")
                    
                    let stationName = json["list"][0]["stationName"].stringValue
                    after(stationName)
                    
                case TmXTmYToAirMeasuringStationStatusCode.fail.rawValue:
                    print("Tm 좌표로 미세먼지 측정소 찾기 실패")
                    fail()
                default:
                    print("Tm 좌표로 미세먼지 측정소 찾기 실패")
                    fail()
                }
                
            case .failure(let error):
                fail()
                print(error)
            }
        }
    }
    
    //MARK: 미세먼지 api
    func airApi(measuringStation: String, after: @escaping (_ pm10Grade:String,_  pm10Value:String,_ pm25Grade:String,_ pm25Value:String,_ no2Grade:String,_ no2Value:String,_ o3Grade:String,_ o3Value:String,_ coGrade:String,_ coValue:String,_ so2Grade:String,_ so2Value:String) -> (), fail: @escaping () -> ()) {
        
        let measuringStation = measuringStation
        
        //url은 한글을 인코딩해야함
        let airMeasuringStationEncoding = measuringStation.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        let  url = airApiUrl(airMeasuringStationEncoding: airMeasuringStationEncoding!)
        
        //미세먼지 api
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //응답받은
                let statusCode = response.response?.statusCode ?? 404
                
                //성공 실패 케이스 나누기
                switch statusCode {
                case AirApiStatusCode.success.rawValue:
                    print("미세먼지 정보 받기 성공")
                    
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
                    
                    pm10Grade = self.airGradeCal(pm10Grade)
                    pm25Grade = self.airGradeCal(pm25Grade)
                    no2Grade = self.airGradeCal(no2Grade)
                    o3Grade = self.airGradeCal(o3Grade)
                    coGrade = self.airGradeCal(coGrade)
                    so2Grade = self.airGradeCal(so2Grade)
                    
                    print("pm10Grade:\(pm10Grade), pm25Grade:\(pm25Grade), no2Grade:\(no2Grade), o3Grade:\(o3Grade), coGrade:\(coGrade), so2Grade:\(so2Grade)")
                    
                    pm10Value = pm10Value + "㎍/m³"
                    pm25Value = pm25Value + "㎍/m³"
                    no2Value = no2Value + "ppm"
                    o3Value = o3Value + "ppm"
                    coValue = coValue + "ppm"
                    so2Value = so2Value + "ppm"
                    
                    after(pm10Grade,pm10Value,pm25Grade,pm25Value,no2Grade,no2Value,o3Grade,o3Value,coGrade,coValue,so2Grade,so2Value)
                    
                case AirApiStatusCode.fail.rawValue:
                    print("미세먼지 정보 받기 실패")
                    fail()
                default:
                    print("미세먼지 정보 받기 실패")
                    fail()
                }
                
            case .failure(let error):
                fail()
                print(error)
            }
        }
    }
    
    //대기정보 수치값 변환
    func airGradeCal(_ grade : String) -> String {
        if grade == "1" {
            return "좋음"
        } else if grade == "2"{
            return "보통"
        } else if grade == "3"{
            return "나쁨"
        } else if grade == "4"{
            return "매우 나쁨"
        }
        return ""
    }
    
    //MARK: 미세먼지 api 그룹
    func airApiGroup(province: String, city: String, action: @escaping () -> (), fail: @escaping () -> ()) {
        //앱델리게이트
        let ad = UIApplication.shared.delegate as? AppDelegate
        provinceAndCityToDmApi(province: province, city: city) { (resultTmX, resultTmY) in
            let resultTmX = resultTmX
            let resultTmY = resultTmY
            self.tmXTmYToAirMeasuringStationApi(resultTmX: resultTmX, resultTmY: resultTmY) { (result) in
                let result = result
                self.airApi(measuringStation: result) { pm10Grade,pm10Value,pm25Grade,pm25Value,no2Grade,no2Value,o3Grade,o3Value,coGrade,coValue,so2Grade,so2Value  in
                    
                    ad?.pm10Grade = pm10Grade
                    ad?.pm10Value = pm10Value
                    ad?.pm25Grade = pm25Grade
                    ad?.pm25Value = pm25Value
                    ad?.no2Grade = no2Grade
                    ad?.no2Value = no2Value
                    ad?.o3Grade = o3Grade
                    ad?.o3Value = o3Value
                    ad?.coGrade = coGrade
                    ad?.coValue = coValue
                    ad?.so2Grade = so2Grade
                    ad?.so2Value = so2Value
                    action()
                } fail: {
                    self.showAlertBtn1(title: "서버 통신 오류", message: "날씨 및 미세먼지 데이터를 불러올 수 없습니다.", btnTitle: "확인") {}
                }
            } fail: {
                self.showAlertBtn1(title: "서버 통신 오류", message: "날씨 및 미세먼지 데이터를 불러올 수 없습니다.", btnTitle: "확인") {}
            }
        } fail: {
            self.showAlertBtn1(title: "서버 통신 오류", message: "날씨 및 미세먼지 데이터를 불러올 수 없습니다.", btnTitle: "확인") {
                fail()
            }
        }
    }
    
}
