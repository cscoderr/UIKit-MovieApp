//
//  SettingsViewController.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 1/31/25.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let identifier: String = "SettingsTableViewCell"
    let socials: [String] = [
        "Github",
        "Twitter",
        "LinkedIn"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
//        switch section {
//            case 0:
//                return "App Information"
//            default:
//                return nil
//        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
            case 0:
                return "View source code on Github!"
            case 1:
                return "Connect with me on all social medias"
            default:
                return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 1:
                return socials.count
            default:
                return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: "SettingsCell",
//                for: indexPath
//            )
//            cell.textLabel?.text = "More Settings"
//            cell.detailTextLabel?.text = "Explore all settings"
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        } 
         if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SocialCell",
                for: indexPath
            )
            cell.textLabel?.text = socials[indexPath.row] as String
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SettingsCell",
                for: indexPath
            )
            cell.textLabel?.text = "Source code"
            cell.detailTextLabel?.text = "Get our source code"
            cell.accessoryType = .detailButton
            return cell
        }
    }
    

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
