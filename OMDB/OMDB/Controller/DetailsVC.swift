//
//  DetailsVC.swift
//  OMDB
//
//  Created by user193869 on 05/12/21.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblRelease: UILabel!
    @IBOutlet var lblActors: UILabel!
    @IBOutlet var lblWriter: UILabel!
    @IBOutlet var lblAwards: UILabel!
    @IBOutlet var lblDirector: UILabel!
    
    var objMovie: JSON.Search.Movie?
    var movie: JSON.Movie?
    var movieID = ""
    private let networkService = NetworkService.shared()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(objMovie)
        setUI()
    }
    
    func setUI() {
        var id = movieID
        if id.isEmpty {
            id = objMovie!.imdbID 
        }
        networkService.getMovie(with: id) { fullMovie, error in
            self.movie = fullMovie
            DispatchQueue.main.async {
                self.lblTitle.text = self.movie!.title
                self.lblType.text = "Movie Type: " + self.movie!.type
                self.lblYear.text = "Movie year: " + self.movie!.year
                self.lblRating.text = "Rating: " + self.movie!.imdbRating + "/10"
                self.lblRelease.text = "Released on: " + self.movie!.released
                self.lblActors.text = "Actors : " + self.movie!.actors
                self.lblWriter.text = "Writer : " + self.movie!.writer
                self.lblAwards.text = "Awards : " + self.movie!.awards
                self.lblDirector.text = "Director : " + self.movie!.director
                
                self.networkService.getImage(url: self.movie!.poster) { data, error in
                    if let _data = data {
                        DispatchQueue.main.async {
                            self.imgThumbnail.image = UIImage(data: _data)
                            self.imgThumbnail.contentMode = .scaleAspectFit
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.imgThumbnail.image = UIImage(named: "no_image")
                            self.imgThumbnail.contentMode = .scaleAspectFit
                        }
                    }
                }
            }
        }
        
        
        
    }

}
