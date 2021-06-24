//
//  ScoreboardViewController.swift
//  Disco
//
//  Created by Marcus Hedenström on 2021-06-24.
//

import Foundation
import UIKit

class ScoreboardViewController: UITableViewController {
    var board: [Stats] = []
    
    override func viewWillAppear(_ animated: Bool) {
        getScoreBoard() { scores in
            self.board = scores ?? []
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)
        let player = board[indexPath.row]
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text = "\(player.score)"
        return cell
    }
    
    func getScoreBoard(callback: @escaping ([Stats]?) -> Void) {
        let url = URL(string: "https://discobackend.azurewebsites.net/Disco/getalldb")!
        let t = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, urlResponse, err in
            if let data = data {
                let response = try? JSONDecoder().decode([Stats].self, from: data)
                print(response ?? "")
                DispatchQueue.main.async {
                    if let response = response {
                   
                        
                        var scores = Dictionary<String, Int>()
                        for s in response {
                            scores[s.name, default: 0] += s.score
                        }
                                 
                        let scoreboard = scores.map { Stats(name: $0.key, score: $0.value, hole:0) }.sorted { $0.score < $1.score }
                        callback(scoreboard)
                    }
                    
                }
            }
        }
        t.resume()
    }

}
