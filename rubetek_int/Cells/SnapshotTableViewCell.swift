//
//  SnapshotTableViewCell.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import UIKit

final class SnapshotTableViewCell: AbstractTableViewCell {

    static let reuseIdentifire = "SnapshotTableViewCell"

    private lazy var snapShotView: SnapShotView = {
        let snapShotView = SnapShotView()
        snapShotView.translatesAutoresizingMaskIntoConstraints = false
        return snapShotView
    }()

    private lazy var titleView: TitleView = {
        let titleView = TitleView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        return titleView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func clearCell() {
        super.clearCell()
        snapShotView.clearView()
        titleView.clearView()
    }

    override func setupUI() {
        super.setupUI()
        backgroundCellView.addSubview(snapShotView)
        backgroundCellView.addSubview(titleView)
        setConstreint()
    }

    private func setConstreint() {

        NSLayoutConstraint.activate([
            snapShotView.topAnchor.constraint(equalTo: backgroundCellView.topAnchor),
            snapShotView.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor),
            snapShotView.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: snapShotView.bottomAnchor),
            titleView.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }

    func configure(door: Door?) {
        snapShotView.configure(image: door?.snapshot, rec: false, favorite: door?.favorites)
        titleView.configure(title: door?.name, status: nil, image: UIImage(named: "guardoff"))
    }

    func configure(camera: Camera?) {
        snapShotView.configure(image: camera?.snapshot, rec: camera?.rec, favorite: camera?.favorites)
        titleView.configure(title: camera?.name, status: nil, image: UIImage(named: "guardoff"))
    }
}
