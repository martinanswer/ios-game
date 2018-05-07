//
//  ViewController.swift
//  tic tac toc
//
//  Created by MARTIN MA on 4/04/2017.
//  Copyright © 2017 MARTIN MA. All rights reserved.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {//define
    var imgx = "x.png"
    var imgo = "o.png"
    var counterx : Int = 0
    var countero : Int = 0//score
    var soundPlayer:AVAudioPlayer?
    var elapsedTime:TimeInterval=0//music time
    
    @IBOutlet weak var History: UITextView!
    var increment: Int = 0
    var WriteHistory: String = ""//history
    @IBOutlet var gridButtons: [UIButton]!//girde button
    @IBOutlet weak var ocounter: UILabel!
    @IBOutlet weak var xcounter: UILabel!
    @IBAction func music(_ sender: UIButton) {
        if soundPlayer != nil{
            soundPlayer!.stop()
            elapsedTime = 0// restart music
        }// music stop button

    }
    @IBAction func musicplayer(_ sender: UIButton) {
        if soundPlayer != nil{
            soundPlayer!.currentTime = elapsedTime
            soundPlayer!.play()
            
        }// music start button

    }
    
    @IBOutlet weak var multiPlayerSwitch: UISwitch!
    
    
    
    var activePlayer = 1
    var gameState = [0,0,0,0,0,0,0,0,0]
    var gameIsactive = true
    var grid :[[Int]] = [[0,0,0],[0,0,0],[0,0,0]]
    @IBAction func xclick(_ sender: UIButton) {
        activePlayer = 1
    }
    @IBAction func oclick(_ sender: UIButton) {
        activePlayer = 2
    }
    @IBOutlet weak var label: UILabel!
    @IBAction func action(_ sender: UIButton) {
        
        
        let rowIndex = sender.tag/3  //tag 0...8
        let colIndex = sender.tag%3
        
        
        
        if grid[rowIndex][colIndex] != 0 {return}//empty grid
        grid[rowIndex][colIndex] = activePlayer
        
            if activePlayer == 1
        {
            sender.setImage(UIImage(named:imgx),for: .normal)
            
        }
        else if activePlayer == 2
        {
            sender.setImage(UIImage(named:imgo),for: .normal)
        }
        let winner = winlose()
        print("player\(activePlayer)just played,and status winner = \(winner)")
        print("grid\(grid) and index row \(rowIndex) and col \(colIndex)")
        
        switch winner {
        case 0:
            activePlayer = (activePlayer % 2) + 1
        case 1: // x player win
            label.text = "x is winner"
            alertWinner(playName:"player 1")
            counterx = counterx + 1
            xcounter.text = "x score: \(counterx)"
            increment += 1
            let write = "  \(increment) . the winner is x"
            WriteHistory = WriteHistory + write
            History.text = WriteHistory
        case 2: // o player win
            label.text = "o is winner"
            alertWinner(playName:"player 2")
            countero = countero + 1
            ocounter.text = "o score: \(countero)"
            increment += 1
            let write = "  \(increment) . the winner is o"
            WriteHistory = WriteHistory + write
            History.text = WriteHistory

        default:
            print("\(winner) is not match")
        }
        
        if multiPlayerSwitch.isOn == false//AI mode
        {
            let (cellIndex,gRowIndex,gColIndex,play2won) = tellMeWhereToPlay()
            if activePlayer == 2{
            gridButtons[cellIndex].setImage(UIImage(named:imgo),for: .normal)
            grid[gRowIndex][gColIndex] = 2
                if play2won == true{
                alertWinner(playName: "Player 2")
                countero = countero + 1
                ocounter.text = "o score: \(countero)"
                increment += 1
                let write = "  \(increment) . the winner is o"
                WriteHistory = WriteHistory + write
                History.text = WriteHistory
            }
            activePlayer = 1 // player x paly the game
        }
            else{
                gridButtons[cellIndex].setImage(UIImage(named:imgx),for: .normal)
                grid[gRowIndex][gColIndex] = 1
                if play2won == true{
                    alertWinner(playName: "Player 1")
                    counterx = counterx + 1
                    xcounter.text = "x score: \(counterx)"
                    increment += 1
                    let write = "  \(increment) . the winner is x"
                    WriteHistory = WriteHistory + write
                    History.text = WriteHistory

                }
                activePlayer = 2 // player x paly the game

            
            }
    }
    }
    
                    func tellMeWhereToPlay() -> (Int,Int,Int,Bool)
        {
            var index = -1
            var noWinLose = 0
            var gRowIndex = 0
            var gColIndex = 0
            
            for col in 0...2{//check all the square
                for row in 0...2{
                    index = index + 1
                    if grid[row][col] == 0 //are there any signal in the square
                    {
                        grid[row][col] = 2 //change grid
                        var i = winlose()
                        if i == 2 //won already?
                        {
                            return (index,row,col,true)
                        }
                        
                        grid[row][col] = 1
                        i = winlose()
                        if i == 1
                        {//palyer 1 win
                            return (index,row,col,false)
                        }
                        //no player win and still have the empty square
                        noWinLose = index
                        gRowIndex = row
                        gColIndex = col
                        grid[row][col] = 0
                    }
                }
            }
            return(noWinLose,gRowIndex,gColIndex,false)
    }
          func alertWinner(playName : String){
     let alertController = UIAlertController(title: "Alert",message:"\(playName) won",preferredStyle:.actionSheet)
       let yesAction=UIAlertAction(title:"Ok",style:.default){
        (action)->Void in self.start()}
            alertController.addAction(yesAction)
            self.present(alertController,animated: true,completion: nil)
    }//alert
    func start(){
        grid = [[0,0,0],[0,0,0],[0,0,0]]
        for button in gridButtons{
        button.setImage(nil,for: .normal)        }
        activePlayer = 1//make everything empty
    }
    @IBOutlet weak var playAgainButton: UIButton!
    
   @IBAction func playAgain(_ sender: AnyObject) {
    start()
  }
    
            override func viewDidLoad() {
        super.viewDidLoad()
                //music path
                let path =
                    Bundle.main.path(forResource:"song1",ofType:"mp3")
                let url = URL(fileURLWithPath: path!)
                do {
                    try soundPlayer = AVAudioPlayer(contentsOf: url)
                }
                catch { print ("file not available")}
        // Do any additional setup after loading the view, typically from a nib.
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func winlose() -> Int {
        //who won the game renturn 1,2,0 1:x won, 2: o won
        if grid[0][0] != 0 && grid[0][0] == grid[0][1] &&
            grid[0][1] == grid[0][2]{
            return grid[0][0]
        }
        if grid[1][0] != 0 && grid[1][0] == grid[1][1] &&
            grid[1][1] == grid[1][2]{
            return grid[1][0]
        }
        if grid[2][0] != 0 && grid[2][0] == grid[2][1] &&
            grid[2][1] == grid[2][2]{
            return grid[2][0]
        }
        if grid[0][0] != 0 && grid[0][0] == grid[1][0] &&
            grid[1][0] == grid[2][0]{
            return grid[0][0]
        }
        if grid[0][1] != 0 && grid[0][1] == grid[1][1] &&
            grid[1][1] == grid[2][1]{
            return grid[0][1]
        }
        if grid[1][0] != 0 && grid[1][0] == grid[1][1] &&
            grid[1][1] == grid[1][2]{
            return grid[1][0]
        }
        if grid[2][0] != 0 && grid[2][0] == grid[2][1] &&
            grid[2][1] == grid[2][2]{
            return grid[2][0]
        }
        if grid[0][0] != 0 && grid[0][0] == grid[1][0] &&
            grid[1][0] == grid[2][0]{
            return grid[0][0]
        }
        if grid[0][1] != 0 && grid[0][1] == grid[1][1] &&
            grid[1][1] == grid[2][1]{
            return grid[0][1]
        }
        if grid[0][2] != 0 && grid[0][2] == grid[1][2] &&
            grid[1][2] == grid[2][2]{
            return grid[2][2]
        }
        return 0
        }
}

