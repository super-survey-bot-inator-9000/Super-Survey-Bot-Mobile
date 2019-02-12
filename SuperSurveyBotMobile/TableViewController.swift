//
//  TableViewController.swift
//  SuperSurveyBotMobile
//
//  Created by Sloan Anderson on 2/10/19.
//  Copyright © 2019 Sloan Anderson. All rights reserved.
//

import UIKit
class TableViewController: UITableViewController {

    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    var userID = "0"
    var question: String = ""
    var answers: [String] = []
    var answerValues: [String] = []
    var questionType: String = ""
    var selectedAnswers: [Int] = []
    
    @IBAction func SendData(_ sender: UIButton) {
        var values: String = ""
        var answerLabels: [String] = []
        for answer in selectedAnswers{
            values += String(answerValues[answer] + ",")
            answerLabels.append(answers[answer])
        }
        
        let jsonObject: [String: Any] = [
            "DATA_TYPE": "ANSWER_DATA",
            "ANSWER_VALUES": values,
            "QUESTION": question,
            "ANSWER_LABELS": [answerLabels]
        ]
        
        let valid = JSONSerialization.isValidJSONObject(jsonObject)
        
        
        //Send Json
        getData()
        self.tableView.reloadData()
    }
    
    func getData() {
        //do url
        
        //URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var isConnected: Bool = false
        let local = "http://localhost:9000"
        let url = URL(string: local)
        let jsonObject: [String: Any] = [
            "DATA_TYPE":"USER_ID", "USER_ID":userID, "DEVICE_TYPE":"MOBILE"
        ]
        let valid = try? JSONSerialization.data(withJSONObject: jsonObject)
        while isConnected == false{
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = valid
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in guard let data = data, error == nil else{
                    print(error?.localizedDescription ?? "No Data")
                    return
                }
                let responseJson = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJson = responseJson as? [String: Any]{
                    print(responseJson)
                }
            }
            task.resume()
        }
        getData()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        
        if questionType == "checkbox" {
            self.tableView.allowsMultipleSelection = true
            self.tableView.allowsMultipleSelectionDuringEditing = true
        }
        else {
            self.tableView.allowsMultipleSelection = false
            self.tableView.allowsMultipleSelectionDuringEditing = false
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return answers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if questionType == "checkbox"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath) as? MultipleSelectTableViewCell
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.selectedAnswers[indexPath.row])
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
