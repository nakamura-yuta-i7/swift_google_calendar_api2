//
//  EventDetailViewController.swift
//  google_calendar_api
//
//  Created by 中村祐太 on 2016/10/10.
//  Copyright © 2016年 中村祐太. All rights reserved.
//

import UIKit
import GoogleAPIClient

class EventDetailViewController: UIViewController {

    var event: GTLCalendarEvent!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var inputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("★ EventDetailVC.event: ", event)
        
//        textView.text = StringUtil.jsonify(data: event!)
        textView.text = (event?.identifier)! + ": " + (event.recurringEventId ?? "")!
        inputTextView.text = event?.descriptionProperty
    }
    
    let api = GoogleCalendarApi()
    @IBAction func eventUpdateTapped(_ sender: AnyObject) {
        let service = api.getService()
        event.descriptionProperty = inputTextView.text
        let query = GTLQueryCalendar.queryForEventsUpdate(withObject: event, calendarId: "primary", eventId: event.identifier)
        service.executeQuery(
            query!,
            delegate: self,
            didFinish: #selector(EventDetailViewController.displayResultWithTicket(_:finishedWithObject:error:))
        )
    }

    func displayResultWithTicket(
        _ ticket: GTLServiceTicket,
        finishedWithObject response : GTLCalendarEvents,
        error : NSError?) {
        
        if let error = error {
            print("ERROR:", error.localizedDescription)
            return
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
