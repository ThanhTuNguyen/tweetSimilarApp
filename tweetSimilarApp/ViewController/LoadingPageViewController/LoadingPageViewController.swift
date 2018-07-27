//
//  LoadingPageViewController.swift
//  tweetSimilarApp
//
//  Created by Thanh Tu Nguyen on 7/25/18.
//  Copyright © 2018 Thanh Tu Nguyen. All rights reserved.
//

import UIKit

class LoadingPageViewController: UIViewController {
    
    var timer = Timer()
    
    convenience init() {
        self.init(nibName : nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        timer = Timer()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        timer = Timer()
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
             timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(LoadingPageViewController.updateTimer)), userInfo: nil, repeats: false)
    }

    @objc func updateTimer() {
        let listview = ListTweetsViewController(nibName: "ListTweetsViewController", bundle: nil)
        self.navigationController?.pushViewController(listview, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
