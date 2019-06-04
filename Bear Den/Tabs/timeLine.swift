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
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 3.0
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    var refreshControl: UIRefreshControl!
    
    var postsRef:DatabaseReference {
        return Database.database().reference().child("posts")
    }
    
    var oldPostsQuery:DatabaseQuery {
        let lastPost = self.posts.last
        var queryRef:DatabaseQuery
        if lastPost != nil{
            let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp)
        }else{
            queryRef = postsRef.queryOrdered(byChild: "timestamp")
        }
        return queryRef
    }
    var newPostsQuery:DatabaseQuery {
        let firstPost = self.posts.first
        var queryRef:DatabaseQuery
        if firstPost != nil{
            let firstTimeStamp = firstPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryStarting(atValue: firstTimeStamp)
        }else{
            queryRef = postsRef.queryOrdered(byChild: "timestamp")
        }
        return queryRef
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
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
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        beginBatchFetch()
    }
    
    
    @objc func handleRefresh(){
        print("Refresh!")
        newPostsQuery.queryLimited(toFirst: 20).observeSingleEvent(of: .value, with: { snapshot in
            
            var tempPosts = [Post]()
            
            let firstPost = self.posts.first
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String: Any],
                    let post = Post.parse(childSnapshot.key, data),
                    childSnapshot.key != firstPost?.id {
                    
                    tempPosts.insert(post, at: 0)
                }
                
            }
            self.posts.insert(contentsOf: tempPosts, at: 0)
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
    })
    }
    
    
    
    func fetchPosts(completion: @escaping(_ posts:[Post])->()){
        oldPostsQuery.queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { snapshot in
            
            var tempPosts = [Post]()
            
            let lastPost = self.posts.last
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String: Any],
                    let post = Post.parse(childSnapshot.key, data),
                    childSnapshot.key != lastPost?.id {
                    
                        tempPosts.insert(post, at: 0)
                }
                
            }
            return completion(tempPosts)})
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return posts.count
        }else{
            return fetchingMore ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            cell.set(post: posts[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 72.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
            
            if !fetchingMore && !endReached{
                beginBatchFetch()
            }
        }
    }
    func beginBatchFetch() {
        fetchingMore = true
        tableView.reloadSections((IndexSet(integer: 1)), with: .fade)
        fetchPosts { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.endReached = newPosts.count == 0
            self.fetchingMore = false
            UIView.performWithoutAnimation {
                 self.tableView.reloadData()
            }
        }
    }
    
}

