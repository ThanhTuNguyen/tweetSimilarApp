//
//  PopupAddViewController.swift
//  tweetSimilarApp
//
//  Created by Thanh Tu Nguyen on 7/27/18.
//  Copyright © 2018 Thanh Tu Nguyen. All rights reserved.
//

import UIKit

protocol PopupAddViewDelegate {
    func didFinish(_ message: String)
    func didCancel()
}

class PopupAddViewController: UIViewController {
    
    var delegate: PopupAddViewDelegate!

    @IBOutlet weak var messageText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func TouchDone(_ sender: Any) {
        delegate?.didFinish(messageText.text)
        self.removeAnimate()
    }
    
    
    @IBAction func TouchCancel(_ sender: Any) {
        delegate?.didCancel()
        self.removeAnimate()
    }
    
}

extension PopupAddViewController: UITextViewDelegate
{
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            return false
        }
        return true
    }
}
