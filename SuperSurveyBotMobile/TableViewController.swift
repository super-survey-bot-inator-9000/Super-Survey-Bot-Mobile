//
//  TableViewController.swift
//  SuperSurveyBotMobile
//
//  Created by Sloan Anderson on 2/10/19.
//  Copyright © 2019 Sloan Anderson. All rights reserved.
//

import UIKit
import Socket
import Foundation
import Dispatch
class TableViewController: UITableViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    var userID = "0"
    var question: String = ""
    var answers: [String] = []
    var answerValues: [String] = []
    var questionType: String = ""
    var selectedAnswers: [Int] = []
    let signature = try? Socket.Signature(protocolFamily: .inet, socketType: .stream, proto: .tcp, hostname: "localhost", port: 9000)!
    let socket = try? Socket.create()
    
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
        
        var valid = try? JSONSerialization.data(withJSONObject: jsonObject)
        let valid_packed = pack("!I", [valid?.count as Any])
        let encoded = "\(String(data: valid_packed, encoding: .ascii)!)\(String(data: valid!, encoding: .ascii)!)"
        
        do {
            try socket!.write(from: encoded)
        } catch {
            print("DAtA SEND ERROR")
            print(error.localizedDescription)
        }
        
        getData()
        self.tableView.reloadData()
    }
    
    func getData() {
        answers = []
        answerValues = []
        selectedAnswers = []
        var data = Data()
        let jsonObject: [String: Any] = [
            "DATA_TYPE": "QUESTION_REQUEST"]
        var valid = try? JSONSerialization.data(withJSONObject: jsonObject)
        let valid_packed = pack("!I", [valid?.count as Any])
        let encoded = "\(String(data: valid_packed, encoding: .ascii)!)\(String(data: valid!, encoding: .ascii)!)"
        
        print("IN GETDATA")
        
        do {
            print(encoded)
            try socket?.write(from: encoded)
        } catch {
            print("QUESTION REQUEST ERROR")
            print(error.localizedDescription)
        }
        
        print("WRItE COMPLETE")
        
        data.count = 0
        try? socket?.read(into: &data)
        
        if let response_len = try? unpack("!I", data[0..<4]) {
            let data_len = response_len[0]
            data = data[4..<data_len + 4]
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            question = jsonData??["QUESTION"] as! String
            questionType = jsonData??["TYPE"] as! String
            
            let answerArray = jsonData??["ANSWERS"] as! [Any]
            
            for answer in answerArray {
                if let answer = answer as? [String: String] {
                    if answer["DATA_VALUE"] != "<null>" {
                        answers.append(answer["TEXT"]!)
                        answerValues.append(answer["DATA_VALUE"]!)
                    }
                }
            }
        }
        questionLabel.text = question
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var data = Data()
        var isConnected: Bool = false
        let jsonObject: [String: Any] = [
            "DATA_TYPE":"USER_ID",
            "USER_ID":userID,
            "DEVICE_TYPE":"MOBILE"
        ]
        var valid = try? JSONSerialization.data(withJSONObject: jsonObject)
        let valid_packed = pack("!I", [valid?.count as Any])
        let encoded = "\(String(data: valid_packed, encoding: .ascii)!)\(String(data: valid!, encoding: .ascii)!)"
        
        try? socket?.connect(using: signature!)
        if !(socket?.isConnected)!{
            print("Can't connect")
        }
        
        print("Connected")
        
        try? socket!.write(from: encoded)
        data.count = 0
        try? socket?.read(into: &data)

        if let response_len = try? unpack("!I", data[0..<4]) {
            let data_len = response_len[0]
            data = data[4..<data_len + 4]
            print(String(decoding: data, as: UTF8.self))
        }
        
        getData()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        
        if questionType == "CHECKBOX" {
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
        let cellIdentifier = "AnswerCell"
        if questionType == "CHECKBOX"{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                        for: indexPath) as? CustomTableViewCell
            cell?.answerLabel.text = answers[indexPath.row]
            return cell!
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswers.append(indexPath.row)
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
