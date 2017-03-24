//
//  MasterViewController.swift
//  Demo Notes
//
//  Created by Josh Birnholz on 2/21/17.
//  Copyright © 2017 Joshua Birnholz. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController? = nil
	var notes = [Note]()
	
	let df: DateFormatter = {
		let df = DateFormatter()
		df.timeStyle = .short
		df.dateStyle = .short
		return df
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = self.editButtonItem

		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		notes = loadNotes()
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
		super.viewWillAppear(animated)
		tableView.reloadData()
		
		saveNotes(notes)
	}

	@IBAction func insertNewNote(_ sender: UIBarButtonItem) {
		notes.insert(Note(), at: 0)
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
		
		tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
		performSegue(withIdentifier: "showDetail", sender: sender)
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		        let note = notes[indexPath.row]
				
				guard let controller = ((segue.destination) as? UINavigationController)?.topViewController as? DetailViewController else {
					return
				}
				
		        controller.note = note
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let note = notes[indexPath.row]
		cell.textLabel?.text = note.title
		cell.detailTextLabel?.text = df.string(from: note.dateModified)
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			notes.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveNotes(notes)
		default:
			break
		}
	}


}

extension MasterViewController: DetailViewControllerDelegate {
	
	func save() {
		saveNotes(self.notes)
	}
	
}
