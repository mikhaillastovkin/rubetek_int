//
//  Response.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation
import RealmSwift

class Response<T: Codable>: Codable {
    let success: Bool
    let data: T
}
