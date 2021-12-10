//
//  FavVC.swift
//  OMDB
//
//  Created by user193869 on 05/12/21.
//

import UIKit

class FavVC: UIViewController {

    @IBOutlet var tblFavs: UITableView!
    private let networkService = NetworkService.shared()
    
    var movies = getSavedData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourites"
        favIDs = movies!.compactMap{$0.id}
        tblFavs.rowHeight = 120
//        getSavedData()
    }
    
    @objc func btnRemoveMovie(sender: UIButton) {
        let movie = movies![sender.tag]
        deleteData(id: movie.id!)
        movies = getSavedData()
        favIDs = movies!.compactMap{$0.id}
        self.tblFavs.reloadData()
    }
    
    func openDetailsVC(movieID: String) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            vc.movieID = movieID
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension FavVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tblFavs.dequeueReusableCell(withIdentifier: "FavTableViewCell") as? FavTableViewCell {
            let movie = movies![indexPath.row]

            cell.btnRemove.tag = indexPath.row
            cell.btnRemove.setTitle("Remove", for: .highlighted)
            cell.btnRemove.setTitle("Remove", for: .normal)
            cell.btnRemove.addTarget(self, action: #selector(btnRemoveMovie(sender: )), for: .touchUpInside)
            
            cell.lblTitle.text = movie.title
            cell.imgThumbnail.contentMode = .scaleAspectFit
            networkService.getImage(url: movie.poster!) { data, error in
                if let _data = data {
                    DispatchQueue.main.async {
                        cell.imgThumbnail.image = UIImage(data: _data)
                        cell.imgThumbnail.contentMode = .scaleAspectFill
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.imgThumbnail.image = UIImage(named: "no_image")
                    }
                }
            }

            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies![indexPath.row]
        openDetailsVC(movieID: movie.id!)
    }
    
}
