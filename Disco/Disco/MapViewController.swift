//
//  MapViewController.swift
//  Disco
//
//  Created by Richard Hult on 2021-06-24.
//

import UIKit

class MapViewController: UIViewController {

    @IBAction func holeTapped(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        print("Hej \(button.tag)")
    }
}
