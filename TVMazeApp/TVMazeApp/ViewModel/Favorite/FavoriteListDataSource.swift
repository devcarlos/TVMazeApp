//
//  FavoriteListDataSource.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/29/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit

class FavoriteListDataSource : GenericDataSource<Show>, UICollectionViewDataSource {
    
//    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCell.reuseID, for: indexPath) as! ShowCell
        
        let show = data[indexPath.row]
        
        cell.delegate = collectionView.delegate as? FavoriteShowDelegate
        cell.configure(with: show)
        
        return cell
    }
}
