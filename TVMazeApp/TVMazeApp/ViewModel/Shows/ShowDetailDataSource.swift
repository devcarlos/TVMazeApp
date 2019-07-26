//
//  ShowDetailDataSource.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

//TODO: handle with Collections
class ShowDetailDataSource : GenericDataSource<Episode>, UITableViewDataSource {
    
    var show: Show?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseID, for: indexPath) as! EpisodeCell

        //        let episode = data[indexPath.row]
        //
        //        cell.configure(with: episode)

        
        return cell
    }
}

