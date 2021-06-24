//
//  MapViewController.swift
//  Disco
//
//  Created by Richard Hult on 2021-06-24.
//

import UIKit
import CoreNFC
import AVFoundation

struct Hole {
    let location: CGPoint
    let number: Int
}

struct Stats : Decodable {
    var name: String
    var score: Int
    var hole: Int
}

struct Score : Decodable {
    var score: Int
}

class MapViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
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
            Hole(location: CGPoint(x: 250, y: 468), number: 7),
            Hole(location: CGPoint(x: 226, y: 363), number: 8),
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


    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("session invalidate \(error)")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = UserDefaults.standard.string(forKey: "player")
        refreshScore()
    }
    
    func refreshScore() {
        guard let player = UserDefaults.standard.string(forKey: "player") else { return }
        getScore(player: player) { score in
            if let score = score {
                self.scoreLabel.text = "\(score)"
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("detected NDEF \(messages)")
        for m in messages {
            for r in m.records {
                if let str = r.wellKnownTypeTextPayload().0 {
                    if let score = Int(str) {
                        setScore(score: score)
                        return
                    }
                }
            }
        }
    }
    
    func getScore(player: String, callback: @escaping (Int?) -> Void) {
        let url = URL(string: "https://discobackend.azurewebsites.net/Disco/getscores?name=\(player)")!
        let t = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, err in
            if let data = data {
                
                if let score = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        callback(Int(score))
                    }
                }
            }
        }
        t.resume()
    }

    
    func setScore(score: Int) {
        let hole = UserDefaults.standard.integer(forKey: "hole")
        if let player = UserDefaults.standard.string(forKey: "player") {
            if let url = URL(string: "https://discobackend.azurewebsites.net/Disco/setscoredb?player=\(player)&hole=\(hole)&score=\(score)") {
                let t = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, err in
                    
                    if let data = data {
                        let response = try? JSONDecoder().decode(Stats.self, from: data)
                        print(response ?? "")
                    }
                    self.refreshScore()
                }
                t.resume()
            }
        }
    }

    @IBAction func holeTapped(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        print("Hej \(button.tag)")
        UserDefaults.standard.setValue(button.tag, forKey: "hole")
        
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session.alertMessage = "Slag på hål \(button.tag)"
        session.begin()
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
