//
//  MessageFeed.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/8/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

//
//  EncourageOthersNew.swift
//  EncourageMe
//
//  Created by Cory Kelly on 10/2/15.
//  Copyright © 2015 Cory Kelly. All rights reserved.
//

import UIKit
import Foundation



class MessageFeedController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
    @IBOutlet
    var tableView: UITableView!
    
    var messages : [[String:Any]] = []
    var currentMessage :[String:Any] = [:]
    var start = 0
    var size = 10
    
    
    
    let keywordCharacters = NSCharacterSet.alphanumerics
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    let threshold = 600 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    
    
    
    func getQueryParams(start: Int, size: Int, keyword: String) -> String
    {
        return "start=\(start)&size=\(size)&keyword=\(searchBar.text!)"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        populateMessages(queryParams: getQueryParams(start: start, size: size, keyword: searchBar.text!))
        refreshTable()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageFeedController.DismissKeyboard))
        tap.delegate = self
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.font = UIFont(name: "HelveticaLTStd-Light", size: 20)
        view.addGestureRecognizer(tap)
        
    }
    
    // UIGestureRecognizerDelegate method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isDescendant(of: self.tableView) {
            return false
        }
        return true
    }
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        self.getNextRequests()
        self.refreshTable()
        self.isLoadingMore = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let messageSize = StringUtils.heightForViewAll(text: messages[indexPath.row]["message"] as! String)
        let avatar = messages[indexPath.row]["avatar"] as! Int
        let calculatedSize = messageSize + 2*StringUtils.textMarginHorizontal
            + 40.0
        //let avatarSize = UIImage(named: "\(avatar).png")!.size.height
        return calculatedSize
        /*/
        if calculatedSize > avatarSize
        {
            return calculatedSize
        }
        else
        {
            return avatarSize
        }
         */
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MessageCell
        
        let message = messages[indexPath.row]["message"] as! String
        cell.message.text = message
        cell.submittedBy.text = "Submitted By: \(messages[indexPath.row]["author"] as! String)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        currentMessage = (messages[indexPath.row] as NSDictionary) as! [String : Any]
        
        
        
    }
    
    func refreshTable()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            self.isLoadingMore = false
        });
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        messages = []
        start = 0
        populateMessages(queryParams: getQueryParams(start: 0, size: 10, keyword: ""))
        refreshTable()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "")
        {
            messages = []
            start = 0
            populateMessages(queryParams: getQueryParams(start: 0, size: 10, keyword: ""))
            refreshTable()
        }
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let range = text.rangeOfCharacter(from: keywordCharacters)
        //Handle Search
        if(text.characters.count == 1 && text == "\n")
        {
            return true
        }
        //Handle backspace
        if(text.characters.count == 0)
        {
            return true
        }
        if let _ = range{
            return true
        }
        return false
    }
    
    func populateMessages(queryParams : String)
    {
        getMessages(queryParameters: queryParams, completionHandler: {(json, success) in
            print(success)
            self.messages += json
            self.tableView.reloadData()
            }
        )

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchString = StringUtils.removeQuotes(string: searchBar.text!)
        messages = []
        currentMessage = [:]
        start = 0
        populateMessages(queryParams: getQueryParams(start: 0, size: 10, keyword: searchString))
        refreshTable()
        
    }
    
    
    func getNextRequests() {
        start += size
        populateMessages(queryParams: getQueryParams(start: start, size: size, keyword: searchBar.text!))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if !isLoadingMore && (maximumOffset - contentOffset <= CGFloat(threshold)) {
            // Get more data - API call
            self.isLoadingMore = true
            self.getNextRequests()
        }
    }
    
    
    
    
}
 

