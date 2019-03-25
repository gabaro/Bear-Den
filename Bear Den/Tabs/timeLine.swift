//
//  FirstViewController.swift
//  Bear Den
//
//  Created by 2019 Brandon Garrison on 1/14/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import UIKit


class timeLine: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var posts = [
        Post(id: "1", author: "Donald Trump", text: "Bigly!"),
        Post(id: "2", author: "Luke Skywalker", text: "I am not dead! fuck fuck fuck fuck fuck fuck fuck fuck fuck fuckf"),
        Post(id: "3", author: "Drizzy Drake", text: "Lick my ass from my taint to my crack, I know whats up, I'll show you all that")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        view.addSubview(tableView)
        
        var layoutGuide: UILayoutGuide!
        if #available(iOS 11.0, *){
            layoutGuide = view.safeAreaLayoutGuide
        }else{
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        return cell
    }
}

