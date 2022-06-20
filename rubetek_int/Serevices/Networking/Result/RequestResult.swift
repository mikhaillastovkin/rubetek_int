//
//  RequestResult.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation

enum RequestResult<T> {
    case value(T)
    case error(Error)
}
