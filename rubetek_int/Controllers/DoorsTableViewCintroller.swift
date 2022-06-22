//
//  DooorsTV.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit
import RealmSwift

final class DoorsTableViewCintroller: UIViewController, TableViewProtocol {

    typealias RealmType = Door

    var realmArray: Results<Door>?
    var tableView: CustomTableView = CustomTableView(frame: .zero, style: .plain)
    var notificationToken: NotificationToken?

    private let heightRowWithSnapshot = CGFloat(298)
    private let heightRowWithoutSnapshot = CGFloat(90)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()
        checkData()
        setObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }

    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SnapshotTableViewCell.self, forCellReuseIdentifier: SnapshotTableViewCell.reuseIdentifire)
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.reuseIdentifire)
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
        let netRouter = NetworkRouter()
        netRouter.getDoors { [weak self] doors, error in
            self?.tableView.refreshControl?.endRefreshing()
            guard let doorsArrray = doors
            else { return }
            try? RealmService.save(items: doorsArrray)
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

extension DoorsTableViewCintroller: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSnapshot(door: realmArray?[indexPath.row]) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SnapshotTableViewCell.reuseIdentifire, for: indexPath) as? SnapshotTableViewCell
            else { return UITableViewCell() }

            cell.configure(door: realmArray?[indexPath.row])
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableViewCell.reuseIdentifire, for: indexPath) as? SimpleTableViewCell
            else { return UITableViewCell() }
            cell.configure(item: realmArray?[indexPath.row])
            return cell
        }
    }
}

extension DoorsTableViewCintroller: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        isSnapshot(door: realmArray?[indexPath.row]) ? heightRowWithSnapshot : heightRowWithoutSnapshot
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let change = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, complition in

            self?.changeName { text in
                try? RealmService.changeNameDoor(object: self?.realmArray?[indexPath.row],
                                            value: text)
            }
            complition(true)
        }
        change.backgroundColor = .customBackgroundColor
        change.image = UIImage(named: "edit")

        let favorite = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, complition in
            try? RealmService.changeFavoriteDoor(object: self?.realmArray?[indexPath.row])
            complition(true)
        }
        favorite.backgroundColor = .customBackgroundColor
        favorite.image = UIImage(named: "star")

        let configuration = UISwipeActionsConfiguration(actions: [change,favorite])
        return configuration
    }
}
