//
//  CameraSnapshotTableViewCell.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 23.06.2022.
//

import UIKit

final class CameraSnapshotTableViewCell: SnapshotTableViewCell, ConfigurableCell {

    typealias DataType = Camera

    func configure(data: Camera?) {
        snapShotView.configure(image: data?.snapshot,
                               rec: data?.rec,
                               favorite: data?.favorites)
        titleView.configure(title: data?.name,
                            status: nil,
                            image: UIImage(named: "guardoff"))
    }
}
