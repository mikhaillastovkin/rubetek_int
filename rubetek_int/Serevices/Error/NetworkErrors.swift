//
//  NetworkErrors.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation

enum NetworkErrors: Error {
    case urlError, loadError, parsError
}
