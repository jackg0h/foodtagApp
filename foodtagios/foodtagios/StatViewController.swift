//
//  StatViewController.swift
//  foodtagios
//
//  Created by Jack on 17/01/2017.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import Social

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

    @IBOutlet weak var top1Label: UIButton!
    
    @IBOutlet weak var top2Label: UIButton!
    @IBOutlet weak var top3Label: UIButton!
    @IBOutlet weak var top4Label: UIButton!
    @IBOutlet weak var top5Label: UIButton!
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
        top1Label.setTitle("#" + top1LabelPassed,for: .normal)
        top2Label.setTitle("#" + top2LabelPassed,for: .normal)
        top3Label.setTitle("#" + top3LabelPassed,for: .normal)
        top4Label.setTitle("#" + top4LabelPassed,for: .normal)
        top5Label.setTitle("#" + top5LabelPassed,for: .normal)
        
        top1Percent.text = String(top1ProbaPassed*100) + "%"
        top2Percent.text = String(top2ProbaPassed*100) + "%"
        top3Percent.text = String(top3ProbaPassed*100) + "%"
        top4Percent.text = String(top4ProbaPassed*100) + "%"
        top5Percent.text = String(top5ProbaPassed*100) + "%"

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
    
    @IBAction func top1Share(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc?.setInitialText("#" + top1LabelPassed)
        vc?.add(foodImageView.image)
        present(vc!, animated: true, completion: nil)
    }

    @IBAction func top2Share(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc?.setInitialText("#" + top2LabelPassed)
        vc?.add(foodImageView.image)
        present(vc!, animated: true, completion: nil)
    }

    @IBAction func top3Share(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc?.setInitialText("#" + top3LabelPassed)
        vc?.add(foodImageView.image)
        present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func top4Share(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc?.setInitialText("#" + top4LabelPassed)
        vc?.add(foodImageView.image)
        present(vc!, animated: true, completion: nil)
    }
 
    @IBAction func top5Share(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc?.setInitialText("#" + top5LabelPassed)
        vc?.add(foodImageView.image)
        present(vc!, animated: true, completion: nil)
    }
 
}
