//
//  ViewController.swift
//  Rovers
//
//  Created by air on 26.10.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
 
    private var projectView: ProjectViewProtocol
    private var model: ViewModelProtocol
    
    init(projectView: ProjectViewProtocol, model: ViewModelProtocol) {
        self.projectView = projectView
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        projectView = ProjectView()
        model = ViewModel()
        
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = projectView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.controller = self
        projectView.controller = self
    }
   
    func openMission(with url: URL) {
        let safariController = SFSafariViewController(url: url)
        safariController.modalPresentationStyle = .popover
        present(safariController, animated: true)
    }
    
    func selectedRover(_ rover: RoverType) {
        model.openRoverMissingPage(rover)
    }
}

