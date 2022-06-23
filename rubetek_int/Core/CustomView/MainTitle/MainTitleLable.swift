//
//  MainTitleLable.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 23.06.2022.
//

import UIKit

final class MainTitleLable: UILabel {

    init(title: String) {
        super.init(frame: .zero)
        text = title
        font = .viewMainTitleFont
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
