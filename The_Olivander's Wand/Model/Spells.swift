//
//  Spells.swift
//  The_Olivander's Wand
//
//  Created by Alex Penkrat on 04/17/2021.
//  Copyright © 2021 Alex Penkrat. All rights reserved.
//

import Foundation
class Spells {
    
    private struct Returned: Codable {
        
        var results: [SpellData] = []
        
    }
    
    //HELLLOOOooooooOOoooooo
    
    var spellArray: [SpellData] = []
    var url = "https://potterspells.herokuapp.com/api/v1/spells"
    //changes for json
    func getData(completed: @escaping ()->()) {
        let urlString = url
        print("Accessing URL\(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Error: Cant create a URL from\(urlString)")
            completed()
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error:\(error.localizedDescription)")
            }
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
                print(returned)
                self.spellArray = returned.results
            } catch {
                print("JSON Error:-\(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
}
