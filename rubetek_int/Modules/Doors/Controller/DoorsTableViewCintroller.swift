//
//  DooorsTV.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit
import RealmSwift
import SwiftUI

final class DoorsTableViewController: UIViewController  {

    var realmArray: Results<Door>?
    var tableView = DoorsTableView(frame: .zero, style: .plain)
    var notificationToken: NotificationToken?

    private let heightRowWithSnapshot = CGFloat(298)
    private let heightRowWithoutSnapshot = CGFloat(90)

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()

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

        Door.loadData { [weak self] in
            self?.realmArray = try? Door.getData(typeOf: Door.self)
            self?.tableView.content(self?.realmArray)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }

    private func setupUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.register(DoorSnapshotTableViewCell.self,
                           forCellReuseIdentifier: String(describing: DoorSnapshotTableViewCell.self))

        tableView.register(SimpleTableViewCell.self,
                           forCellReuseIdentifier: String(describing: SimpleTableViewCell.self))
        setRefreshControl()
    }

    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshNews() {
        tableView.refreshControl?.beginRefreshing()
        Door.loadData { [weak self] in
            self?.tableView.content(self?.realmArray)
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    private func isSnapshot(door: Door?) -> Bool {
        door?.snapshot == nil ? false : true
    }

    private func changeName(actionHandler: ((_ text: String?) -> Void)?) {
        let alert = UIAlertController(title: "Введите имя",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField()
        let actionOK = UIAlertAction(title: "Ok",
                                     style: .default) { action in
            guard let textField =  alert.textFields?.first
            else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }
        let actionCancel = UIAlertAction(title: "Отмена",
                                         style: .cancel)
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        self.present(alert, animated: true)
    }
}

extension DoorsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let door = realmArray?[indexPath.row]
        else { return }
        let domofonVC = DomofonViewController(item: door)
        self.present(domofonVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        isSnapshot(door: realmArray?[indexPath.row]) ? heightRowWithSnapshot : heightRowWithoutSnapshot
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let change = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, complition in

            self?.changeName { text in
                try? RealmService.changeNameDoor(object: self?.realmArray?[indexPath.row],
                                            value: text)
                tableView.reloadData()
            }
            complition(true)
        }
        change.backgroundColor = .customBackgroundColor
        change.image = UIImage(named: "edit")

        let favorite = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, complition in
            try? RealmService.changeFavoriteDoor(object: self?.realmArray?[indexPath.row])
            tableView.reloadData()
            complition(true)
        }
        favorite.backgroundColor = .customBackgroundColor
        favorite.image = UIImage(named: "star")

        let configuration = UISwipeActionsConfiguration(actions: [change,favorite])
        return configuration
    }
}
