//
//  MemoConfig.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/20.
//

import RealmSwift

class MemoListManager {
    
    static let shared: MemoListManager = MemoListManager()
    
    //달력 날짜 필터 적용한 메모리스트
    func memoListFilter(calenderDate: String) -> Results<MemoList>! {
        let realm = try! Realm()
        let memoListFilter = realm.objects(MemoList.self).filter("calenderDate = '\(calenderDate)'").sorted(byKeyPath: "timeStart", ascending: true)
        return memoListFilter
    }
    
    //메모리스트 중복되지 않는 id 발급
    func createNewId() -> Int {
        let realm = try! Realm()
        if let nextId = realm.objects(MemoList.self).sorted(byKeyPath: "id", ascending: false).first?.id {
            return nextId + 1
        } else {
            return 0
        }
    }
    
    //메모리스트 레코드 생성
    func memoInsert(category: String, title: String, timeStart: String, timeEnd: String, memo: String, calenderDate: String) {
        let data = MemoList(value: ["category": category, "title": title, "timeStart": timeStart, "timeEnd": timeEnd, "memo": memo,"calenderDate": calenderDate, "id": createNewId()])
        
//        let data = MemoList()
//        data.id = createNewId()
//        data.category = category
//        data.title = title
//        data.timeStart = timeStart
//        data.timeEnd = timeEnd
//        data.memo = memo
//        data.calenderDate = calenderDate
        
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
    
    //메모리스트 레코드 수정
    func memoUpdate(memoList: Results<MemoList>, memoIndexPathRow: Int, category: String, title: String, timeStart: String, timeEnd: String, memo: String) {
       
        let data = memoList[memoIndexPathRow]
        
        let realm = try! Realm()
        do{
            try realm.write{
                data.category = category
                data.title = title
                data.timeStart = timeStart
                data.timeEnd = timeEnd
                data.memo = memo
            }
        }
        catch{
            print("\(error)")
        }
    }
    
    //메모리스트 레코드 삭제
    func memoDelete(memoList: Results<MemoList>, memoIndexPathRow: Int) {
        let data = memoList[memoIndexPathRow]
        let realm = try! Realm()
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
