//
//  TableViewController.swift
//  Top100s
//
//  Created by Martin Gamboa on 5/9/18.
//  Copyright © 2018 RenatoGamboa. All rights reserved.
//

import UIKit
import SwiftSoup
import NVActivityIndicatorView
import TableFlip



class TableViewController: UITableViewController,NVActivityIndicatorViewable {
    @IBOutlet weak var parseTableView: UITableView!
    
    var tempArr = [String]()
    var tempArr1 = [String]()
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
    var activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    
    
    
    
    
     
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurredBackgroundView = BlurredBackgroundView(frame: .zero)
        parseTableView.backgroundView = blurredBackgroundView
        parseTableView.separatorEffect = UIVibrancyEffect(blurEffect: blurredBackgroundView.blurView.effect as! UIBlurEffect)
        
        
        setLoadingScreen()
        
        parseHTML()
        

        
    }
 
    
    func parseHTML(){
        var varText = [String]()
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
                    //print(x)
                    varText.append(x)
                    //self.tableView.reloadData()
                }
                
                
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.removeLoadingScreen()
            }
            //self.tableView.reloadData()
            //self.removeLoadingScreen()
            
            
            //self.parseTableView.animate(animation: TableViewAnimation.Table.top(duration: 2.0))
            
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
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //parseHTML()
        return (tempArr.count)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1). " + tempArr[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        // Change colors of seperators
        /*
        if(indexPath.row % 3 == 0){
            parseTableView.separatorColor = UIColor.yellow
        }
        else if(indexPath.row % 2 == 0){
            parseTableView.separatorColor = UIColor.red
        }
        else {
            parseTableView.separatorColor = UIColor.white
        }
 */
        
        return (cell)
    }
    
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (parseTableView.frame.width / 2) - (width / 2)
        let y = (parseTableView.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        
        // Sets loading text
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: -10, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = .white
        spinner.color = UIColor.white
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        //Lets make the seperator clear until after
        parseTableView.separatorStyle = .none

        // ADD ON LOADING VIEW
        let frame = CGRect(x: parseTableView.center.x - 100, y: parseTableView.center.y - 100, width: 200, height: 200)
        activityView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType(rawValue: 22), color: UIColor.white,padding: 0)
        //NVActivityIndicatorPresenter.sharedInstance.setMessage("LOADING...")
        parseTableView.addSubview(activityView)
        parseTableView.separatorColor = UIColor.clear
        
        
        
        activityView.startAnimating()
        
        // Adds text and spinner to the view
        //loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        parseTableView.addSubview(loadingView)
        
    }
    
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        activityView.stopAnimating()
        parseTableView.separatorStyle = .singleLine
        
        

        
    }
    
    

    
    

}

// Diff class
class BlurredBackgroundView: UIView {
    let imageView: UIImageView
    let blurView: UIVisualEffectView
    
    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        imageView = UIImageView(image: UIImage.gorgeousImage())
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(blurView)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        blurView.frame = bounds
    }
}

extension UIImage {
    class func gorgeousImage() -> UIImage {
        return UIImage(named: "gorgeousimage")!
    }
}
