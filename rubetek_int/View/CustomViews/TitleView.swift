//
//  TitleView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 21.06.2022.
//

import UIKit

final class TitleView: UIView {

    private lazy var title: UILabel = {
        let title = UILabel()
        title.font = .itemTitleFont
        title.numberOfLines = 1
        return title
    }()

    private lazy var statusTitle: UILabel = {
        let statusTitle = UILabel()
        statusTitle.font = .itemStatusFont
        statusTitle.textColor = .statusLabelColor
        statusTitle.numberOfLines = 1
        return statusTitle
    }()

    private lazy var titleImage: UIImageView = {
        let titleImage = UIImageView()
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()

    private lazy var titleStack: UIStackView = {
        let titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.addArrangedSubview(title)
        titleStack.spacing = 0
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        return titleStack
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        self.addSubview(titleStack)
        self.addSubview(titleImage)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleStack.trailingAnchor.constraint(equalTo: titleImage.leadingAnchor, constant: 24)
        ])

        NSLayoutConstraint.activate([
            titleImage.widthAnchor.constraint(equalToConstant: 24),
            titleImage.heightAnchor.constraint(equalToConstant: 24),
            titleImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            titleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func clearView() {
        title.text = nil
        statusTitle.text = nil
        titleImage.image = nil
    }

    func configure(title: String?, status: String?, image: UIImage?) {
        self.title.text = title
        self.titleImage.image = image

        if status != nil {
            self.statusTitle.text = status
            titleStack.addArrangedSubview(self.statusTitle)
        }
    }
}
