//
//  ViewController.swift
//  friends
//
//  Created by Faysal on 28/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items:[User] = []
    var itemCount = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            itemCount = 3
        }
        
        APIManager.shared.getUsersList(pageNo: 1, itemCnt: 10) { friends in
            DispatchQueue.main.async {
                self.items = friends
                self.collectionView.reloadData()
            }
        } onFail: { err in
            print(err.localizedDescription)
        }


    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Int(UIScreen.main.bounds.width) / itemCount) - 10, height:( Int(UIScreen.main.bounds.width) / itemCount ) + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as? FriendCell {
            let item = items[indexPath.row]
            cell.nameLbl.text = item.name.title + " " + item.name.first + " " + item.name.last
            cell.countryLbl.text = item.location.country
            if let imageUrl = URL(string: item.picture.thumbnail) {
                ImageManager.shared.requestImage(url: imageUrl) { (image) in
                    cell.profileImageView.image = image
                }
            }
            
            return cell
        }
                
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        controller.user = items[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
