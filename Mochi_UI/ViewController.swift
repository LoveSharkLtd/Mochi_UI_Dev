//
//  ViewController.swift
//  Mochi_UI
//
//  Created by Sam Weekes on 5/17/20.
//  Copyright © 2020 Sam Weekes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, likeButtonDelegate {
    func likeButtonPressed(hasLiked: Bool) {
        self.totalLikes += hasLiked ? 1 : -1
        self.likeBtn?.numberLikes = self.totalLikes
        
        totalCompleted += 1
        let max = self.progressBar?.numChallenges ?? 1
        print(max)
        self.progressBar?.completed = totalCompleted % (max + 1)
    }
    
    var likeBtn : likeButton?
    var progressBar : ProgressBar?
    
    let bg = #colorLiteral(red: 0.04589089751, green: 0.06073255837, blue: 0.1593357623, alpha: 1)
    let grey = #colorLiteral(red: 0.8098434806, green: 0.8475583196, blue: 0.8947842717, alpha: 1)
    let purple = #colorLiteral(red: 0.4283940494, green: 0.1507036984, blue: 0.8479209542, alpha: 1)
    let pink = #colorLiteral(red: 0.8545777202, green: 0.1511105895, blue: 0.5003483295, alpha: 1)
    let turquoise = #colorLiteral(red: 0.05579332262, green: 0.8160857558, blue: 0.8052346706, alpha: 1)
    let yellow = #colorLiteral(red: 0.9790083766, green: 0.8932109475, blue: 0.07214733213, alpha: 1)
    
    var totalLikes = 999
    var totalCompleted = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let animBG = AnimatedBackground(backgroundColor: bg, mochiForeground: [turquoise, purple], mochiBackground: [purple, turquoise])
        
        self.view.addSubview(animBG)
        
        likeBtn = likeButton(numLikes: totalLikes, hasLiked: false)
        likeBtn?.center = CGPoint(x: sW * 0.5, y: sH * 0.5)
        likeBtn?.delegate = self
        view.addSubview(likeBtn!)
        
        let tempBG = UIView(frame : CGRect(x : 0.0, y : 0.0, width : sW * 0.95, height : sHR * 70 / 667))
        tempBG.backgroundColor = bg.withAlphaComponent(0.75)
        tempBG.layer.cornerRadius = sHR * 5 / 667
        tempBG.center = CGPoint(x : sW * 0.5, y : sH * 0.25)
        self.view.addSubview(tempBG)
        
        progressBar = ProgressBar(width : sW * 0.8, segments: 4, color : turquoise)
        progressBar?.center = CGPoint(x : tempBG.frame.size.width * 0.5, y : tempBG.frame.size.height * 0.5)
        tempBG.addSubview(progressBar!)
    }


}
