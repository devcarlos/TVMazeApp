//
//  PersonDataSource.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

class PersonDataSource : GenericDataSource<Show>, UITableViewDataSource {
    
    var person: Person?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonShowCell", for: indexPath)
        
        let show = data[indexPath.row]
        
        cell.textLabel?.text = show.name
        
        return cell
    }
}


