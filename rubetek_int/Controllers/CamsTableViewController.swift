//
//  CamsTableViewController.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit
import RealmSwift

final class CamsTableViewController: UIViewController, TableViewProtocol {

    typealias RealmType = Camera

    var tableView: CustomTableView = CustomTableView(frame: .zero, style: .plain)

    var realmArray: Results<Camera>?
    var notificationToken: NotificationToken?

    private let heightRow = CGFloat(298)

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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SnapshotTableViewCell.self, forCellReuseIdentifier: SnapshotTableViewCell.reuseIdentifire)
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
        netRouter.getCams { [weak self] cameras, error in
            self?.tableView.refreshControl?.endRefreshing()
            guard let cameras = cameras?.cameras
            else { return }
            try? RealmService.save(items: cameras)
        }
    }
}

extension CamsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        realmArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SnapshotTableViewCell.reuseIdentifire, for: indexPath) as? SnapshotTableViewCell
        else { return UITableViewCell() }

        cell.configure(camera: realmArray?[indexPath.row])
        return cell
    }
}

extension CamsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightRow
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let favorite = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, complition in
            try? RealmService.changeFavoriteCamera(object: self?.realmArray?[indexPath.row])
            complition(true)
        }
        favorite.backgroundColor = .customBackgroundColor
        favorite.image = UIImage(named: "star")

        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        return configuration
    }
}
