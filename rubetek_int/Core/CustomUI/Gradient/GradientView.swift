//
//  GradientView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 24.06.2022.
//
import UIKit

class GradientView: UIView {


    var color: [CGColor] = [UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.67).cgColor,
                            UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.00).cgColor]

    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSelf() {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = color
        backgroundColor = UIColor.clear
    }

    func reversColor() {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            color[1],
            color[0]
        ]
        backgroundColor = UIColor.clear

    }
}
