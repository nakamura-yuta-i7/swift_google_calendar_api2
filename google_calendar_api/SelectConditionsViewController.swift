//
//  SelectConditionsViewController.swift
//  google_calendar_api
//
//  Created by 中村祐太 on 2016/10/09.
//  Copyright © 2016年 中村祐太. All rights reserved.
//

import UIKit
import GoogleAPIClient
import GTMOAuth2

class Event {
}

class SelectConditionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let api = GoogleCalendarApi()
    
    var events: [GTLCalendarEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchEvents()
    }
    func fetchEvents() {
        let service = api.getService()
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let inAnHour = cal.date(byAdding: .hour, value: 1, to: Date(), options: NSCalendar.Options())
        let prevAnHour = cal.date(byAdding: .hour, value: -1, to: Date(), options: NSCalendar.Options())
        
        let query = GTLQueryCalendar.queryForEventsList(withCalendarId: "primary")
        query?.maxResults = 100
        query?.timeMax = GTLDateTime(date: inAnHour, timeZone: TimeZone.autoupdatingCurrent)
        query?.timeMin = GTLDateTime(date: prevAnHour, timeZone: TimeZone.autoupdatingCurrent)
        query?.singleEvents = true
        query?.orderBy = kGTLCalendarOrderByStartTime
        service.executeQuery(
            query!,
            delegate: self,
            didFinish: #selector(SelectConditionsViewController.displayResultWithTicket(_:finishedWithObject:error:))
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
        
        events = response.items() as! [GTLCalendarEvent]
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
        
        let event = events[indexPath.row]
        
        print("★ event: ")
        debugPrint("event.identifier:", event.identifier)
        debugPrint("event.recurringEventId:", event.recurringEventId ?? "" )
        debugPrint("event.start:", event.start)
        debugPrint("event.end:", event.end)
        debugPrint("event.attendees", event.attendees ?? [])
        debugPrint("event", event)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let start : GTLDateTime! = event.start.dateTime ?? event.start.date
        let startString = df.string(from: start.date)
        
        cell.textLabel?.text = startString + " " + event.summary
        cell.detailTextLabel?.text = event.identifier
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        performSegue(withIdentifier: "gotoEventDetailSegue", sender: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "gotoEventDetailSegue" ) {
            let edVC:EventDetailViewController = segue.destination as! EventDetailViewController
            edVC.event = sender as! GTLCalendarEvent?
        }
    }

}
