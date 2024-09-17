//
//  PhotoViewController.swift
//  Social Network
//
//  Created by Alex on 01.07.2021.
//

import UIKit
import SDWebImage

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var photoCollection: UICollectionView!{
        didSet{
            photoCollection.delegate = self
            photoCollection.dataSource = self
            
        }
    }
    private let apiservice = APIService()
    private var photos: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        apisevice.getPhoto { photo in
//            print(photo)
//        }
       let group = DispatchGroup()
        group.enter()
        apiservice.getFriend { [weak self] photo in
            guard let self = self else {return}
            self.photos = photo
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.photoCollection.reloadData()
        }

    }


}
extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.photoCell.sd_setImage(with: URL(string: photo.photo100), placeholderImage: UIImage())
        return cell
        
    }
    
    
}
