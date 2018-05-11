//
//  ViewController.swift
//  Top100s
//
//  Created by Martin Gamboa on 5/8/18.
//  Copyright © 2018 RenatoGamboa. All rights reserved.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController{
    
    
    var tempArr = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseHTML()
        

    }
    
    func parseHTML(){
        let url = URL(string: "https://www.billboard.com/charts/hot-100")
        
        
        // top 100 most viewed videos
        // best athlete
        // richest locations
        // games
        // top 100 universities
        // subtitles
        
        //top 100 clubs
        // top 100 vacations
        // top 100 healthy foods
        
        // top 100 worksouts
        // top 100 richest people
        
        // top 100 movies of all time
        // top 100 quotes
        
        // top 100 apps
        let task = URLSession.shared.dataTask(with: url!) { (data, respondse, error) in
            
            if error != nil {
                
                print(error)
            }
            else {
                let htmlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                //print(htmlContent)
                
                self.tempArr = self.myArr(x: htmlContent! as String)
                
                for x in self.tempArr {
                    print(x)
                }
            }
            
        }
        task.resume()
    }
    
    
    func  myArr (x: String) -> Array<String>
    {
        
        var arr1 = [String]()
        var arr2 = [String]()
        var arr3 = [String]()
        var i: Int
        do {
            let doc = try SwiftSoup.parse (x)
            do {
                //let element = try doc.select ("h2.chart-row__song").array()
                let element = try doc.select ("div.chart-row__title").array()
                let element2 = try doc.select ("span.chart-row__artist").array()
                do {
                    let text = try element[0].text()
                    let text2 = try element2[0].text()
                    
                    
                    // Store Song
                    for x in element {
                        try arr1.append(x.text())
                    }
                    
                    // Store Artists
                    for y in element2 {
                        try arr2.append(y.text())
                    }
                    
                    // Store Song with Artists in Aray
                    arr3 = arr1
 
                    
                    
                    
                } catch {
                }
            } catch {
            }
        } catch {
            
        }
        
        return arr3
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
