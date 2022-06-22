//
//  CamsTableView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 21.06.2022.
//

import UIKit
import RealmSwift

final class CamsTableView: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customBackgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var cameraArray: Results<Camera>?
    private var notificationToken: NotificationToken?

    private let heightRow = CGFloat(298)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        view.addSubview(tableView)
        setupTableView()
        checkData()

        notificationToken = cameraArray?.observe({ [weak self] change in
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
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SnapshotTableViewCell.self, forCellReuseIdentifier: SnapshotTableViewCell.reuseIdentifire)
        setRefreshControl()
    }

    private func checkData() {
        cameraArray = try? RealmService.load(typeOf: Camera.self)
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

extension CamsTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cameraArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SnapshotTableViewCell.reuseIdentifire, for: indexPath) as? SnapshotTableViewCell
        else { return UITableViewCell() }

        cell.configure(camera: cameraArray?[indexPath.row])
        return cell
    }
}

extension CamsTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightRow
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, complition in
            complition(true)
        }
        favorite.backgroundColor = .customBackgroundColor
        favorite.image = UIImage(named: "star")

        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        return configuration
    }
}
