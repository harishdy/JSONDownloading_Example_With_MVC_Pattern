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
    
    var actorsArray =  [HY_Actor]()
    
    
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
                
                //print(hy_jsonObj!.value(forKey: "actors"))
                if let temp_actorArray = hy_jsonObj?.value(forKey: "actors") as? NSArray
                {
                    for actor in temp_actorArray
                    {
                        if let actorDict = actor as?NSDictionary
                        {
                            
                            let nameStr: String = {
                                if let name = actorDict.value(forKey: "name")
                                {
                                    return name as! String
                                }

                                return "Dumy Name"
                            }()
                            
                            
                            let dobStr:String = {
                            
                                if let dob = actorDict.value(forKey: "dob")
                                {
                                return dob as! String
                                }
                                return "dumy DOB"
                            }()
                                
                            let imgstr:String = {
                                
                                if let img = actorDict.value(forKey: "image")
                                {
                                    return img as! String
                                }
                                return "dumy image"
                                }()
                            

                            self.actorsArray.append(HY_Actor(name: nameStr, dob:dobStr, img: imgstr))
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
        return actorsArray.count
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as!HY_CustomTableViewCell
        
        let actor = actorsArray[indexPath.row]
        
        cell.hy_nameLable.text = actor.name
        cell.hy_dobLable.text = actor.dob
        let tamp_imgURL = NSURL(string:actor.imageStr)
        
        if tamp_imgURL != nil
        {
            let data = NSData(contentsOf:(tamp_imgURL as? URL)!)
            
            cell.hy_imageView.image = UIImage(data:data as!Data)
        }
        
        return cell
        
    }
    
}

