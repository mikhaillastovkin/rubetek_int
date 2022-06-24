//
//  CamerasTableView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 23.06.2022.
//

import Foundation
import RealmSwift

final class CamerasTableView: CustomTableView {

    private let heightRow = CGFloat(298)

    func content(_ cameras: Results<Camera>?) {
        guard let cameras = cameras
        else { return }

        let items: [[CellConfigurator]] = Dictionary(grouping: cameras) { $0.room }
            .map { $1.map { CameraCellConfig(item: $0) }
            }

        self.items = items
        self.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = items?[section].first as? CameraCellConfig
        else { return nil}
        return item.item.room ?? "Нет имени"
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView,
              let items = items?[section].first as? CameraCellConfig
        else { return }
        var content = header.defaultContentConfiguration()
        content.textProperties.font = .sectionTitleFont!
        content.text = items.item.room ?? "Нет имени"
        header.contentConfiguration = content
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightRow
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        guard let item = items?[indexPath.section][indexPath.row] as? CameraCellConfig
        else { return nil }

        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, complition in
            try? Camera.changeFavorite(object: item.item)
            complition(true)
        }
        favorite.backgroundColor = .customBackgroundColor
        favorite.image = UIImage(named: "star")

        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        return configuration
    }
}
