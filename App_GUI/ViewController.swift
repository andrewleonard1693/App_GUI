//
//  ViewController.swift
//  App_GUI
//
//  Created by AJ Leonard on 1/21/19.
//  Copyright © 2019 AJ Leonard. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import PromiseKit

class ViewController: NSViewController {
    var apps:[App] = []
    let githubRaw = "https://raw.githubusercontent.com/Homebrew/homebrew-cask/master/Casks/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title:String=""
        let myGroup = DispatchGroup()
        createListOfApps(mydispatch: myGroup)
        myGroup.notify(queue: .main){
//            for app in self.apps{
//                print(app.githubRaw)
//            }
            title="gotem"
            let myButton = NSButton(title: title, target: self, action: #selector(self.myButtonAction))
            self.view.addSubview(myButton)
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @objc func myButtonAction(sender: NSButton!) {
        print(sender.title)
    }
    func createListOfApps(mydispatch:DispatchGroup){
        //check if the cask list exists
        if let path = Bundle.main.path(forResource: "cask_names", ofType: "txt" , inDirectory: "Resources"){
            //get the contents of the file
            let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            //separate the casks by newlines
            let casks = text.components(separatedBy: .newlines)
                for cask in casks{
                    if(cask.isEmpty){
                        continue
                    }
                    
                    mydispatch.enter()
                    let url = githubRaw + cask
                    Alamofire.request(url).responseString{
                        response in
//                        print(response.response?.expectedContentLength as! Int64)
                        switch(response.result) {
                        case .success(_):
                            if let data = response.result.value {
                                let appObj:App? = self.parseGithubRaw(githubRaw: data, cask: cask)
//                                self.apps.append(appObj!)
                                mydispatch.leave()
                            }
                        case .failure(_):
                            mydispatch.leave()
                            print("Error message:\(String(describing: response.result.error))")
                            break
                        }
                    }
                }
        }else{
            print("File not found")
        }
    }
    func parseGithubRaw(githubRaw:String, cask:String) -> App? {
        //TODO: Parse the github raw gile, create a new app object and return it to the main view controller to be added to the array of apps
        let separatedByNewline = githubRaw.components(separatedBy: .newlines)
        for line in separatedByNewline {
            let currentLineTrimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            let split = currentLineTrimmed.components(separatedBy: .whitespaces)
            
            var version:String = ""
            var url:String = ""
            var app:String = ""
            
            switch split[0] {
            case "app":
                app = currentLineTrimmed.components(separatedBy: "app ")[1]
                if app.contains("target: ") {
                    app = app.components(separatedBy: "target: ")[1]
                }
                print(app)
            case "version":
                version = currentLineTrimmed.components(separatedBy: "version ")[1]
                print(version)
            case "url":
            //TODO: handle url logic - replace all permutations of version in the url
                url = currentLineTrimmed.components(separatedBy: "url ")[1]
                print(url)
            default:
                break
            }
        }
        return nil
    }
}
            
//            for cask in casks {
//                //empty line check
//                if(cask.isEmpty){
//                    continue
//                }
//                let url = githubRaw + cask
//                Alamofire.request(url).responseString{
//                    response in
//                    switch(response.result) {
//                    case .success(_):
//                        if let data = response.result.value {
//                            //separate the files
//                            self.apps.append(App(github_raw: data)!)
//                            print(self.apps.count)
//                            print(self.apps[0].github_raw)
////                            let com = data.components(separatedBy: .newlines)
////                            var version = ""
////                            var url = ""
////                            var app = ""
//                            for item in com {
//                                //split on space
//                                let line = item.trimmingCharacters(in: .whitespacesAndNewlines)
//                                let lineSep = line.components(separatedBy: .whitespaces)
//                                //get the app name
//                                if(lineSep[0]=="app"){
//                                    for i in 1..<lineSep.count{
//                                        app+=lineSep[i]
//                                    }
//                                    app = String(app.split(separator: ".")[0])
//                                    print(app)
//                                }
//                                //get the version
//                                if(lineSep[0]=="version"){
//                                    version = lineSep[1].replacingOccurrences(of: "'", with: "")
//                                }
//                                if(lineSep[0]=="url"){
//                                    var url = ""
//                                    for i in 1..<lineSep.count{
//                                        url+=lineSep[i]
//                                    }
//                                    url = url.replacingOccurrences(of: "'", with: "")
//                                    url = url.replacingOccurrences(of: "\"", with: "")
//
//                                    if(url.contains("#{version}")){
//                                        url = url.replacingOccurrences(of: "#{version}", with: version)
//                                    }
//                                    //perform the download
//                                    let destination = DownloadRequest.suggestedDownloadDestination(for: .downloadsDirectory)
//                                    Alamofire.download(url, to: destination)
//                                        .downloadProgress {progress in
//                                            print("Progress: \(Double(round(progress.fractionCompleted*1000)/1000))")
//                                        }
//                                        .response{
//                                            response in
//                                            //get the suggested file name chosen by alamofire
//                                            let destination = response.destinationURL!.absoluteString.split(separator: "/")
//                                            let fileName = destination[destination.count-1]
//                                            print(fileName)
//                                    }
//                                }
//                            }
//                        }
//                    case .failure(_):
//                        print("Error message:\(String(describing: response.result.error))")
//                        break
//                    }
//                }

