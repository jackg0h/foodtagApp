//
//  StatViewController.swift
//  foodtagios
//
//  Created by Jack on 17/01/2017.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class StatViewController: UIViewController {
    weak var delegate: ViewController!
    @IBOutlet weak var foodImageView: UIImageView!
    
    // init
    var theImagePassed = UIImage()
    var top1LabelPassed = ""
    var top2LabelPassed = ""
    var top3LabelPassed = ""
    var top4LabelPassed = ""
    var top5LabelPassed = ""
    
    var top1ProbaPassed = Float()
    var top2ProbaPassed = Float()
    var top3ProbaPassed = Float()
    var top4ProbaPassed = Float()
    var top5ProbaPassed = Float()
    
    // connect 
    @IBOutlet weak var top1Label: UILabel!
    @IBOutlet weak var top2Label: UILabel!
    @IBOutlet weak var top3Label: UILabel!
    @IBOutlet weak var top4Label: UILabel!
    @IBOutlet weak var top5Label: UILabel!
    @IBOutlet weak var top1Progress: UIProgressView!
    @IBOutlet weak var top2Progress: UIProgressView!
    @IBOutlet weak var top3Progress: UIProgressView!
    @IBOutlet weak var top4Progress: UIProgressView!
    @IBOutlet weak var top5Progress: UIProgressView!
    @IBOutlet weak var top1Percent: UILabel!
    @IBOutlet weak var top2Percent: UILabel!
    @IBOutlet weak var top3Percent: UILabel!
    @IBOutlet weak var top4Percent: UILabel!
    @IBOutlet weak var top5Percent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodImageView.image = theImagePassed
        top1Label.text = top1LabelPassed + "  \(top1ProbaPassed)"
        top2Label.text = top2LabelPassed
        top3Label.text = top3LabelPassed
        top4Label.text = top4LabelPassed
        top5Label.text = top5LabelPassed
        
        //print(top1ProbaPassed/100)
        top1Progress.progress = top1ProbaPassed
        top2Progress.progress = top2ProbaPassed
        top3Progress.progress = top3ProbaPassed
        top4Progress.progress = top4ProbaPassed
        top5Progress.progress = top5ProbaPassed

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
