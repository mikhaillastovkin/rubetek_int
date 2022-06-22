//
//  ViewController.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import UIKit
import RealmSwift

class TableViewController: UIViewController {

    private lazy var maintitle: UILabel = {
        let maintitle = UILabel()
        maintitle.text = "Мой дом"
        maintitle.font = .viewMainTitleFont
        maintitle.textAlignment = .center
        maintitle.translatesAutoresizingMaskIntoConstraints = false
        return maintitle
    }()

    private lazy var segmentedControll: CustomSegmentControll = {
        let segmentedControll = CustomSegmentControll()
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControll
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customBackgroundColor
        return tableView
    }()

    private var state: APIMethods = .cams {
        didSet {
            tableView.reloadData()
        }
    }

    private var camerasArrray: Results<Camera>?
    private var doorsArray: Results<Door>?
    private var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SnapshotTableViewCell.self, forCellReuseIdentifier: SnapshotTableViewCell.reuseIdentifire)
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.reuseIdentifire)
        tableView.dataSource = self
        tableView.delegate = self
        setupRefreshControl()

        segmentedControll.selectedIndex = { [weak self] index in
            switch index {
            case 0:
                self?.state = .cams
            case 1:
                self?.state = .doors
            default:
                self?.state = .cams
            }
        }
        checkData()

        notificationToken = camerasArrray?.observe({ [weak self] change in
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
        view.backgroundColor = .customBackgroundColor
        view.addSubview(maintitle)
        view.addSubview(segmentedControll)
        view.addSubview(tableView)
        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            maintitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 27),
            maintitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 122),
            maintitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -122)
        ])

        NSLayoutConstraint.activate([
            segmentedControll.topAnchor.constraint(equalTo: maintitle.bottomAnchor, constant: 18),
            segmentedControll.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            segmentedControll.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            segmentedControll.heightAnchor.constraint(equalToConstant: 44)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControll.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    private func checkData() {
//        let netRouter = NetworkRouter()
//        camerasArrray = try? RealmService.load(typeOf: Camera.self)
//        if ((camerasArrray?.isEmpty) != nil) {
//            netRouter.getData(for: .cams) { object, error in
//                guard let cameras = object as? [Camera]
//                else { return }
//                try? RealmService.save(items: cameras)
//            }
//        }
//
//        doorsArray = try? RealmService.load(typeOf: Door.self)
//        if ((doorsArray?.isEmpty) != nil) {
//            netRouter.getData(for: .doors) { object, error in
//                guard let doors = object as? [Door]
//                else { return }
//                try? RealmService.save(items: doors)
//            }
//        }
//        tableView.reloadData()
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshNews() {
//        tableView.refreshControl?.beginRefreshing()
//        let netRouter = NetworkRouter()
//        netRouter.getData(for: state) { [weak self] objects, error in
//            self?.tableView.refreshControl?.endRefreshing()
//
//            if let cameras = objects as? [Camera] {
//                try? RealmService.save(items: cameras)
//            }
//
//            if let doors = objects as? [Door] {
//                try? RealmService.save(items: doors)
//            }
//        }
    }
}

extension TableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .cams:
            return camerasArrray?.count ?? 0
        case .doors:
            return camerasArrray?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch state {
        case .cams:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: SnapshotTableViewCell.reuseIdentifire,for: indexPath) as? SnapshotTableViewCell
            else {
                return UITableViewCell()
            }

            cell.configure(camera: camerasArrray?[indexPath.row])
            return cell
            
        case .doors:
            switch doorsArray?[indexPath.row].snapshot {
            case .none:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableViewCell.reuseIdentifire,
                                                               for: indexPath) as? SimpleTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.configure(item: doorsArray?[indexPath.row])
                return cell

            case .some(_):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SnapshotTableViewCell.reuseIdentifire,
                                                               for: indexPath) as? SnapshotTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.configure(door: doorsArray?[indexPath.row])
                return cell
            }
        }
    }
}

extension TableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch state {
        case .cams:
            return 298
        case .doors:
            if doorsArray?[indexPath.row].snapshot == nil {
                return 90
            } else {
                return 298
            }
        }
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

        let configuration = UISwipeActionsConfiguration(actions: [change, favorite])
        return configuration
    }
}
