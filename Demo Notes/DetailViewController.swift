//
//  DetailViewController.swift
//  Demo Notes
//
//  Created by Josh Birnholz on 2/21/17.
//  Copyright © 2017 Joshua Birnholz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	
	weak var delegate: DetailViewControllerDelegate?

	func configureView() {
		// Update the user interface for the detail item.
		if let note = self.note {
		    textView?.text = note.text
			navigationItem.title = note.title
		} else {
			textView?.text = ""
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		configureView()
		textView.delegate = self
		textView.becomeFirstResponder()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func doneButtonPressed(_ sender: Any) {
		textView.resignFirstResponder()
		delegate?.save()
	}

	var note: Note? {
		didSet {
		    // Update the view.
		    configureView()
		}
	}

}

extension DetailViewController: UITextViewDelegate {
	
	func textViewDidChange(_ textView: UITextView) {
		note?.text = textView.text
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		navigationItem.title = note?.title
	}
	
}

protocol DetailViewControllerDelegate: class {
	
	func save()
	
}
