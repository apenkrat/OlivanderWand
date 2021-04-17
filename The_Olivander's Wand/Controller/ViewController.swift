//
//  ViewController.swift
//  The_Olivander's Wand
//
//  Created by Alex Penkrat on 04/17/2021.
//  Copyright © 2021 Alex Penkrat. All rights reserved.
//

import UIKit

// declare an audioPlayer
import AVFoundation

class ViewController: UIViewController {
    
    var spells = Spells()

    // declare an audioPlayer used for the extra credit
    var audioPlayer: AVAudioPlayer!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //added to call and get the data.
        spells.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        //extra credit to make the harry them play
            self.playSound(soundName: "HarryTheme")
            self.animateTable()
        }
    }
    //Important to know for capturing the information from the list to pass to the detail view controller. makes ure ShowDetail is correct. it will not flag error.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //technically you do not need te if since its the only segue but a good practice. in case you have multiple situations occuring.
        if segue.identifier == "ShowDetail" {
            //As is castign it to a specific class.
            let destination = segue.destination as! SpellDetailViewController
            //tells you what row was pressed
            let selected = tableView.indexPathForSelectedRow!
            destination.spellData = spells.spellArray[selected.row]
        }
    }
    
    // Add a playSound function for extra credit
    func playSound(soundName: String) {
        if let sound = NSDataAsset(name: soundName) {
                do {
                         try audioPlayer = AVAudioPlayer(data: sound.data)
                         audioPlayer.play()
                } catch {
                         print("ERROR: Data from \(soundName) could not be played as an audio file")
                }
            } else {
                print("ERROR: Could not load data from file \(soundName)")
            }
    }
//add animate table as extra credit
    func animateTable() {
          // Reloading tableView below gets all cells that will be shown in the tableView so that they can then be moved off screen, then animated on screen.
          tableView.reloadData()
          
          // Returns an array of tableViewCells containing the number of cells that can be viewed on screen
          let cells = tableView.visibleCells
          // Find out how big the cells are
          let tableHeight: CGFloat = tableView.bounds.size.height
          
          // Loop through all of the cells and move them off screen
          for cell in cells {
              // Move cell off screen (tableHeight is the bottom of the table view, so a cell set to have it's y value at the bottom cannot be seen).
              cell.frame.origin.y = tableHeight
          }
          
          // This will be used to set the delay, starting at 0.05 * 0, then, since it's incremented as you loop through, increasing to 0.05 * 1, then 0.05 * 2, then 0.05 * 3
          var index = 0
          
          for cell in cells {
              // Animate the cell to where it should be (cell.frame.origin.y = 0), add a bit of bounce using Spring parameters, and increase the delay by 0.05 for each new cell (so they animate one after the other)
              UIView.animate(withDuration: 2.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                  cell.frame.origin.y = cell.frame.height*CGFloat(index)})
              index += 1 // increment's delay multiplier
          }
      }
}

//alwasy seperate to be able to reuse.
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spells.spellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = spells.spellArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
