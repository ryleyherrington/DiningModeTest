//
//  DateTransformer.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/26/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import Foundation

class DateTransformer: NSObject {
    
    private static let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd HH:mm"
        return df
    }()
    
    func transformToString(date: Date) -> String {
        return DateTransformer.formatter.string(from: date)
    }
}
