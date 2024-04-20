//
//  ViewController.swift
//  project 4 ( Reminder )
//
//  Created by robusta on 20/04/2024.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var items = [MyReminder]()
    var addViewController = AddViewController()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        title = "Reminders"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController
        vc?.title = "New Reminder"
        vc?.navigationItem.largeTitleDisplayMode = .never
        vc?.completion = { title , body , date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let newItem = MyReminder(title: title, date: date, identifier: "id_\(title)")
                self.items.append(newItem)
                self.tableView.reloadData()
                self.scheduleTest(title: title , body: body , date: date)
            }
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func testButtonTapped(_ sender: UIBarButtonItem) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound]) { success, error in
            if success {
                self.scheduleTest()
            }else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleTest(title: String = "default" , body: String = "default" , date: Date = Date()) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        content.body = body
        
        let targetDate = date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year , .month , .day , .hour , .minute , .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            print(error?.localizedDescription as Any)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        let date = items[indexPath.row].date
        cell.textLabel?.text = items[indexPath.row].title
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
}

struct MyReminder: Codable {
    let title: String
    let date: Date
    let identifier: String
}

