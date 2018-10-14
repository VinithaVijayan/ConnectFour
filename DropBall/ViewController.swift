//
//  ViewController.swift
//  DropBall
//
//  Created by Vinitha Vijayan on 2/3/18.
//  Copyright © 2018 Vinitha Vijayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var finalStatusLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataDict = [Int: [String]]()
    var currentBall: String = "*"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        showDefaultData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 0.75 * screenWidth/CGFloat(kTotalColums), height:  0.75 * screenWidth/CGFloat(kTotalRows))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    //CollectionViewDataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataDict.first?.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataDict.keys.count
    }
    
    //CollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! Cell
        let data = dataDict[indexPath.row]?[indexPath.section] ?? "_"
        cell.setupCell(data: data, row: indexPath.section)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if checkAvailableSpace(column: indexPath.row) {
            finalStatusLabel.text = ""
            
            let position = placeNewBallInColumn(row: indexPath.section , column: indexPath.row)
            if let placedRow = position.0, let placedColumn = position.1 {
                checkGameStatus(row: placedRow, column: placedColumn)
            }
            
            if shouldContinueGame() {
                self.switchBall()
            } else {
                finalStatusLabel.text = "Game over"
                statusLabel.text = ""
            }
        } else {
            finalStatusLabel.text = "Selected column is full."
        }
        
        collectionView.reloadData()
    }
    
    func switchBall() {
        currentBall = currentBall == "*" ? "#" : "*"
        statusLabel.text = "Select column to place \(currentBall == "*" ? "Red ball" : "Blue ball")"
    }
    
    func checkAvailableSpace(column: Int) -> Bool {
        let columnArray = dataDict[column]
        
        if let _ = columnArray?.index(of: "x") {
            return true
        }
        
        return false
    }
    
    func placeNewBallInColumn(row: Int, column: Int) -> (Int?, Int?){
        if let columnArray = dataDict[column] {
            for i in 0...columnArray.count - 1 {
                if columnArray[columnArray.count - 1 - i] == "x" {
                    dataDict[column]?[columnArray.count - 1 - i] = currentBall
                    return (columnArray.count - 1 - i, column)
                }
            }
        }
        
        return (nil, nil)
    }
    
    func checkGameStatus(row: Int, column: Int) {
        checkRows(row: row , column: column)
        checkColoumns(column: column)
        checkDiagonals(row: row , column: column)
    }
    
    func checkRows(row: Int, column: Int) {
        let columnCount = dataDict.keys.count
        var rowArray = [String]()
        
        for column in 0...columnCount-1 {
            rowArray.append(dataDict[column]![row])
        }
        
        self.checkPattern(dataArray: rowArray)
    }
    
    func checkColoumns(column: Int) {
        self.checkPattern(dataArray: dataDict[column]!)
    }
    
    func checkDiagonals(row: Int, column: Int) {
        var diagonal1 = [String]()
        var diagonal2 = [String]()
        
        let numberOfColums = dataDict.keys.count
        let numberOfRows = dataDict[dataDict.keys.first!]?.count
        
        for i in 0...(kWinValue * 2 - 1) {
            let r1 = row + kWinValue - 1 - i
            let c1 = column - kWinValue + 1 + i
            
            if r1 >= 0 && r1 < numberOfRows! && c1 >= 0 && c1 < numberOfColums {
                diagonal1.append(dataDict[c1]![r1])
                
            }
            
            let r2 = row - kWinValue + 1 + i
            let c2 = column - kWinValue + 1 - i
            
            if r2 >= 0 && r2 < numberOfRows! && c2 >= 0 && c2 < numberOfColums {
                diagonal2.append(dataDict[c2]![r2])
            }
        }
        
        self.checkPattern(dataArray: diagonal1)
        self.checkPattern(dataArray: diagonal2)
    }
    
    func checkPattern(dataArray: [String]) {
        var repeatCount = 0
        var repeatValue = dataArray.first
        
        for value in dataArray {
            if value == repeatValue {
                repeatCount += 1
                if repeatCount == kWinValue && repeatValue != "x" {
                    updateSuccessForCurrentBall()
                }
            } else {
                repeatValue = value
                repeatCount = 1
            }
        }
    }
    
    func shouldContinueGame() -> Bool {
        for key in dataDict.keys {
            if let _ = dataDict[key]?.index(of: "x") {
                return true
            }
        }
        
        return false
    }
    
    func updateSuccessForCurrentBall() {
        statusLabel.text = ""
        finalStatusLabel.text = "Winner : \(currentBall == "*" ? "Red ball" : "Blue ball")"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.showDefaultData()
        }
    }
    
    func showDefaultData() {
        dataDict = BallDataSource.intstance.prepareDefaultData()
        collectionView.reloadData()
        statusLabel.text = "Select column to place \(currentBall == "*" ? "Red ball" : "Blue ball")"
        finalStatusLabel.text = ""
    }
    
    @IBAction func replay(_ sender: Any) {
        showDefaultData()
    }
}
