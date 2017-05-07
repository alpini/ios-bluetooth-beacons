//
//  SSOViewController.swift
//  BeaconsAttendance
//
//  Created by Vamsi Yechoor on 4/25/17.
//  Copyright © 2017 Vamsi Yechoor. All rights reserved.
//

import WebKit
class SSOViewController: UIViewController, WKScriptMessageHandler {
    
    @IBOutlet var containerView: UIView? = nil
    
    var webView: WKWebView?
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.webView = WKWebView( frame: self.containerView!.bounds, configuration: config)
        self.view = self.webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //I use the file html in local
        let url = URL(fileURLWithPath: "https://shibboleth-yechoorv.cloudapps.unc.edu/secure/home.php")
        let req = URLRequest(url: url as URL)
        self.webView!.load(req)
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler"){
            print("\(message.body)")
        }
        self.webView!.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML",
                                         completionHandler: { (html: AnyObject?, error: NSError?) in
                                            self.processHTML(html: html as! String)
        } as? (Any?, Error?) -> Void)
    }
    
    func processHTML(html : String) {
        let onyen = "onyen"
        let affiliation = "affiliation"
        if let onyenRange = html.range(of: onyen), let affiliationRange = html.range(of: affiliation) {
            let range = onyenRange.lowerBound ..< affiliationRange.lowerBound
            print(html[range])
        }
    }
    
}
