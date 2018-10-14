//
//  BallDataSource.swift
//  DropBall
//
//  Created by Vinitha Vijayan on 2/6/18.
//  Copyright © 2018 Vinitha Vijayan. All rights reserved.
//

import Foundation

class BallDataSource {
    static let intstance = BallDataSource()
    
    func prepareDefaultData() -> [Int: [String]] {
        var dataDict = [Int: [String]]()

        for i in 0...kTotalColums-1 {
            var columnArray = [String]()
            
            for _ in 0...kTotalColums-1 {
                columnArray.append("x")
            }
            
            dataDict[i] = columnArray
        }
        
        return dataDict
    }
}
