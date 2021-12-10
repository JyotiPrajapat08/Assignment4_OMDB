//
//  ViewController.swift
//  OMDB
//
//  Created by user193869 on 05/12/21.
//

import UIKit
import CoreData

public var favIDs = [String]()

class ViewController: UIViewController {

    
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var tblMovie: UITableView!
    @IBOutlet var lblDataNotFound: UILabel!
    
    private let networkService = NetworkService.shared()
    private var movies = [JSON.Search.Movie]() {
        didSet {
            handleTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        handleTable()
        btnFav.setTitle("Favourite", for: .normal)
        btnFav.setTitle("Favourite", for: .highlighted)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitle("Cancel", for: .highlighted)
        txtSearch.addTarget(self, action: #selector(didchange(textField:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favIDs = getSavedData()!.compactMap{$0.id}
        if favIDs.count > 0 {
            btnFav.isEnabled = true
        } else {
            btnFav.isEnabled = false
        }
        self.tblMovie.reloadData()
    }

    
    @IBAction func btnCancelTapped(sender: UIButton) {
        self.view.endEditing(true)
        txtSearch.text = "";
    }

    func handleTable() {
        DispatchQueue.main.async {
            if self.movies.count == 0 {
                self.tblMovie.isHidden = true
                self.lblDataNotFound.isHidden = false
            } else {
                self.tblMovie.isHidden = false
                self.lblDataNotFound.isHidden = true
            }
        }
    }
    
    func searchApi(text: String) {
        DispatchQueue.main.async {
            self.networkService.search(for: text) { (searchObject, error) in
                if let search = searchObject, error == nil {
                    if let searchReasults = search.results {
                        self.movies = searchReasults
                        DispatchQueue.main.async {
                            self.tblMovie.reloadData()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.movies.removeAll()
                            self.tblMovie.reloadData()
                        }
                    }
                }else{
                    print(error?.localizedDescription ?? "Error")
                    self.showAlert(title: "Search failed!", message: error?.localizedDescription ?? "Error")
                }
            }
        }
    }
    
    func openDetailsVC(objMovie: JSON.Search.Movie) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            vc.objMovie = objMovie
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func addMovieToFav(sender: UIButton) {
        self.view.endEditing(true)
        let movie = movies[sender.tag]
        print(movie)
        createData(movie: movie)
        favIDs = getSavedData()!.compactMap{$0.id}
        if favIDs.count > 0 {
            btnFav.isEnabled = true
        } else {
            btnFav.isEnabled = false
        }
        self.tblMovie.reloadData()
    }
}

extension ViewController : UITextFieldDelegate {
    
    @objc func didchange(textField: UITextField) {
        print(txtSearch.text)
        if favIDs.count > 0 {
            btnFav.isEnabled = true
        } else {
            btnFav.isEnabled = false
        }
        if !txtSearch.text!.isEmpty && txtSearch.text!.count > 2 {
            searchApi(text: txtSearch.text!)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tblMovie.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell {
            if movies.count > indexPath.row {
                let movie = movies[indexPath.row]
                
                cell.btnAdd.tag = indexPath.row
                cell.btnAdd.addTarget(self, action: #selector(addMovieToFav(sender: )), for: .touchUpInside)
                
                if favIDs.contains(movie.imdbID) {
                    cell.btnAdd.isEnabled = false
                } else {
                    cell.btnAdd.isEnabled = true
                }
                
                cell.lblName.text = movie.title
                cell.imgThumbnail.contentMode = .scaleAspectFit
                networkService.getImage(url: movie.poster) { data, error in
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
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        openDetailsVC(objMovie: movie)
        if favIDs.count > 0 {
            btnFav.isEnabled = true
        } else {
            btnFav.isEnabled = false
        }

    }
    
}

