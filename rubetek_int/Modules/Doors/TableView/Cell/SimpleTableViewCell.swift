//
//  SimpleTableViewCell.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 21.06.2022.
//

import UIKit

final class SimpleTableViewCell: AbstractTableViewCell, ConfigurableCell {
    typealias DataType = Door

    private lazy var titleView: TitleView = {
        let titleView = TitleView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        return titleView
    }()

    override func clearCell() {
        super.clearCell()
        titleView.clearView()
    }

    override func setupUI() {
        super.setupUI()
        backgroundCellView.addSubview(titleView)

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: backgroundCellView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor),
        ])
    }

    func configure(data item: Door?) {
        if item?.userName != nil {
            titleView.configure(title: item?.userName, status: nil, image: UIImage(named: "lockoff"))
        } else {
            titleView.configure(title: item?.name, status: nil, image: UIImage(named: "lockoff"))
        }
    }
}
