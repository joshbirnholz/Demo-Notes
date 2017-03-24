//
//  InterfaceController.swift
//  Notes Extension
//
//  Created by Josh Birnholz on 3/15/17.
//  Copyright © 2017 Joshua Birnholz. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController {
	
	var notes: [Note] = []
	
	@IBOutlet var notesTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		WCSession.default().delegate = self
		WCSession.default().activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	func loadTable() {
		
		notesTable.setNumberOfRows(notes.count, withRowType: "NoteRow")
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		
		for i in 0 ..< notes.count {
			
			let row = notesTable.rowController(at: i) as! NoteRowController
			
			let note = notes[i]
			
			row.titleLabel.setText(note.title)
			row.dateLabel.setText(dateFormatter.string(from: note.dateModified))
			
		}
		
	}
	
	override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
		
		if segueIdentifier == "NoteDetail" {
			return notes[rowIndex].text
		}
		
		return nil
		
	}

}

extension InterfaceController: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		
		if activationState == .activated {
			print("WCSession activated")
		}
		
		if let error = error {
			print("Error activating WCSession:", error.localizedDescription)
		}
		
		guard let notesDict = WCSession.default().receivedApplicationContext["notes"] as? [[String: Any]] else {
			return
		}
		
		self.notes = notesDict.flatMap { Note(dictionary: $0) }
		
		loadTable()
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		print(#function)
		
		guard let notesDict = applicationContext["notes"] as? [[String: Any]] else {
			return
		}
		
		self.notes = notesDict.flatMap { Note(dictionary: $0) }
		
		loadTable()
		
	}
	
}
