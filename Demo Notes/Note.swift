//
//  Note.swift
//  Demo Notes
//
//  Created by Josh Birnholz on 2/21/17.
//  Copyright © 2017 Joshua Birnholz. All rights reserved.
//

import Foundation
import WatchConnectivity

class Note {
	
	var id: UUID
	
	var text: String {
		didSet {
			dateModified = Date()
		}
	}
	
	var title: String {
		return text.components(separatedBy: "\n").first ?? ""
	}
	
	var dateModified: Date
	
	init(_ text: String = "", id: UUID = UUID(), dateModified: Date = Date()) {
		self.text = text
		self.id = id
		self.dateModified = dateModified
	}
	
	var dictionaryRepresentation: [String: Any] {
		var dict = [String: Any]()
		
		dict["text"] = text
		dict["id"] = id.uuidString
		dict["dateModified"] = dateModified
		
		return dict
	}
	
	init?(dictionary: [String: Any]) {
		guard
			let text = dictionary["text"] as? String,
			let idString = dictionary["id"] as? String,
			let id = UUID(uuidString: idString),
			let dateModified = dictionary["dateModified"] as? Date
		else {
				return nil
		}
		
		self.text = text
		self.id = id
		self.dateModified = dateModified
		
	}
	
}

extension Note: CustomStringConvertible {
	
	var description: String {
		return text
	}
	
}

extension Note: Equatable {
	
	static func == (lhs: Note, rhs: Note) -> Bool {
		return lhs.text == rhs.text
	}
	
}

let notesURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("notes.plist")

// MARK: Saving and loading

func saveNotes(_ notes: [Note]) {
	
	let noteDicts = notes.map { $0.dictionaryRepresentation }
	
	(noteDicts as NSArray).write(to: notesURL, atomically: true)
	
	// Transfer notes to watch
	
	let session = WCSession.default()
	
	guard session.activationState == .activated else {
		session.activate()
		return
	}
	
	try? session.updateApplicationContext(["notes": noteDicts])
	
}

func loadNotes() -> [Note] {
	
	guard let dicts = NSArray(contentsOf: notesURL) as? [[String : Any]] else {
		return []
	}
	
	return dicts.flatMap { Note(dictionary: $0) }
	
}
