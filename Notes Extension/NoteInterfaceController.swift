//
//  NoteInterfaceController.swift
//  Demo Notes
//
//  Created by Josh Birnholz on 3/15/17.
//  Copyright © 2017 Joshua Birnholz. All rights reserved.
//

import WatchKit
import Foundation


class NoteInterfaceController: WKInterfaceController {

	@IBOutlet var noteLabel: WKInterfaceLabel!
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
		guard let text = context as? String else {
			return
		}
		
		noteLabel.setText(text)
		
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
