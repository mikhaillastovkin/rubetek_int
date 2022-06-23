//
//  RootViewController.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit

final class RootViewController: UIViewController {

    private var controllers: [UIViewController]

    private lazy var maintitle: MainTitleLable = {
        let maintitle = MainTitleLable(title: "Мой дом")
        return maintitle
    }()

    private lazy var segmentedControll: CustomSegmentControll = {
        let items = controllers.map { $0.title ?? "" }
        let segmentedControll = CustomSegmentControll(items: items)
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControll
    }()

    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    init(controllers: [UIViewController]) {
        self.controllers = controllers
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        segmentedControll.selectedIndex = { [weak self] index in
            guard let controller = self?.controllers[index]
            else { return }
            self?.addController(controller)
        }
    }

    private func addController(_ controller: UIViewController) {
        self.contentView.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
        controller.view.frame = self.contentView.bounds
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
