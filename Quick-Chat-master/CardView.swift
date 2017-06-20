//
//  CardView.swift
//  QuickChat
//
//  Created by MAC on 2017/6/17.
//  Copyright © 2017年 Mexonis. All rights reserved.
//


import UIKit
import Firebase

public enum CardOption: String {
    case like1 = "喜歡!"
    case like2 = "I do like it"
    case like3 = "It's fine"
    
    case dislike1 = "先不要!"
    case dislike2 = "I do not"
    case dislike3 = "Not enough"
}

class CardView: UIView {
    
    var greenLabel: CardViewLabel!
    var redLabel: CardViewLabel!
    var currentIDCardview = ""
    var userownID = ""
    
    var matches = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // card style
        
        self.backgroundColor = UIColor( red: 255/255, green: 192/255, blue: 203/255, alpha: 1.0)
        self.layer.cornerRadius = 10
        
        // labels on top left and right
        
        let padding: CGFloat = 20
        
        greenLabel = CardViewLabel(origin: CGPoint(x: padding, y: padding), color: UIColor(red: 102/255, green: 209/255, blue: 158/255, alpha: 1.0))
        greenLabel.isHidden = true
        self.addSubview(greenLabel)
        
        redLabel = CardViewLabel(origin: CGPoint(x: frame.width - CardViewLabel.size.width - padding, y: padding), color: UIColor(red: 236/255, green: 137/255, blue: 134/255, alpha: 1.0))
        redLabel.isHidden = true
        self.addSubview(redLabel)
        
    
 
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOptionLabel(option: CardOption) {
        if option == .like1 || option == .like2 || option == .like3 {
            
            greenLabel.text = option.rawValue
            print(currentIDCardview)
            matches.append(currentIDCardview)
            let values = ["match":matches]
            
            Database.database().reference().child("users").child(userownID).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                if errr == nil {
                    //if let data = snapshot.value as? [String: String] {
                      //  print()
                    //}
                }
            })
 
            // fade out redLabel
            if !redLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.redLabel.alpha = 0
                }, completion: { (_) in
                    self.redLabel.isHidden = true
                })
            }
            
            // fade in greenLabel
            if greenLabel.isHidden {
                greenLabel.alpha = 0
                greenLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.greenLabel.alpha = 1
                })
            }
            
        } else {
            
            redLabel.text = option.rawValue
            
            
            // fade out greenLabel
            if !greenLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.greenLabel.alpha = 0
                }, completion: { (_) in
                    self.greenLabel.isHidden = true
                })
            }
            
            // fade in redLabel
            if redLabel.isHidden {
                redLabel.alpha = 0
                redLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.redLabel.alpha = 1
                })
            }
        }
    }
    
    var isHidingOptionLabel = false
    
    func hideOptionLabel() {
        // fade out greenLabel
        if !greenLabel.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.greenLabel.alpha = 0
            }, completion: { (_) in
                self.greenLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
        // fade out redLabel
        if !redLabel.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.redLabel.alpha = 0
            }, completion: { (_) in
                self.redLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
    }
    
}

class CardViewLabel: UILabel {
    fileprivate static let size = CGSize(width: 90, height: 36)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = .white
        self.font = UIFont.boldSystemFont(ofSize: 18)
        self.textAlignment = .center
        
        self.layer.cornerRadius = frame.height / 2
        self.layer.masksToBounds = true
        self.layer.zPosition = CGFloat(FLT_MAX)
    }
    
    convenience init(origin: CGPoint, color: UIColor) {
        
        self.init(frame: CGRect(x: origin.x, y: origin.y, width: CardViewLabel.size.width, height: CardViewLabel.size.height))
        self.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
