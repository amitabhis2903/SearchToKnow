//
//  ViewController.swift
//  SearchToKnow
//
//  Created by A on 11/07/19.
//  Copyright © 2019 A. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    //Title Label
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Search Anything To Know"
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
       // lbl.font = UIFont.fontNames(forFamilyName: "Times New Roman")
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    //Button
    let goBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Go For Search", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        btn.backgroundColor = Color.electricBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLbl)
        view.addSubview(goBtn)
        
        setupConstraint()
        goBtn.addTarget(self, action: #selector(goBtnPress), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: animated)
       
    }
    
    fileprivate func setupConstraint() {
        
        //Title Label Constraint
        titleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        titleLbl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Go Button Constraints
        goBtn.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        goBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20).isActive = true
        goBtn.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 300).isActive = true
        goBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    @objc func goBtnPress() {
        let serachVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        navigationController?.pushViewController(serachVC, animated: true)
    }
}
