//
//  CamsTableViewController.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit
import RealmSwift

final class CamsTableViewController: UIViewController {

    var tableView = CamerasTableView(frame: .zero, style: .plain)

    var realmArray: Results<Camera>?

    var notificationToken: NotificationToken?

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        Camera.loadData { [weak self] in
            self?.realmArray = try? Camera.getData()
            self?.tableView.content(self?.realmArray)

            self?.notificationToken = self?.realmArray?.observe({ change in
                switch change {
                case .initial(_):
                    self?.tableView.reloadData()
                case .update(_, deletions: _, insertions: _, modifications: _):
                    self?.tableView.content(self?.realmArray)
                case .error(let error):
                    print(error)
                }
            })
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
        tableView.register(CameraSnapshotTableViewCell.self, forCellReuseIdentifier:
                            String(describing: CameraSnapshotTableViewCell.self))
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
        Camera.loadData { [weak self] in
            self?.tableView.content(self?.realmArray)
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
}
