//
//  likeButton.swift
//  Mochi
//
//  Created by Sam Weekes on 11/03/2019.
//  Copyright © 2019 Sam Weekes. All rights reserved.
//

import Foundation
import UIKit

protocol likeButtonDelegate {
    func likeButtonPressed(hasLiked : Bool)
}

class likeButton: UIButton {
    var delegate : likeButtonDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: sHR * 35 / 667, height: sHR * 51 / 667))
        createView()
    }
    
    init(numLikes : Int, hasLiked : Bool) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: sHR * 35 / 667, height: sHR * 51 / 667))
        
        defer {
            self.numberLikes = numLikes
            self.hasLiked = hasLiked
        }
        
        createView()
    }
    
    func createView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.cornerRadius = sHR * 5.83 / 667
        
        emitterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: sHR * 35 / 667, height: sHR * 51 / 667))
        emitterView?.isUserInteractionEnabled = false
        self.addSubview(emitterView!)
        
        heart = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: sHR * 18 / 667, height: sHR * 18 * (252 / 270) / 667))
        heart?.image = self.hasLiked ? UIImage(named: "heart_filled") : UIImage(named: "heart_empty")
        heart?.isUserInteractionEnabled = false
        heart?.center = CGPoint(x: self.frame.size.width * 0.5, y: sHR * 18 / 667)
        self.addSubview(heart!)
        
        likes = UILabel(frame: CGRect(x: 0.0, y: sHR * (51 - 30) / 667, width: sHR * 35 / 667, height: sHR * 30 / 667))
        likes?.isUserInteractionEnabled = false
        likes?.textColor = UIColor.white
        likes?.font = UIFont.systemFont(ofSize: sHR * 12 / 667, weight: .bold)
        likes?.text = "\(self.numberLikes)"
        likes?.textAlignment = .center
        self.addSubview(likes!)
        
        self.addTarget(self, action: #selector(btnDown), for: .touchDown)
        self.addTarget(self, action: #selector(btnUp), for: .touchUpOutside)
        self.addTarget(self, action: #selector(likeToggle), for: .touchUpInside)
    }
    
    var heart : UIImageView?
    var emitterView : UIView?
    var likes : UILabel?
    var emitterCell : CAEmitterCell?
    var emitter : CAEmitterLayer?
    
    var hasLiked : Bool = false {
        didSet (newValue) {
            self.heart?.image = self.hasLiked ? UIImage(named: "heart_filled") : UIImage(named: "heart_empty")
            if hasLiked {
                self.createParticles()
            } else {
                self.stopParticles()
                
            }
        }
    }
    
    var numberLikesString : String = "" {
        didSet {
            self.likes?.text = self.numberLikesString
        }
    }
    var numberLikes : Int? {
        didSet {
            guard let val = self.numberLikes else {
                self.likes?.text = ""
                return
            }
            var likeString = "\(val)"
            if val > 999 {
                var num = Double(val)
                num /= 1000
                likeString = "\(num.rounded(toPlaces: 1))k"
            }
            self.likes?.text = likeString
        }
    }
    

    @objc func btnDown() {
        UIView.animate(withDuration: 0.125, delay: 0.0, options: .curveEaseIn, animations: {
            self.heart?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (_) in
            //
        }
    }
    
    @objc func likeToggle() {
        runHaptic(.heavy)
        btnUp()
        
        hasLiked = !hasLiked

        self.delegate?.likeButtonPressed(hasLiked: hasLiked)
    }
    
    @objc func createParticles() {
        if emitter == nil {
            
            emitter = CAEmitterLayer()
            emitter?.frame = CGRect(x: 0.0, y: 0.0, width: sHR * 20 / 667, height: sHR * 20 / 667)
            emitter?.renderMode = .unordered
            
            emitterView?.layer.addSublayer(emitter!)
            emitter?.emitterPosition = heart!.center
            
            emitterCell = CAEmitterCell()
            emitterCell?.name = "cells"
            emitterCell?.contents = #imageLiteral(resourceName: "heart_filled").cgImage
            emitterCell?.birthRate = 3.0
            emitterCell?.scale = 0.01
            emitterCell?.scaleRange = 0.01
            emitterCell?.scaleSpeed = 0.06
            emitterCell?.emissionLongitude = -0.5 * .pi
            emitterCell?.lifetime = 2.0
            emitterCell?.lifetimeRange = 1.0
            emitterCell?.color = UIColor.white.cgColor
            emitterCell?.velocity = 40
            emitterCell?.velocityRange = 10
            emitterCell?.emissionRange = 0.15 * .pi
            emitter?.emitterCells = [emitterCell!]
            
        }
        emitter?.birthRate += 1.0
        perform(#selector(stopParticles), with: nil, afterDelay: 2.0)
    }
    
    @objc func stopParticles() {
        self.emitter?.birthRate = 0.0
    }
    
    @objc func btnUp() {
        UIView.animate(withDuration: 0.125, delay: 0.0, usingSpringWithDamping: 0.010, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            //        UIView.animate(withDuration: 0.125, delay: 0.0, options: .curveEaseIn, animations: {
            self.heart?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            //
        }
    }
    
}
