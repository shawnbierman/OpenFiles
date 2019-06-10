//
//  ObjectDataSource.swift
//  OpenFiles
//
//  Created by Shawn Bierman on 6/9/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class ObjectDataSource: NSObject, UITableViewDataSource {
    
    var objects = [String]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = objects[indexPath.row] 
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
}
