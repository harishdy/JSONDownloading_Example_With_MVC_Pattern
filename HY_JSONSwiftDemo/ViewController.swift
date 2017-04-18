//
//  ViewController.swift
//  HY_JSONSwiftDemo
//
//  Created by Harish Yadav on 17/04/17.
//  Copyright © 2017 Harish Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var hy_tableView: UITableView!
    
    var hy_nameArray = [String]()
    var hy_dobArray  = [String]()
    var hy_imgURLArray  = [String]()
    
    
    
    let hy_urlstring = "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadJsonWithURL()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadJsonWithURL()
    {
        let hy_url = NSURL(string:hy_urlstring)
        URLSession.shared.dataTask(with: (hy_url as? URL)!, completionHandler:{(data,response,error)->Void in
            
            if let hy_jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as?NSDictionary{
                
                print(hy_jsonObj!.value(forKey: "actors"))
                if let temp_actorArray = hy_jsonObj?.value(forKey: "actors") as? NSArray
                {
                    for actor in temp_actorArray
                    {
                        if let actorDict = actor as?NSDictionary
                        {
                            if let name = actorDict.value(forKey: "name")
                            {
                                self.hy_nameArray.append(name as!String)
                            }
                            if let name = actorDict.value(forKey: "dob")
                            {
                                self.hy_dobArray.append(name as!String)
                            }
                            if let name = actorDict.value(forKey: "image")
                            {
                                self.hy_imgURLArray.append(name as!String)
                            }
                            
                            OperationQueue.main.addOperation({
                                self.hy_tableView.reloadData()
                            })
                            
                        }
                    }
                }
            }
            
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return hy_nameArray.count
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as!HY_CustomTableViewCell
        
        cell.hy_nameLable.text = hy_nameArray[indexPath.row]
        cell.hy_dobLable.text = hy_dobArray[indexPath.row]
        let tamp_imgURL = NSURL(string:hy_imgURLArray[indexPath.row])
        
        if tamp_imgURL != nil
        {
            let data = NSData(contentsOf:(tamp_imgURL as? URL)!)
            
            cell.hy_imageView.image = UIImage(data:data as!Data)
        }
        
        return cell
        
    }
    
}

