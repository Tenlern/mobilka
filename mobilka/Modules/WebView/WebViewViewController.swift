//
//  WebViewViewController.swift
//  mobilka
//
//  Created by Ac Lo on 23/10/2019.
//  Copyright (c) 2019 Андрей Лихачев. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import WebKit

protocol WebViewDisplayLogic: class
{
  func displaySomething(viewModel: WebView.Something.ViewModel)
}

class WebViewViewController: UIViewController, WebViewDisplayLogic
{
  var interactor: WebViewBusinessLogic?
  var router: (NSObjectProtocol & WebViewRoutingLogic & WebViewDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = WebViewInteractor()
    let presenter = WebViewPresenter()
    let router = WebViewRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    let webView = WKWebView(frame: CGRect(x: 0, y: 40,
                                          width: self.view.frame.size.width,
                                          height: self.view.frame.size.height))
    self.view.addSubview(webView)
    let url = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
    webView.load(URLRequest(url: url!))
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = WebView.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: WebView.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}