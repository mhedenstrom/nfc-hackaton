//
//  MapViewController.swift
//  Disco
//
//  Created by Richard Hult on 2021-06-24.
//

import UIKit
import AVFoundation

struct Hole {
    let location: CGPoint
    let number: Int
}

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: UIImageView!

    private let circleRadius: CGFloat = 14
    private var holes: [Hole] = []
    private var buttons: [Int: UIButton] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Original unscaled coordinates here.
        holes = [
            Hole(location: CGPoint(x: 346, y: 79), number: 1),
            Hole(location: CGPoint(x: 438, y: 45), number: 2),
            Hole(location: CGPoint(x: 374, y: 265), number: 3),
            Hole(location: CGPoint(x: 349, y: 628), number: 4),
            Hole(location: CGPoint(x: 280, y: 719), number: 5),
            Hole(location: CGPoint(x: 143, y: 757), number: 6),
            Hole(location: CGPoint(x: 0, y: 0), number: 7),
            Hole(location: CGPoint(x: 0, y: 0), number: 8),
            Hole(location: CGPoint(x: 309, y: 322), number: 9),
        ]

        for hole in holes {
            let button = UIButton(type: .custom)
            button.backgroundColor = .blue
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 3
            button.layer.cornerRadius = circleRadius
            button.setTitle("\(hole.number)", for: .normal)
            buttons[hole.number] = button
            button.tag = hole.number
            button.addTarget(self, action: #selector(holeTapped(_:)), for: .touchUpInside)
            mapView.addSubview(button)
        }
        mapView.isUserInteractionEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let imageRect = CGRect(origin: .zero, size: mapView.image!.size)
        let scaledRect = imageRect.aspectFill(viewRect: mapView.bounds)
        for hole in holes {
            let button = buttons[hole.number]!

            button.frame = CGRect(
                x: scaledRect.origin.x + CGFloat(hole.location.x) * scaledRect.width / imageRect.width - circleRadius,
                y: scaledRect.origin.y + CGFloat(hole.location.y) * scaledRect.height / imageRect.height - circleRadius,
                width: circleRadius * 2,
                height: circleRadius * 2
            )
        }
    }

    @IBAction func holeTapped(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        print("Hej \(button.tag)")
    }

}

extension CGRect {
    func aspectFill(viewRect: CGRect) -> CGRect {
        var scaledImageRect: CGRect = .zero

        let aspectWidth = viewRect.width / self.size.width
        let aspectHeight = viewRect.height / self.size.height
        let aspectRatio = max(aspectWidth, aspectHeight) // Note: Use min for aspect fit.

        scaledImageRect.size.width = self.width * aspectRatio
        scaledImageRect.size.height = self.height * aspectRatio
        scaledImageRect.origin.x = (viewRect.width - scaledImageRect.width) / 2.0
        scaledImageRect.origin.y = (viewRect.height - scaledImageRect.height) / 2.0

        return scaledImageRect
    }
}
