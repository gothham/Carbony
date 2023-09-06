//
//  AddGoalViewController.swift
//  Carbony
//
//  Created by doss-zstch1212 on 21/08/23.
//

import UIKit

class AddGoalViewController: UIViewController {

    @IBOutlet weak var addGoalButton: UIButton!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var targetTextField: UITextField!
    
    @IBOutlet weak var calculateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddGoalButton()
        setupLabelAction()
        setupCancelButton()
        self.title = "Add Goal"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func addGoalButtonTapped(_ sender: Any) {
        guard let description = descriptionTextField.text,
              let targetText = targetTextField.text,
              let target = Int(targetText),
              target > 1000,
              !description.isEmpty else {
                  return
              }
        
        let newUUID = UUID()
        let newGoal = Goal(uuid: newUUID, target: target, targetLeft: target, progress: 0, description: description)
        print("UUID: \(newGoal.uuid)")
        displayGoalObj(uuid: newGoal.uuid, target: newGoal.target, targetLeft: newGoal.targetLeft, progress: newGoal.progress, description: newGoal.description)
        
        DBController.shared.insertInto(uuid: newGoal.uuid.uuidString, target: newGoal.target, targetLeft: newGoal.targetLeft, progress: newGoal.progress, description: newGoal.description)
        
        NotificationCenter.default.post(name: Notification.Name("AddGoalNotification"), object: newGoal)
        
        dismiss(animated: true)
    }
    
    private func setupLabelAction() {
        let calculateLabelTapGesture = UIGestureRecognizer(target: self, action: #selector(calculateLabelAction))
        calculateLabel.addGestureRecognizer(calculateLabelTapGesture)
    }
    
    private func setupAddGoalButton() {
        addGoalButton.layer.cornerRadius = 8
    }
    
    private func setupCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func displayGoalObj(uuid: UUID, target: Int, targetLeft: Int, progress: Int, description: String) {
        print("Goal\nUUID: \(uuid), Target: \(target), TargetLeft: \(targetLeft), Progress: \(progress), Description: \(description)")
    }
    
    @objc private func cancelBarButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func calculateLabelAction() {
        print("Calculate label tapped")
        let calculateViewController = CalculateViewController()
        let rootViewController = UINavigationController(rootViewController: calculateViewController)
        self.navigationController?.present(rootViewController, animated: true)
    }
    
}
