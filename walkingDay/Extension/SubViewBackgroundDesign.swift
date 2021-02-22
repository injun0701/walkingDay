//
//  SubViewBackgroundDesign.swift
//  TodoList
//
//  Created by HongInJun on 2021/01/12.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

class SubViewBackgroundDesign: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundViewDesign(self,cornerRadius: 15, height: 2.5, shadowRadius: 5, shadowOpacity: 0.18)
    }
}

class SubViewBackgroundDesign02: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundViewDesign(self,cornerRadius: 20, height: 2.5, shadowRadius: 20, shadowOpacity: 0.20)
    }
}

class SubViewBackgroundDesignBar: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundViewDesign(self,cornerRadius: 3, height: 2, shadowRadius: 3, shadowOpacity: 0.17)
    }
}

class SubViewBackgroundDesignBtn: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundViewDesign(self,cornerRadius: 6, height: 2.5, shadowRadius: 5, shadowOpacity: 0.18)
    }
}

