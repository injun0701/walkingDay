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
        let apiKey = "tHdaFkeZaI9Bkc1GCSnDqZ76KjZQGbNNh4kX38IzDT2GmbD3McHV%2BzZV5%2F5ygds3p%2BVZ3rOtvxHCJcoCAzlmTg%3D%3D"
        return apiKey
    }
    
    //미세먼지 측정소 Tm 좌표 찾기 api url
    func provinceAndCityToTmXTmYApiUrl(provinceAndCityEncoding: String) -> String {
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getTMStdrCrdnt?serviceKey=\(airApiKey())&numOfRows=10&pageNo=1&umdName=\(provinceAndCityEncoding)&_returnType=json"
        
        return url
    }
    
    //미세먼지 측정소찾기 api url
    func tmXTmYToAirMeasuringStationApiUrl(resultTmX: String, resultTmY: String) -> String {
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getNearbyMsrstnList?tmX=\(resultTmX)&tmY=\(resultTmY)&pageNo=1&numOfRows=10&ServiceKey=\(airApiKey())&_returnType=json"
        
        return url
    }
    
    //미세먼지 측정소찾기 api url
    func airApiUrl(airMeasuringStationEncoding: String) -> String {
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?stationName=\(airMeasuringStationEncoding)&dataTerm=daily&pageNo=1&numOfRows=1&ServiceKey=\(airApiKey())&_returnType=json&ver=1.3"
        
        return url
    }
    
    //날씨 Dm 좌표 찾기 api url
    func provinceAndCityToDmXDmYApiUrl(provinceAndCityEncoding: String) -> String {
        let url = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getMsrstnList?&addr=\(provinceAndCityEncoding)&pageNo=1&numOfRows=10&ServiceKey=\(airApiKey())&_returnType=json"
        
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
