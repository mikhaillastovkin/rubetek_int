//
//  StreamView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 24.06.2022.
//

import UIKit
import Nuke

final class StreamView: UIView {

    let door: Door

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
        fullScreenButton.addGestureRecognizer(tapGR)
        fullScreenButton.isUserInteractionEnabled = true
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        return fullScreenButton
    }()

    init(door: Door) {
        self.door = door
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        addSubview(imageView)
        addSubview(topGradientView)
        addSubview(bottomGradientView)
        addSubview(streamIndicator)
        addSubview(steamLabel)
        addSubview(fullScreenButton)
        setupConstraint()
        checkOnAir()
        loadImage()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            topGradientView.topAnchor.constraint(equalTo: self.topAnchor),
            topGradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topGradientView.heightAnchor.constraint(equalToConstant: 75)
        ])

        NSLayoutConstraint.activate([
            bottomGradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomGradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 75)
        ])

        NSLayoutConstraint.activate([
            streamIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            streamIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13),
            streamIndicator.heightAnchor.constraint(equalToConstant: 14),
            streamIndicator.widthAnchor.constraint(equalToConstant: 14)
        ])

        NSLayoutConstraint.activate([
            steamLabel.leadingAnchor.constraint(equalTo: streamIndicator.trailingAnchor, constant: 11),
            steamLabel.centerYAnchor.constraint(equalTo: streamIndicator.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            fullScreenButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            fullScreenButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18),
            fullScreenButton.heightAnchor.constraint(equalToConstant: 12),
            fullScreenButton.widthAnchor.constraint(equalToConstant: 12),
        ])
    }

    private func checkOnAir() {
        if door.snapshot == nil {
            steamLabel.text = "Нет сигнала"
            streamIndicator.isHidden = true
        }
    }

    @objc private func pressFullScreen() {

    }

    private func loadImage() {
        guard let urlString = door.snapshot,
              let url = URL(string: urlString)
        else { return }
        Nuke.loadImage(with: url, into: imageView)
    }
}


