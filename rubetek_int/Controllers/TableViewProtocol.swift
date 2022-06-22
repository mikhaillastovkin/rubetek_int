//
//  TableViewProtocol.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit
import RealmSwift

protocol TableViewProtocol: UIViewController {
    associatedtype RealmType: Object

    var tableView: CustomTableView { get }
    var realmArray: Results<RealmType>? { get set }
    var notificationToken: NotificationToken? { get set }

    func setupUI()
    func setObserver()
    func setupTableView()
    func checkData()
}

extension TableViewProtocol {

    func setupUI() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

    func setObserver() {
        notificationToken = realmArray?.observe({ [weak self] change in
            switch change {
            case .initial(_):
                self?.tableView.reloadData()
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        })
    }

    func checkData() {
        realmArray = try? RealmService.load(typeOf: RealmType.self)
    }
}
