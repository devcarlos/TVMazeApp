//
//  PersonViewController.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var tableView : UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    let dataSource = PersonDataSource()
    
    lazy var viewModel : PersonViewModel = {
        let viewModel = PersonViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupActivity()
        setupViewModel()
        
        //update person
        updatePersonData()
        
        //load person episodes
        loadShows()
    }
    
    func setupTableView() {
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
    }
    
    func setupActivity() {
        //activity indicator
        self.view.addSubview(activityIndicator)
        self.activityIndicator.frame = view.bounds
    }
    
    func setupViewModel() {
        // add error handling example
        self.viewModel.onErrorHandling = { [weak self] error in
            // show error message
            let message = "Something went wrong. Error: \(String(describing: error?.localizedDescription))"
            self?.showError(title: "An error occured", message: message)
        }
    }
    
    func updatePersonData() {
        
        guard let person = dataSource.person else {
            return
        }
        
        //load URL person image
        if let image = person.image {
            personImage.sd_setImage(with: URL(string: image.medium), placeholderImage: UIImage(named: "placeholder"))
        }
        
        //update person labels
        nameLabel.text = person.name
        birthdayLabel.text = person.birthday?.getFormattedDate()
        genderLabel.text = person.gender
    }
    
    func loadShows() {
        activityIndicator.startAnimating()
        
        guard let person = dataSource.person else {
            return
        }
        
        //API fetch person shows
        self.viewModel.fetchPersonShows(personId: person.id) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension PersonViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let show = dataSource.data[indexPath.row]
        
        let vc = ShowViewController.storyboardViewController()
        vc.dataSource.show = show
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

