//
//  CustomSegmentControll.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import UIKit

final class CustomSegmentControll: UIView {

    private var items: [String]

    private enum Constants {
        static let underlineViewColor: UIColor = .blueTintColor
        static let underlineViewHeight: CGFloat = 2
    }

    private lazy var navBar: UITabBar = {
        let navbar = UITabBar()
        navbar.layer.borderColor = UIColor.customBackgroundColor.cgColor
        navbar.layer.masksToBounds = true
        navbar.barTintColor = .customBackgroundColor
        navbar.tintColor = .black
        navbar.unselectedItemTintColor = .black
        navbar.translatesAutoresizingMaskIntoConstraints = false
        navbar.setItems(getItems(), animated: true)
        selectedIndex?(0)
        return navbar
    }()

    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()

    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: navBar.leftAnchor)
    }()

    var selectedIndex: ((Int) -> Void)?

    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .customBackgroundColor
        self.addSubview(navBar)
        self.addSubview(bottomUnderlineView)
        navBar.delegate = self

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: self.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            navBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            navBar.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            bottomUnderlineView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
            leadingDistanceConstraint,
            bottomUnderlineView.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 1 / CGFloat(navBar.items?.count ?? 2))
        ])
    }

    private func getItems() -> [UITabBarItem] {
        let tabBarItems = items
            .enumerated()
            .map { UITabBarItem(title: $0.element, image: nil, tag: $0.offset)}

        tabBarItems.forEach {
            $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -16.0)
            $0.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.segmentItemFont as Any], for: .normal)
            $0.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.segmentItemFont as Any], for: .selected)
        }
        return tabBarItems
    }

    private func changeSegmentedControlLinePosition() {
        guard let selectedItem = navBar.selectedItem?.tag,
              let countItems = navBar.items?.count
        else { return }

        selectedIndex?(selectedItem)
        let segmentIndex = CGFloat(selectedItem)
        let segmentWidth = navBar.frame.width / CGFloat(countItems)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
            self?.layoutIfNeeded()
        })
    }
}

extension CustomSegmentControll: UITabBarDelegate {

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        changeSegmentedControlLinePosition()
    }
}
