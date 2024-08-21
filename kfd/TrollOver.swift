//
//  TrollOver.swift
//  kfd
//
//  Created by Huy Nguyen on 13/01/2024.
//

import Foundation

func processDirectories() {
    guard let downloadURL = URL(string: "https://github.com/opa334/TrollStore/releases/latest/download/PersistenceHelper_Embedded") else {
        return
    }

    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
    }

    let embeddedPath = documentsDirectory.appendingPathComponent("Embedded")
    let mountDir = documentsDirectory.path
    var tipsAppDetected = false

    downloadFile(from: downloadURL, to: embeddedPath) { error in
        UIApplication.shared.dismissAlert(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let error = error {
                print("Error downloading file: \(error)")
                UIApplication.shared.alert(title: "Network Error", body: "Please check your connection to the network")
                //return
            }

            let mounted0Path = "\(mountDir)/mounted0"
            createFolderAndRedirectR("/var/containers/Bundle/Application/", mounted0Path)

            if let dirs0 = try? FileManager.default.contentsOfDirectory(atPath: mounted0Path) {
                for dir0 in dirs0 {
                    let mounted1Path = "\(mountDir)/mounted1"
                    createFolderAndRedirectR("/var/containers/Bundle/Application/\(dir0)", mounted1Path)

                    if let dirs1 = try? FileManager.default.contentsOfDirectory(atPath: mounted1Path) {
                        if dirs1.contains("Tips.app") {
                            tipsAppDetected = true
                            let mounted2Path = "\(mountDir)/mounted2"
                            createFolderAndRedirectR("/var/containers/Bundle/Application/\(dir0)/Tips.app", mounted2Path)

                            if let dirs2 = try? FileManager.default.contentsOfDirectory(atPath: mounted2Path) {
                                if dirs2.contains("Tips") {
                                    let success = kfdOverwrite(from: embeddedPath.path, to: "\(mounted2Path)/Tips")
                                    if success != 0 {
                                        UIApplication.shared.alert(title: "Error", body: "Press \"Respring to Apply\" or reboot your device and try again.\nI'd recommend trying \"Respring to Apply\" a few times before you reboot!")
                                    } else {
                                        UIApplication.shared.alert(title: "Successful", body: "Now press \"Respring to Apply\", then open the Tips app and install TrollStore.")
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if !tipsAppDetected {
                UIApplication.shared.dialog(title: "Error", body: "Tips app is not installed. Would you like to open the AppStore?", onOK: {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    if let url = URL(string: "https://apps.apple.com/us/app/tips/id1069509450") {
                        UIApplication.shared.open(url)
                    }
                })
            }
        }
    }
}

func downloadFile(from: URL, to: URL, completion: @escaping (Error?) -> Void) {
    URLSession.shared.downloadTask(with: from) { (tempURL, _, error) in
        guard let tempURL = tempURL else {
            completion(error)
            return
        }

        do {
            try FileManager.default.removeItem(at: to)
            try FileManager.default.copyItem(at: tempURL, to: to)
            completion(nil)
        } catch {
            completion(error)
        }
    }.resume()
}
