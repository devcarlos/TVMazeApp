//
//  PersonDataSource.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

class PersonListDataSource : GenericDataSource<Person>, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.reuseID, for: indexPath) as! PersonCell
        
        let person = data[indexPath.row]
        
        cell.configure(with: person)
        
        return cell
    }
}
