//
//  CustomTableView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit

class CustomTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    var items: [[CellConfigurator]]?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupSelf()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSelf() {
        separatorStyle = .none
        backgroundColor = .customBackgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
    }

    func setupCell() {}

    func numberOfSections(in tableView: UITableView) -> Int {
        items?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?[section].count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let item = items?[indexPath.section][indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: type(of: item).reuseId)
        else { return UITableViewCell() }

        item.configure(cell: cell)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
