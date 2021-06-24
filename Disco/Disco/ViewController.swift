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
        // Do any additional setup after loading the view.
        spelare.text = UserDefaults.standard.string(forKey: "player")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        spelare.resignFirstResponder()
        performSegue(withIdentifier: "startPlaying", sender: self)
        UserDefaults.standard.setValue(spelare.text, forKey: "player")
        return true
    }
}
