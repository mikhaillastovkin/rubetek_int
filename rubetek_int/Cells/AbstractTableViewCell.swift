//
//  AbstractTableViewCell.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 21.06.2022.
//

import UIKit

class AbstractTableViewCell: UITableViewCell {

    lazy var backgroundCellView: UIView = {
        let backgroundCellView = UIView()
        backgroundCellView.backgroundColor = .systemGray5
        backgroundCellView.layer.cornerRadius = 12
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundCellView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func clearCell() {

    }

    func setupUI() {
        contentView.backgroundColor = .customBackgroundColor
        contentView.addSubview(backgroundCellView)

        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate ([
            backgroundCellView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 18),
            backgroundCellView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 21),
            backgroundCellView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -21),
            backgroundCellView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
