//
//  ParsDataServiseProtocol.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation

protocol ParsDataServiseProtocol {
    associatedtype DataModel: Codable
    func fechRequest(from: EndPointProtocol, complition: @escaping (DataModel?, Error?) -> Void)
}
