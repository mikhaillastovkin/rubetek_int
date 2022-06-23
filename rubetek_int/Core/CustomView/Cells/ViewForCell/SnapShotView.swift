//
//  SnapShotView.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import UIKit
import Nuke

final class SnapShotView: UIView {

    private lazy var snapShotImage: UIImageView = {
        let snapShotImage = UIImageView()
        snapShotImage.contentMode = .scaleAspectFill
        snapShotImage.clipsToBounds = true
        return snapShotImage
    }()

    private lazy var recImage: UIImageView = {
        let recImage = UIImageView()
        recImage.image = UIImage(named: "rec")
        recImage.contentMode = .scaleAspectFit
        recImage.isHidden = true
        return recImage
    }()

    private lazy var favoriteImage: UIImageView = {
        let favoriteImage = UIImageView()
        favoriteImage.image = UIImage(named: "favorite")
        favoriteImage.contentMode = .scaleAspectFit
        favoriteImage.isHidden = true
        return favoriteImage
    }()

    private lazy var snapShotButton: UIButton = {
        let snapShotButton = UIButton()
        snapShotButton.setImage(UIImage(named: "playButton"), for: .normal)
        return snapShotButton
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(snapShotImage)
        self.addSubview(snapShotButton)
        self.addSubview(recImage)
        self.addSubview(favoriteImage)
        setFrames()
    }

    private func setFrames() {

        let width = self.frame.width
        let height = self.frame.height

        let sizeImage = CGSize(width: 24, height: 24)
        let sizeButton = CGSize(width: 60, height: 60)

        let inset = CGFloat(8)

        snapShotImage.frame = self.bounds
        snapShotButton.frame = CGRect(x: width / 2 - sizeButton.width / 2,
                                      y: height / 2 - sizeButton.height / 2,
                                      width: sizeButton.width,
                                      height: sizeButton.height)
        recImage.frame = CGRect(x: inset,
                                y: inset,
                                width: sizeImage.width,
                                height: sizeImage.height)

        favoriteImage.frame = CGRect(x: width - (sizeImage.width + inset),
                                     y: inset,
                                     width: sizeImage.width,
                                     height: sizeImage.height)
    }

    private func isHiddenBages(rec: Bool, favorite: Bool) {
        recImage.isHidden = !rec
        favoriteImage.isHidden = !favorite
    }

    private func brightnessFilter(image: UIImage?, andApplyToView view: UIImageView) {
        DispatchQueue.global(qos: .userInteractive).async {
            let beginImage = CIImage(image: image!)
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(beginImage, forKey: kCIInputImageKey)
            filter?.setValue(-0.25, forKey: kCIInputBrightnessKey)
            let filteredImage = filter?.outputImage!
            let context = CIContext()
            let cgiImage = context.createCGImage(filteredImage!, from: filteredImage!.extent)
            let returnImage = UIImage(cgImage: cgiImage!)
            DispatchQueue.main.async {
                view.image = returnImage
            }
        }
    }

    func loadImage(from: String?, for view: UIImageView) {
        guard let from = from,
              let url = URL(string: from)
        else { return }
        Nuke.cancelRequest(for: view)
        Nuke.loadImage(with: url, into: view)
    }
    
    func clearView() {
        snapShotImage.image = nil
        isHiddenBages(rec: false, favorite: false)
    }

    func configure(image: String?, rec: Bool?, favorite: Bool?) {
        loadImage(from: image, for: snapShotImage)
        isHiddenBages(rec: rec ?? false, favorite: favorite ?? false)
    }
}
