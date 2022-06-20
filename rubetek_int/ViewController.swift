//
//  ViewController.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import UIKit

class ViewController: UIViewController {

    let segment = CustomSegmentControll()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(segment)
        view.backgroundColor = .customBackgroundColor

        segment.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            segment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            segment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            segment.heightAnchor.constraint(equalToConstant: 44)
        ])
    }


}

