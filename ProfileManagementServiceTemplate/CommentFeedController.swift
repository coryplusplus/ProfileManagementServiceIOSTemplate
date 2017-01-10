//
//  CommentFeedController.swift
//  ProfileManagementServiceTemplate
//
//  Created by Cory Kelly on 1/8/17.
//  Copyright © 2017 Cory Kelly. All rights reserved.
//

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
import Alamofire



class CommentFeedController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextViewDelegate {
    @IBOutlet
    var tableView: UITableView!
    
    @IBOutlet weak var addMessageTextView: UITextView!
    var comments : [[String:Any]] = []
    var currentMessage :[String:Any] = [:]
    var start = 0
    var size = 10
    var currentEditTag = 0

    
    
    
    @IBOutlet weak var clearMessage: UIButton!
    @IBOutlet weak var postMessage: UIButton!
    let keywordCharacters = NSCharacterSet.alphanumerics
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    let threshold = 600 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    
    
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        comments = []
        start = 0
        populateComments(queryParams: getQueryParams(start: start, size: size))
        refreshTable()
        
    }
    
    func getQueryParams(start: Int, size: Int) -> String
    {
        return "start=\(start)&size=\(size)"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMessageTextView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageFeedController.DismissKeyboard))
        tap.delegate = self
        
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
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(addMessageTextView.text! == "Leave comment...")
        {
            addMessageTextView.text = ""
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let messageSize = StringUtils.heightForViewAll(text: comments[indexPath.row]["message"] as! String)
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
        return comments.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MessageCell
        
        let comment = comments[indexPath.row]["message"] as! String
        let author = comments[indexPath.row]["author"] as! String
        cell.message.text = comment
        if(author == loggedInUser)
        {
            cell.submittedBy.isHidden = true
            cell.edit.isHidden = false
            cell.edit.tag = indexPath.row
        }
        else
        {
            cell.edit.isHidden = true
            cell.submittedBy.isHidden = false
        }

        cell.submittedBy.text = "Submitted By: \(comments[indexPath.row]["author"] as! String)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        currentMessage = (comments[indexPath.row] as NSDictionary) as! [String : Any]
        
        
        
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
        comments = []
        start = 0
        populateComments(queryParams: getQueryParams(start: 0, size: 10))
        refreshTable()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "")
        {
            comments = []
            start = 0
            populateComments(queryParams: getQueryParams(start: 0, size: 10))
            refreshTable()
        }
    }

    
    func populateComments(queryParams : String)
    {
        getComments(queryParameters: queryParams, messageId: currentMessage["id"] as! String, completionHandler: {(json, success) in
            print(success)
            self.comments += json
            self.tableView.reloadData()
            }
        )
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        comments = []
        start = 0
        populateComments(queryParams: getQueryParams(start: 0, size: 10))
        refreshTable()
        
    }
    
    
    func getNextRequests() {
        start += size
        populateComments(queryParams: getQueryParams(start: start, size: size))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if !isLoadingMore && (maximumOffset - contentOffset <= CGFloat(threshold)) {
            // Get more data - API call
            self.isLoadingMore = true
            self.getNextRequests()
        }
    }
    
    @IBAction func clearMessage(_ sender: AnyObject) {
        addMessageTextView.text = ""
    }
    
    @IBAction func postComment(_ sender: AnyObject) {
        
        var parameters: Parameters = [:]
        parameters["author"] = loggedInUser
        parameters["message"] = addMessageTextView.text!
        createComment(parameters: parameters, messageId:currentMessage["id"] as! String, completionHandler: {(message,success) in
            if(success)
            {
                self.comments = []
                self.start = 0
                self.populateComments(queryParams: self.getQueryParams(start: 0, size: 10))
                self.refreshTable()
                self.addMessageTextView.text = "Comment..."
            }
            else{
                let alertController = UIAlertController(title: "Error", message:
                    message, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            }
        )
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "editComment")
        {
            let editCommentViewController = segue.destination as! EditCommentViewController
            editCommentViewController.currentComment = comments[currentEditTag]
            
        }
        
    }
    
    @IBAction func editPressed(_ sender: AnyObject) {
        print("Sender tag is equal to \(sender.tag)")
        currentEditTag = sender.tag
        performSegue(withIdentifier: "editComment", sender: sender)

    }
    
    
}


