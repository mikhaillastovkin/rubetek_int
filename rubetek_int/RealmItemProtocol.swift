//
//  RealmItemProtocol.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import Foundation
import RealmSwift

protocol RealmItemProtocol {
    static func loadData(complition: @escaping () -> Void)
    static func getData<T:Object>(typeOf: T.Type) throws -> Results<T>
}

extension RealmItemProtocol {

    static func getData<T: Object>(typeOf: T.Type) throws -> Results<T> {
        let realm = try Realm()
        return realm.objects(T.self)
    }
}



