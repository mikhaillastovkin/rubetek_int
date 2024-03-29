//
//  CellConfigurator.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 23.06.2022.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType?)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {

    static var reuseId: String { return String(describing: CellType.self) }

    let item: DataType

    init(item: DataType) {
        self.item = item
    }

    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}

typealias CameraCellConfig = TableCellConfigurator<CameraSnapshotTableViewCell, Camera>
typealias DoorSnapshotCellConfig = TableCellConfigurator<DoorSnapshotTableViewCell, Door>
typealias DoorSimpleCellCOnfig = TableCellConfigurator<SimpleTableViewCell, Door>
