//
//  LoginViewController.swift
//  Carbony
//
//  Created by doss-zstch1212 on 04/08/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButton()
        setupResetPasswordLabel()
//        setupCancelButton()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        userLogin()
    }
    
    private func userLogin() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !password.isEmpty else {
                  showAlert(title: "Missing Credentials", message: "Please enter both username and password.")
                return
              }
        
        if let storedPassword = defaults.string(forKey: username), storedPassword == password {
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn") // Set user login
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarViewController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarViewController)
        } else {
            showAlert(title: "Login denied", message: "Try again.")
        }
    }
    
    private func setupCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func setupLoginButton() {
        loginButton.layer.cornerRadius = 8
    }
    
    private func setupResetPasswordLabel() {
        //forgotPasswordLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordLabelTapped))
        forgotPasswordLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func forgotPasswordLabelTapped() {
        print("Forgot password label tapped.")
        
        if let forgotPasswordViewController = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            let rootViewController = UINavigationController(rootViewController: forgotPasswordViewController)
            present(rootViewController, animated: true)
        }

    }
}
