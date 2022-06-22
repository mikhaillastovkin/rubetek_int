//
//  DoorsTableView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit
import RealmSwift

final class DoorsTableView: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customBackgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var doorsArrray: Results<Door>?
    private var notificationToken: NotificationToken?

    private let heightRowWithSnapshot = CGFloat(298)
    private let heightRowWithoutSnapshot = CGFloat(72)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()
        checkData()

        notificationToken = doorsArrray?.observe({ [weak self] change in
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }

    private func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }

    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SnapshotTableViewCell.self, forCellReuseIdentifier: SnapshotTableViewCell.reuseIdentifire)
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.reuseIdentifire)
        setRefreshControl()
    }

    private func checkData() {
        doorsArrray = try? RealmService.load(typeOf: Door.self)
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
}

extension DoorsTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        doorsArrray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isSnapshot(door: doorsArrray?[indexPath.row]) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SnapshotTableViewCell.reuseIdentifire, for: indexPath) as? SnapshotTableViewCell
            else { return UITableViewCell() }

            cell.configure(door: doorsArrray?[indexPath.row])
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableViewCell.reuseIdentifire, for: indexPath) as? SimpleTableViewCell
            else { return UITableViewCell() }
            cell.configure(item: doorsArrray?[indexPath.row])
            return cell
        }
    }
}

extension DoorsTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        isSnapshot(door: doorsArrray?[indexPath.row]) ? heightRowWithSnapshot : heightRowWithoutSnapshot
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let change = UIContextualAction(style: .normal, title: nil) { action, view, complition in
            complition(true)
        }
        change.backgroundColor = .customBackgroundColor
        change.image = UIImage(named: "edit")

        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, complition in
            complition(true)
        }
        favorite.backgroundColor = .customBackgroundColor
        favorite.image = UIImage(named: "star")

        let configuration = UISwipeActionsConfiguration(actions: [change,favorite])
        return configuration
    }
}
