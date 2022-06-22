//
//  RootViewController.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit

final class RootViewController: UIViewController {

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

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = true
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camsVC = CamsTableViewController()
        let doorsVC = DoorsTableViewCintroller()

        segmentedControll.selectedIndex = { [weak self] index in
            switch index {
            case 0:
                self?.contentView.addSubview(camsVC.view)
                self?.addChild(camsVC)
                camsVC.didMove(toParent: self)
            case 1:
                self?.contentView.addSubview(doorsVC.view)
                self?.addChild(doorsVC)
                doorsVC.didMove(toParent: self)
            default:
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(maintitle)
        view.addSubview(segmentedControll)
        view.addSubview(contentView)
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
            contentView.topAnchor.constraint(equalTo: segmentedControll.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
