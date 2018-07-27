//
//  ListTweetsViewController.swift
//  tweetSimilarApp
//
//  Created by Thanh Tu Nguyen on 7/26/18.
//  Copyright © 2018 Thanh Tu Nguyen. All rights reserved.
//

import UIKit
import Foundation
import RATreeView

class ListTweetsViewController: UIViewController, RATreeViewDelegate, RATreeViewDataSource, PopupAddViewDelegate {
    
    @IBOutlet weak var treeView: RATreeView!
    
    var data : listMessages
    var numberOfTweet : Int

    convenience init() {
        self.init(nibName : nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        data = ListTweetsViewController.commonInit()
        self.numberOfTweet = 0
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        data = ListTweetsViewController.commonInit()
        self.numberOfTweet = 0
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.numberOfTweet = 0
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Twitter"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTapped))
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
        
        self.treeView.register(UINib(nibName: String(describing: FirstTweetLevelCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FirstTweetLevelCell.self))
        
        self.treeView.delegate = self
        self.treeView.dataSource = self
        
        self.treeView.setNeedsLayout()
        self.treeView.layoutIfNeeded()
        
//        self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone
        self.treeView.backgroundColor = .clear

        view.backgroundColor = .clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addTapped() {
        let popOverVC = PopupAddViewController(nibName: "PopupAddViewController", bundle: nil)
        popOverVC.delegate = self
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? messages {
            return item.allMessages.count
        } else {
            return self.data.list.count
        }
    }

    func didFinish(_ message: String) {
        NSLog(message)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if(message.count != 0)
        {
            let mymessages = messages(firstMessage: message, parentIndex: data.list.count)
            
            if(mymessages.isValid)
            {
                data.addList(mymessages)
                self.treeView.reloadData();
                numberOfTweet = 0
                let encoder = JSONEncoder()
                let saveData = try! encoder.encode(data)
                UserDefaults.standard.set(saveData, forKey: "UserTweetApp")
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Seem to be your input have a \"non whitespace\" more than 50 characters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }

        }
    }
    
    func didCancel() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        
        let cell = treeView.dequeueReusableCell(withIdentifier: "FirstTweetLevelCell") as! FirstTweetLevelCell
        
        let dataObject = item as! messages
  
        let level = self.treeView.levelForCell(forItem: item as Any)
        
        let backgroundColor: UIColor
        if(level == 0)
        {
            self.numberOfTweet += 1
            backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            cell.name.text = "Tweet Number \(numberOfTweet)"
            cell.countInfo.text = "\(dataObject.allMessages.count)"
            cell.content.text = "There are \(dataObject.allMessages.count) message(s)"
        }
        else
        {
            cell.name.text = "\(dataObject.content)"
            cell.content.text = "No More Sub"
            cell.countInfo.text = "There are \(dataObject.content.count) characters"
            backgroundColor = UIColor(red: 209.0/255.0, green: 238.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        }
        cell.backgroundColor = backgroundColor
        cell.contentView.backgroundColor = backgroundColor
        cell.cellView.backgroundColor = backgroundColor
        return cell
    }

    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? messages {
            return item.allMessages[index]
        } else {
            return self.data.list[index] as AnyObject
        }
    }
    
    func treeView(_ treeView: RATreeView, commit editingStyle: UITableViewCellEditingStyle, forRowForItem item: Any) {
        guard editingStyle == .delete else { return; }
        let item = item as! messages
        
        let dataObject = item
        
        let level = self.treeView.levelForCell(forItem: item as Any)
        if(level == 0)
        {
            data.removeChild(dataObject)
        }
        else
        {
            data.list[dataObject.parentIndex].removeChild(dataObject)
        }
        
        self.treeView.reloadData();
        numberOfTweet = 0
        let encoder = JSONEncoder()
        let saveData = try! encoder.encode(data)
        UserDefaults.standard.set(saveData, forKey: "UserTweetApp")
    }
}
    


private extension ListTweetsViewController {
    
    static func commonInit() -> listMessages {
        
        // this is for remove user data
//        let prefs = UserDefaults.standard
//        var keyValue = prefs.string(forKey:"UserTweetApp")
//        prefs.removeObject(forKey:"UserTweetApp")
        let saveData = UserDefaults.standard.value(forKey: "UserTweetApp") as? Data
        var myList = listMessages()
        if(saveData != nil)
        {
            let decoder = JSONDecoder()
            myList = try! decoder.decode(listMessages.self, from: saveData!)

        }
        return myList

    }
    
}
