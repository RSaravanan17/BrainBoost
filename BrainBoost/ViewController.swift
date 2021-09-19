//
//  ViewController.swift
//  BrainBoost
//
//  Created by Rithvik Saravanan on 9/18/21.
//

import UIKit
import CoreData

var scores: [Int] = [0, 0, 0, 0]

class ViewController: UIViewController {
    
    @IBOutlet weak var additionHighScore: UILabel!
    @IBOutlet weak var subtractionHighScore: UILabel!
    @IBOutlet weak var multiplicationHighScore: UILabel!
    @IBOutlet weak var divisionHighScore: UILabel!
    
    @IBOutlet weak var additionBoost: UIButton!
    @IBOutlet weak var subtractionBoost: UIButton!
    @IBOutlet weak var multiplicationBoost: UIButton!
    @IBOutlet weak var divisionBoost: UIButton!
    
    let addSegueIdentifier = "addSegue"
    let subtractSegueIdentifier = "subtractSegue"
    let multiplySegueIdentifier = "multiplySegue"
    let divideSegueIdentifier = "divideSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eraseHighScores()
        setScores()
        
        self.additionBoost.layer.cornerRadius = 25
        self.additionBoost.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
        
        self.subtractionBoost.layer.cornerRadius = 25
        self.subtractionBoost.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
        
        self.multiplicationBoost.layer.cornerRadius = 25
        self.multiplicationBoost.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
        
        self.divisionBoost.layer.cornerRadius = 25
        self.divisionBoost.layer.backgroundColor = CGColor(red: 217 / 255, green: 234 / 255, blue: 211 / 255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateScores()
    }
    
    func eraseHighScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // entity to store the scores in Core Data
        let scoresEntity = NSEntityDescription.insertNewObject(forEntityName: "ScoresEntity", into:context)

        // set the initial scores
        scoresEntity.setValue(0, forKey: "add")
        scoresEntity.setValue(0, forKey: "subtract")
        scoresEntity.setValue(0, forKey: "multiply")
        scoresEntity.setValue(0, forKey: "divide")

        // commit the changes
        do {
            try context.save()
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    func setScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ScoresEntity")
        
        var fetchedResults: [NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        // add each score from Core Data to the scores list
        for scoresEntity in fetchedResults! {
            scores[0] = scoresEntity.value(forKey: "add") as! Int
            scores[1] = scoresEntity.value(forKey: "subtract") as! Int
            scores[2] = scoresEntity.value(forKey: "multiply") as! Int
            scores[3] = scoresEntity.value(forKey: "divide") as! Int
        }
    }
    
    func updateScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // entity to store the scores in Core Data
        let scoresEntity = NSEntityDescription.insertNewObject(forEntityName: "ScoresEntity", into:context)

        // set the initial scores
        scoresEntity.setValue(scores[0], forKey: "add")
        scoresEntity.setValue(scores[1], forKey: "subtract")
        scoresEntity.setValue(scores[2], forKey: "multiply")
        scoresEntity.setValue(scores[3], forKey: "divide")

        // commit the changes
        do {
            try context.save()
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        self.additionHighScore.text = String(scores[0])
        self.subtractionHighScore.text = String(scores[1])
        self.multiplicationHighScore.text = String(scores[2])
        self.divisionHighScore.text = String(scores[3])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let boostVC = segue.destination as! BoostViewController
        
        // assigns the segue's selected operator
        if segue.identifier == addSegueIdentifier {
            boostVC.selectedOperator = "plus"
        } else if segue.identifier == subtractSegueIdentifier {
            boostVC.selectedOperator = "minus"
        } else if segue.identifier == multiplySegueIdentifier {
            boostVC.selectedOperator = "multiply"
        } else if segue.identifier == divideSegueIdentifier {
            boostVC.selectedOperator = "divide"
        }
        
        boostVC.modalPresentationStyle = .fullScreen
    }
    
    @IBAction func returnToHome(segue: UIStoryboardSegue) {}
}

