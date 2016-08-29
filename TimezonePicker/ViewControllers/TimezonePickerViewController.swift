//
//  TimezonePickerViewController.swift
//  TimezonePicker
//
//  Created by Stefan Lazarevski on 7/29/16.
//  Copyright © 2016 Stefan Lazarevski. All rights reserved.
//

import Foundation
import UIKit

public class TimezonePickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, TimeZonePicker, UINavigationBarDelegate {
    
    //MARK: - UI Elements -
    @IBOutlet weak var timezoneTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
 
    
    //MARK: - Class Variables
    var selectedTimeZone: NSTimeZone?
    var uniqueTimeZones = [NSTimeZone?]()
    var currentTimeZoneList = [NSTimeZone?]()
    var filteredTimeZoneList = [NSTimeZone?]()
    
    var searchActive : Bool = false
    weak public var delegate: TimeZonePickerDelegate?
    

    @IBAction func cancelPressed(sender: AnyObject) {
        self.searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: - View Controller Lifecycle -
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeNavigationBar()
        self.loadTimezones()
        self.currentTimeZoneList = self.uniqueTimeZones
        self.setDelegates()
        
    }
    
    
    func makeNavigationBar(){
    
        let screenWidth = UIScreen.mainScreen().bounds.width
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, screenWidth, 64)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Pick Timezone"
        

   
        let leftButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(self.dismissSelf))
        
        navigationItem.leftBarButtonItem = leftButton

        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
     
        self.view.addSubview(navigationBar)
        

    }
    
    func loadTimezones(){
        

        self.uniqueTimeZones = []
        
        let knownTimezoneNames = NSTimeZone.knownTimeZoneNames()
        var timezones = knownTimezoneNames.map { NSTimeZone(name: $0) }
        var localizedNames = Set(knownTimezoneNames.map { NSTimeZone(name:$0)!.usLocalizedName })
        
        timezones.sortInPlace({$0!.secondsFromGMT < $1!.secondsFromGMT})
        
        
        let uniqueTimezones = timezones.filter {
            
            let local = $0!.usLocalizedName
            
            if localizedNames.contains(local) {
                
                localizedNames.remove(local)
                return true
            }
            else { return false }
        }
        
        self.uniqueTimeZones = uniqueTimezones
    }
  
    
    func setDelegates() {
        
        self.timezoneTableView.delegate = self
        self.timezoneTableView.dataSource = self
        self.timezoneTableView.registerNib(TimezonePickerCell.fromNib(), forCellReuseIdentifier: "TimezoneCell")
        self.searchBar.delegate = self
    }
    
    static func fromNib() -> TimezonePickerViewController {
        
        return TimezonePickerViewController(nibName: "TimezonePickerViewController", bundle: nil)
       
    }
    
    //MARK: TableView Delegate Methods
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            return filteredTimeZoneList.count
        }
        return currentTimeZoneList.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimezoneCell") as! TimezonePickerCell
        
            if searchActive {
                cell.tzNameLabel.text = self.filteredTimeZoneList[indexPath.row]?.usLocalizedName
            }
            else {
                cell.tzNameLabel.text = self.currentTimeZoneList[indexPath.row]?.usLocalizedName
            }

        if searchActive {
        cell.gmtOffsetLabel.text = self.filteredTimeZoneList[indexPath.row]?.formattedOffsetFromGMT
        }
        else {
            cell.gmtOffsetLabel.text = self.currentTimeZoneList[indexPath.row]?.formattedOffsetFromGMT
        }
        
        return cell
    }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var timezone: NSTimeZone
        var displayText: String
        
        if searchActive {
            timezone = self.filteredTimeZoneList[indexPath.row]!
        } else {
            timezone = self.currentTimeZoneList[indexPath.row]!
        }
        

        displayText = timezone.usLocalizedName

        
        self.searchBar.resignFirstResponder()
        self.delegate?.timezoneSelected(timezone, displayString: displayText)
        self.dismissSelf()
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: Seach Bar Methods
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searchActive = false
            searchBar.endEditing(true)
            return
        }
        
        filteredTimeZoneList = currentTimeZoneList.filter({ (timezone) -> Bool in
          
            let tmp: NSString! = (timezone?.usLocalizedName)!

            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            return range.location != NSNotFound
        })
        
        self.timezoneTableView.reloadData()
    }
    
    
    public func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
        searchBar.text = ""
        filteredTimeZoneList = currentTimeZoneList
        timezoneTableView.reloadData()
        
    }
    
    public func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        if !searchActive {
            filteredTimeZoneList = []
            timezoneTableView.reloadData()
        }
    }
    
    
    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchActive = true
        searchBar.resignFirstResponder()
    }

    
} //END






