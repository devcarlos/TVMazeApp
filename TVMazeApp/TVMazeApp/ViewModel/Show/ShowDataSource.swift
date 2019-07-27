//
//  ShowDataSource.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

class ShowDataSource : GenericDataSource<Season>, UITableViewDataSource {
    
    var show: Show?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].episodes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let season = data[section]
        return "Season \(season.season)"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)

        let episode = data[indexPath.section].episodes[indexPath.row]
        
        cell.textLabel?.text = episode.name
        
        return cell
    }
}

