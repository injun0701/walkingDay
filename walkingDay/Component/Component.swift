//
//  Component.swift
//  SwiftSample
//
//  Created by HongInJun on 2021/04/24.
//

import UIKit

//url 모음
extension UIViewController {
    //api key
    func airApiKey() -> String {
        let apiKey = "7DmByV4sR%2FTZIem%2F9l3%2F%2FlmTuh%2BmyajPkL0mWoxGEY9j7dpgWPYLojKSwyZK8IUeUftqDfzTvGAaU2DZzgF0sQ%3D%3D"
        return apiKey
    }
    
    //미세먼지 측정소 Tm 좌표 찾기 api url
    func provinceAndCityToTmXTmYApiUrl(provinceAndCityEncoding: String) -> String {
        let url = "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getTMStdrCrdnt?serviceKey=\(airApiKey())&returnType=json&numOfRows=1&pageNo=1&umdName=\(provinceAndCityEncoding)"
        
        return url
    }
    
    //미세먼지 측정소찾기 api url
    func tmXTmYToAirMeasuringStationApiUrl(resultTmX: String, resultTmY: String) -> String {
        let url = "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getNearbyMsrstnList?serviceKey=\(airApiKey())&returnType=json&tmX=\(resultTmX)&tmY=\(resultTmY)&ver=1.0"
        
        return url
    }
    
    //미세먼지 측정소찾기 api url
    func airApiUrl(airMeasuringStationEncoding: String) -> String {
        let url =    "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=\(airApiKey())&returnType=json&numOfRows=1&pageNo=1&stationName=\(airMeasuringStationEncoding)&dataTerm=DAILY&ver=1.3"
        
        return url
    }
    
    //날씨 Dm 좌표 찾기 api url
    func provinceAndCityToDmXDmYApiUrl(provinceAndCityEncoding: String) -> String {
        let url = "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getMsrstnList?serviceKey=\(airApiKey())&returnType=json&numOfRows=1&pageNo=1&addr=\(provinceAndCityEncoding)"
        
        return url
    }
    
    //날씨 api url
    func weatherApiUrl(resultDmX: String, resultDmY: String) -> String {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(resultDmX)&lon=\(resultDmY)&appid=444f718e32c501dfdd68127290a21160"
        
        return url
    }
}

enum ProvinceAndCityToTmXTmYStatusCode : Int {
    case success = 200
    case fail = 400
}

enum TmXTmYToAirMeasuringStationStatusCode : Int {
    case success = 200
    case fail = 400
}

enum AirApiStatusCode : Int {
    case success = 200
    case fail = 400
}

enum ProvinceAndCityToDmXDmYStatusCode : Int {
    case success = 200
    case fail = 400
}

enum WeatherApiStatusCode : Int {
    case success = 200
    case fail = 400
}
