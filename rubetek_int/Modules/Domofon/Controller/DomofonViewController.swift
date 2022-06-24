//
//  DomofonViewController.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 23.06.2022.
//

import UIKit
import Nuke

final class DomofonViewController: UIViewController {

    private lazy var mainTitle: MainTitleLable = {
        let mainTitle = MainTitleLable(title: item.name ?? "Нет имени")
        return mainTitle
    }()

    private lazy var contentView: StreamView = {
        let contentView = StreamView(door: item)
        return contentView
    }()

    private lazy var keyButton: UIButton = {

        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "key")
        configuration.imagePlacement = .top

        let keyButton = UIButton(configuration: configuration)
        keyButton.setTitle("Открыть дверь", for: .normal)
        keyButton.backgroundColor = .white
        keyButton.setTitleColor(UIColor.gray, for: .normal)

        keyButton.layer.cornerRadius = 12
        keyButton.layer.masksToBounds = true
        keyButton.translatesAutoresizingMaskIntoConstraints = false
        return keyButton
    }()

    private lazy var settingView: UIView = {
        let settingView = UIView()
        settingView.backgroundColor = .white
        settingView.translatesAutoresizingMaskIntoConstraints = false
        return settingView
    }()

    private lazy var backButton: UIImageView = {
        let backButton = UIImageView()
        backButton.image = UIImage(named: "back")
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(pressBackButton))
        backButton.addGestureRecognizer(tapGR)
        backButton.isUserInteractionEnabled = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()

    private lazy var blackscreenButton: UIImageView = {
        let blackscreenButton = UIImageView()
        blackscreenButton.image = UIImage(named: "blackscreen")
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(pressblackscreenButton))
        blackscreenButton.addGestureRecognizer(tapGR)
        blackscreenButton.isUserInteractionEnabled = true
        blackscreenButton.translatesAutoresizingMaskIntoConstraints = false
        return blackscreenButton
    }()

    private let item: Door

    init(item: Door) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(mainTitle)
        view.addSubview(contentView)
        view.addSubview(keyButton)
        view.addSubview(settingView)
        settingView.addSubview(backButton)
        settingView.addSubview(blackscreenButton)
        setConstraints()
    }

    private func setConstraints() {

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            mainTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 27),
            mainTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 122),
            mainTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -122)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 18),
            contentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 215)
        ])

        NSLayoutConstraint.activate([
            keyButton.heightAnchor.constraint(equalToConstant: 105),
            keyButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            keyButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            keyButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -98)
        ])

        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -75),
            settingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 13),
            backButton.leadingAnchor.constraint(equalTo: settingView.leadingAnchor, constant: 8),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            backButton.widthAnchor.constraint(equalToConstant: 32)
        ])

        NSLayoutConstraint.activate([
            blackscreenButton.topAnchor.constraint(equalTo: settingView.topAnchor, constant: 13),
            blackscreenButton.trailingAnchor.constraint(equalTo: settingView.trailingAnchor, constant: -16),
            blackscreenButton.heightAnchor.constraint(equalToConstant: 32),
            blackscreenButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }

    @objc private func pressBackButton() {
        dismiss(animated: true)
    }

    @objc private func pressblackscreenButton() {

    }
}
