//
//  EntryDetailViewController.swift
//  JournalCloudKit
//
//  Created by Josh Sparks on 10/14/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }

    // MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextTextView.text = entry.bodyText
    }
    
    // MARK: Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, let bodyText = bodyTextTextView.text else { return }
        if let entry = self.entry {
            JournalController.sharedInstance.updateEntry(entry: entry, with: title, bodyText: bodyText) { (success) -> (Void) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            JournalController.sharedInstance.addEntry(with: title, bodyText: bodyText) { (success) -> (Void) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                }
                }
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextTextView.text = ""
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        bodyTextTextView.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}
