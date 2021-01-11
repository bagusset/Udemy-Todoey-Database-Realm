//
//  Items.swift
//  Todoey
//
//  Created by Bagus setiawan on 19/09/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Items : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var status: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
