//
//  LocationDbConfig.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/23.
//

import RealmSwift

class LocationDbManager {
    
    static let shared: LocationDbManager = LocationDbManager()
    
    //로케이션리스트
    func locationList() -> Results<LocationList>! {
        let realm = try! Realm()
        let locationList = realm.objects(LocationList.self).sorted(byKeyPath: "id", ascending: true)
        return locationList
    }
    
    //로케이션리스트 중복되지 않는 id 발급
    func createNewId() -> Int {
        let realm = try! Realm()
        if let nextId = realm.objects(LocationList.self).sorted(byKeyPath: "id", ascending: false).first?.id {
            return nextId + 1
        } else {
            return 0
        }
    }
    
    //로케이션리스트 레코드 생성
    func locationListInsert(provinces: String, city: String, isChecked: Bool) {
        let data = LocationList(value: ["provinces": provinces, "city": city, "isChecked": isChecked , "id": createNewId()])
        
        let realm = try! Realm()
        do{
            try realm.write{
                realm.add(data)
            }
        }
        catch{
            print("\(error)")
        }
    }
    
    //로케이션리스트 레코드 수정
    func locationListUpdate(LocationListIndexPathRow: Int, provinces: String, city: String) {
        let realm = try! Realm()
        let loactionList = realm.objects(LocationList.self).sorted(byKeyPath: "id", ascending: true)
        let data = loactionList[LocationListIndexPathRow]
        
        do{
            try realm.write{
                data.provinces = provinces
                data.city = city
            }
        }
        catch{
            print("\(error)")
        }
    }
    
    //로케이션리스트 체크 레코드 수정
    func locationListCheckUpdate(LocationListIndexPathRow: Int, isChecked: Bool) {
        let realm = try! Realm()
        let loactionList = realm.objects(LocationList.self).sorted(byKeyPath: "id", ascending: true)
        let data = loactionList[LocationListIndexPathRow]
        
        do{
            try realm.write{
                data.isChecked = isChecked
            }
        }
        catch{
            print("\(error)")
        }
    }
    
    //로케이션리스트 레코드 삭제
    func locationListDelete(LocationListIndexPathRow: Int) {
        let realm = try! Realm()
        let loactionList = realm.objects(LocationList.self).sorted(byKeyPath: "id", ascending: true)
        let data = loactionList[LocationListIndexPathRow]
        
        do{
            try realm.write{
                realm.delete(data)
            }
        }
        catch{
            print("\(error)")
        }
    }
}
