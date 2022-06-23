//
//  DoorSnapshotTableViewCell.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 23.06.2022.
//

import UIKit

final class DoorSnapshotTableViewCell: SnapshotTableViewCell, ConfigurableCell {
    typealias DataType = Door

    func configure(data: Door?) {
        snapShotView.configure(image: data?.snapshot, rec: false, favorite: data?.favorites)
        titleView.configure(title: data?.name, status: nil, image: UIImage(named: "guardoff"))
    }
}

