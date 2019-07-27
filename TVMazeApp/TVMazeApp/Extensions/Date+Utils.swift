//
//  Date+Utils.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

extension Date {
    func getFormattedDate(formatter:String = "MMM dd, yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: self)
    }
}
