//
//  Item.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation
import RealmSwift

protocol Item {
    var name: String? { get }
    var userName: String? { get }
    var snapshot: String? { get }
    var room: String? { get }
    var id: Int? { get }
    var favorites: Bool? { get }
}
