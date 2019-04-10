//
//  FirstViewController.swift
//  Bear Den
//
//  Created by 2019 Brandon Garrison on 1/14/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import UIKit
import Firebase



class timeLine: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var posts = [Post]()
    
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
        tableView.separatorStyle = .none
        
        let imageName = "backgroundG.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = imageView
        tableView.reloadData()
        print("Error 4")
        observePosts()
    }
    
    func observePosts(){
        let postRef = Database.database().reference().child("posts")
        
        postRef.observe(.value, with: { snapshot in
            
            var tempPosts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let author = dict["author"] as? [String: Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let photoURL = author["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let text = dict["text"] as? String,
                    let timestamp = dict["timestamp"] as? Double {
                    
                    let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
                    let post = Post(id: childSnapshot.key, author: userProfile , text: text, timestamp: timestamp)
                    tempPosts.append(post)
                    print("Error 0")
                }
                print("Error 2")
                
            }
            print("Error 3")
            self.posts = tempPosts
            self.tableView.reloadData()
        })
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

