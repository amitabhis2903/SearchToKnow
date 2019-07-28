//
//  SearchViewController.swift
//  SearchToKnow
//
//  Created by A on 11/07/19.
//  Copyright © 2019 A. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    var descriptionData: TitleInfo?
    
    //ContainerView
    let searchView: UIView = {
        let view = UIView()
        //view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Search Bar
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        //search.barTintColor = Color.cornFlowerBlue
        search.placeholder = "Write Anything To Search"
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    //ImageView
    let searchImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    //TextView
    let resultText: UITextView = {
        let txtView = UITextView()
        txtView.isEditable = false
        txtView.font = UIFont.systemFont(ofSize: 16)
        txtView.textColor = Color.darkGray
        txtView.translatesAutoresizingMaskIntoConstraints = false
        return txtView
    }()
    
    
    //KnowMore
    let knowMoreBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Know more", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //Activity Indicator
    let activtyIndicator = UIActivityIndicatorView(style: .gray)
    
    var searchText: String?
    var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        activtyIndicator.center = view.center
        searchView.addSubview(searchBar)
        searchView.addSubview(searchImage)
        searchView.addSubview(resultText)
        resultText.addSubview(knowMoreBtn)
        searchView.addSubview(activtyIndicator)
        searchBar.delegate = self
        knowMoreBtn.isHidden = true
        
        setupContainerConstraint()
        setupConstraint()
        setupNavBar()
        
        knowMoreBtn.addTarget(self, action: #selector(knowMoreBtnPress), for: .touchUpInside)
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        observer = NotificationCenter.default.addObserver(forName: .speechText, object: nil, queue: OperationQueue.main) { (notification) in
            self.activtyIndicator.startAnimating()
            guard let popVC = notification.object as? PopupViewController else {
                return
            }
            self.searchText = popVC.searchLbl.text
            
            guard let text = self.searchText else {
                return
            }
            print(text)
            if text == "Say Something!" {
                DispatchQueue.main.async {
                    self.activtyIndicator.stopAnimating()
                }
            }else {
                self.getData(text: text)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        guard let observer = observer else {
            return
        }
        NotificationCenter.default.removeObserver(observer)
    }
    
    fileprivate func setupConstraint() {
        
        //Search Bar Constraints
        searchBar.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: 0).isActive = true
        searchBar.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 5).isActive = true
        
        
        //Iamge View Constraints
        searchImage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        
        searchImage.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 0).isActive = true
        searchImage.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: 0).isActive = true
        searchImage.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        
        //Result TextView constraints
        resultText.topAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: 20).isActive = true
        resultText.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 0).isActive = true
        resultText.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: 0).isActive = true
        resultText.bottomAnchor.constraint(equalTo: searchView.layoutMarginsGuide.bottomAnchor, constant: 10).isActive = true
        
        //Know More Btn Constraints
        knowMoreBtn.trailingAnchor.constraint(equalTo: resultText.trailingAnchor, constant: 0).isActive = true
        knowMoreBtn.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 0).isActive = true
        knowMoreBtn.bottomAnchor.constraint(equalTo: resultText.bottomAnchor, constant: 10).isActive = true
        knowMoreBtn.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    
    fileprivate func setupContainerConstraint() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)])
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                searchView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: searchView.bottomAnchor, multiplier: 1.0)
                ])
            
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                searchView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: standardSpacing)
                ])
        }
    }
    
    
    @objc func knowMoreBtnPress() {
        print("buttton press")
        
        if let urlString = self.descriptionData?.content_urls?.mobile?.page {
            if let url = URL(string: urlString){
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    //Setup Navigation Bar
    fileprivate func setupNavBar() {
        
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        self.navigationItem.setHidesBackButton(true, animated:true)
        let speechBtn = UIBarButtonItem(title: "Speech", style: .done, target: self, action: #selector(startSpeech))
        navigationItem.rightBarButtonItem  = speechBtn
    }
    
    //populate view
    @objc func startSpeech() {
        print("Speech")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as? PopupViewController {
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
    //handle notification
    @objc func handleSpeech(notification: Notification) {
        
    }
    
    
    //get data from internet
    fileprivate func getData(text: String) {
        var urlString = "https://en.wikipedia.org/api/rest_v1/page/summary/\(text)"
        urlString = urlString.replacingOccurrences(of: " ", with: "_")
        
        Service.shared.getData(urlString: urlString) { (random: TitleInfo?, error)   in
            
            if random?.extract == nil {
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: "Error", message: "No data found!")
                    self.activtyIndicator.stopAnimating()
                }
            }else {
                
                self.descriptionData = random
                
                
                if self.descriptionData?.thumbnail?.source != nil {
                    if let url = URL(string: (self.descriptionData?.thumbnail?.source)!) {
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url)
                            if let text = self.descriptionData?.extract {
                                print(text)
                                DispatchQueue.main.async {
                                    self.resultText.text = "\n\(text)"
                                    self.searchImage.image = UIImage(data: data!)
                                    self.activtyIndicator.stopAnimating()
                                    self.knowMoreBtn.isHidden = false
                                }
                            }
                        }
                    }
                }
                else  {
                    DispatchQueue.main.async {
                        self.resultText.text = self.descriptionData?.extract
                        self.searchImage.image = nil
                        self.activtyIndicator.stopAnimating()
                        self.knowMoreBtn.isHidden = false
                    }
                }
            }
        }
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        self.activtyIndicator.startAnimating()
        guard let searchTxt = searchBar.text else {
            return
        }
        
        self.getData(text: searchTxt)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            DispatchQueue.main.async {
                self.resultText.text = ""
                self.descriptionData = nil
                self.searchImage.image = nil
                self.knowMoreBtn.isHidden = true
                //Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
}
