//
//  ViewController.swift
//  Easy browser
//
//  Created by Usertqi on 11/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
        
    // MARK: - VARIABLES -
    var websites = ["apple.com","google.com"]
    var webView: WKWebView!
    
    //MARK: - LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getService()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(openTapped))
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    // MARK: - IBACTIONS -
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...",
                                   message: nil,
                                   preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website,
                                       style: .default,
                                       handler: openPage))}
        ac.addAction(UIAlertAction(title: "cancel",
                                   style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

// MARK: - AUX FUNC -
extension ViewController {
    func getService() {
        guard let url = URL(string: "https://" + websites[0]) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
}
