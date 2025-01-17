//
//  ShowListDataSource.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource<T> : NSObject {
    //TODO: replace with RxSwift
    var data: [T]
    
    override init() {
        data = []
    }
}

class ShowListDataSource : GenericDataSource<Show>, UICollectionViewDataSource {
    
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

//extension ShowListDataSource: FavoriteShowDelegate {
//    func didSaveFavorite(favorite: Bool) {
//        //NOTE: Update CollectionView if necessary
//    }
//
//    func handleFavoriteError(error: Error) {
//        //handle custom error
//        let message = "Error on Update Favorite: \(error.localizedDescription)"
//        self.onErrorHandling?(.custom(string: message))
//    }
//}
