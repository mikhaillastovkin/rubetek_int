//
//  CustomTableView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import UIKit

final class CustomTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
        self.backgroundColor = .customBackgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
