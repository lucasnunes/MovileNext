//
//  EpisodesCollectionViewController.swift
//  MovileNext
//
//  Created by User on 14/06/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import UIKit
import TraktModels

let reuseIdentifier = "Cell"

class ShowCollectionViewController: UIViewController,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let trakt = TraktHTTPClient()
    
    var shows : [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.navigationItem.title = "Shows"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /*trakt.getShow("game-of-thrones") { result in
            println(result.value)
            self.shows.append(result.value!)
            self.collectionView.reloadData()
        }
        
        trakt.getShow("daredevil") { result in
            println(result.value)
            self.shows.append(result.value!)
            self.collectionView.reloadData()
        }*/
        
        /*trakt.getEpisode("game-of-thrones", season: 5, episode: 10) { result in
            println(result.value?.overview)
        }*/
        
        /*trakt.getEpisodes("game-of-thrones", season: 1) { result in
            println(result.value)
            println("Error \(result.error)")
        }*/
        
        trakt.getPopularShows() { result in
              let showResult = result.value!
              for show in showResult {
                self.shows.append(show)
              }
            
            self.collectionView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == Segue.season_to_episodes {
            if let cell = sender as? UICollectionViewCell,
                indexPath = collectionView.indexPathForCell(cell) {
                    let vc = segue.destinationViewController as! EpisodesListViewController
                    vc.show = shows[indexPath.row]
            }
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = Reusable.ShowCell.identifier!
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! SerieCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        let show = shows[indexPath.item]
        cell.titleView?.text = show.title
        cell.loadShow(show)
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemSize = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        let maxPerRow = floor(collectionView.bounds.width / itemSize)
        let userSpace = itemSize * maxPerRow
        let additionalSpace = flowLayout.minimumInteritemSpacing * maxPerRow
        
        let sideSpace = floor(((collectionView.bounds.width - userSpace) + additionalSpace) / (maxPerRow + 1))
        return UIEdgeInsetsMake(flowLayout.sectionInset.top, sideSpace, flowLayout.sectionInset.bottom, sideSpace)
    }
}
