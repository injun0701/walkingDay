//
//  RealmModel.swift
//  test
//
//  Created by HongInJun on 2021/02/07.
//

import Foundation
import RealmSwift

//테이블 정의
class MemoList : Object {
    @objc dynamic var id = 0 //primaryKey
    @objc dynamic var category = "" //필수 입력
    @objc dynamic var title = ""
    @objc dynamic var timeStart = ""
    @objc dynamic var timeEnd = ""
    @objc dynamic var memo = ""
    @objc dynamic var calenderDate = ""
    
    override static func primaryKey() -> String? {
          return "id"
    }
}
