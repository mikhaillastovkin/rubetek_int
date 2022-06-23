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

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .blue
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var topGradientView: GradientView = {
        let gradientView = GradientView(frame: .zero)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()

    private lazy var bottomGradientView: GradientView = {
        let bottomGradientView = GradientView(frame: .zero)
        bottomGradientView.reversColor()
        bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
        return bottomGradientView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var streamIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stream")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var steamLabel: UILabel = {
        let steamLabel = UILabel()
        steamLabel.text = "Прямая трансляция"
        steamLabel.textColor = .white
        steamLabel.font = .steamLabelFont
        steamLabel.translatesAutoresizingMaskIntoConstraints = false
        return steamLabel
    }()

    private lazy var fullScreenButton: UIImageView = {
        let fullScreenButton = UIImageView()
        fullScreenButton.image = UIImage(named: "fullScreen")
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(pressFullScreen))
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        return fullScreenButton
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
        contentView.addSubview(imageView)
        contentView.addSubview(topGradientView)
        contentView.addSubview(bottomGradientView)
        contentView.addSubview(streamIndicator)
        contentView.addSubview(steamLabel)
        contentView.addSubview(fullScreenButton)
        view.addSubview(keyButton)
        setConstraints()
        loadImage()
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
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            topGradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topGradientView.heightAnchor.constraint(equalToConstant: 75)
        ])

        NSLayoutConstraint.activate([
            bottomGradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 75)
        ])

        NSLayoutConstraint.activate([
            streamIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            streamIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            streamIndicator.heightAnchor.constraint(equalToConstant: 14),
            streamIndicator.widthAnchor.constraint(equalToConstant: 14)
        ])

        NSLayoutConstraint.activate([
            steamLabel.leadingAnchor.constraint(equalTo: streamIndicator.trailingAnchor, constant: 11),
            steamLabel.centerYAnchor.constraint(equalTo: streamIndicator.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            fullScreenButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            fullScreenButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            fullScreenButton.heightAnchor.constraint(equalToConstant: 12),
            fullScreenButton.widthAnchor.constraint(equalToConstant: 12),
        ])

        NSLayoutConstraint.activate([
            keyButton.heightAnchor.constraint(equalToConstant: 105),
            keyButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            keyButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            keyButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -98)
        ])
    }

    @objc private func pressFullScreen() {

    }

    private func loadImage() {
        guard let urlString = item.snapshot,
              let url = URL(string: urlString)
        else { return }
        Nuke.loadImage(with: url, into: imageView)
    }
}
