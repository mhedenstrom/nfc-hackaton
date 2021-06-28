
import UIKit
import CoreNFC
import AVFoundation


struct Stats : Decodable {
    var name: String
    var score: Int
    var hole: Int
}

struct Score : Decodable {
    var score: Int
}


class MapViewController: UIViewController, UIScrollViewDelegate, NFCNDEFReaderSessionDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    private let circleRadius: CGFloat = 14
    private var courseType = CourseType.holes9
    private var lastCourseType = CourseType.holes9
    private var buttonsLoaded = false
    private var buttons: [Int: UIButton] = [:]


    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = UserDefaults.standard.string(forKey: "player")
        refreshScore()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateMap(with: courseType)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if buttonsLoaded == false { return }

        let imageRect = CGRect(origin: .zero, size: mapView.image!.size)
        let scaledRect = imageRect.aspect(viewRect: mapView.bounds, mode: .scaleAspectFit)
        for hole in courseType.holes {
            let button = buttons[hole.number]!

            button.frame = CGRect(
                x: scaledRect.origin.x + CGFloat(hole.location.x) * scaledRect.width / imageRect.width - circleRadius,
                y: scaledRect.origin.y + CGFloat(hole.location.y) * scaledRect.height / imageRect.height - circleRadius,
                width: circleRadius * 2,
                height: circleRadius * 2
            )
        }
    }


    // MARK: - Zoooooom

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapView
    }


    // MARK: - Actions

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

    @IBAction func switchTapped(_ sender: Any) {
        switch courseType {
        case .holes9:
            courseType = .holes18
        case .holes18:
            courseType = .holes9
        case .info:
            courseType = lastCourseType
        }
        lastCourseType = courseType
        updateMap(with: courseType)
    }

    @IBAction func infoTapped(_ sender: Any) {
        if courseType == .info {
            courseType = lastCourseType
        } else {
            courseType = .info
        }
        updateMap(with: courseType)

    }


    // MARK: - NFC

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("session invalidate \(error)")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("detected NDEF \(messages)")
        for m in messages {
            for r in m.records {
                if let str = r.wellKnownTypeTextPayload().0 {
                    if let score = Int(str) {
                        setScore(score: score)
                        session.alertMessage = "Du fick \(score) kast"
                        session.invalidate()
                        return
                    }
                }
            }
        }
    }


    // MARK: - Update Score

    func refreshScore() {
        guard let player = UserDefaults.standard.string(forKey: "player") else { return }
        getScore(player: player) { score in
            if let score = score {
                self.scoreLabel.text = "\(score)"
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


    // MARK: - Update Map

    private func updateMap(with type: CourseType) {
        mapView.image = courseType.image
        mapView.backgroundColor = courseType.backgroundColour
        scrollView.backgroundColor = courseType.backgroundColour
        placeHoles(for: type)
    }

    private func placeHoles(for type: CourseType) {
        _ = mapView.subviews.map { $0.removeFromSuperview() }
        for hole in type.holes {
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
        buttonsLoaded = true
        view.setNeedsLayout()
    }

}


