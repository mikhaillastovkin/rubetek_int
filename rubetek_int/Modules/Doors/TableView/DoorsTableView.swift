//
//  DoorsTableView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 23.06.2022.
//

import Foundation
import RealmSwift

final class DoorsTableView: CustomTableView {

    private let heightRowWithSnapshot = CGFloat(298)
    private let heightRowWithoutSnapshot = CGFloat(90)

    func content(_ doors: Results<Door>?) {
        guard let doors = doors
        else { return }
        let items: [CellConfigurator] = doors.map { (door: Door) -> CellConfigurator in
            door.snapshot != nil ? DoorSnapshotCellConfig(item: door) : DoorSimpleCellCOnfig(item: door)
        }
        self.items = [items]
        self.reloadData()
    }
}
