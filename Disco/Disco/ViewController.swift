//
//  ViewController.swift
//  Disco
//
//  Created by Richard Hult on 2021-06-24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var spelare: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(endEditing))
        )

        spelare.text = UserDefaults.standard.string(forKey: "player")
        spelare.clearButtonMode = .whileEditing
    }

    @objc
    func endEditing(sender: Any) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        spelare.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil || textField.text == "" {
            // UserDefaults.standard.removeObject(forKey: "player")
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        } else {
            UserDefaults.standard.setValue(spelare.text, forKey: "player")
        }
    }
}
