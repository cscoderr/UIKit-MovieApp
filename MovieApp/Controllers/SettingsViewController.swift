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
        "LinkedIn",
        "Instagram"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "App Information"
            case 1:
                return "Acknowledge"
            case 2:
                return "Links"
            case 3:
                return "Our Medias"
            default:
                return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
                //            case 0:
                //                return "App Information"
                //            case 1:
                //                return "Acknowledge"
            case 2:
                return "You can click the link to know more about the app"
            case 3:
                return "Connect with us on all social medias"
            default:
                return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 3:
                return socials.count
            default:
                return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SettingsCell",
                for: indexPath
            )
            cell.textLabel?.text = "More Settings"
            cell.detailTextLabel?.text = "Explore all settings"
            cell.accessoryType = .disclosureIndicator
            return cell
        } else  if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "SettingsCell",
                for: indexPath
            )
            cell.textLabel?.text = "Acknowledgement"
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = "Thanks to all"
            return cell
        } else  if indexPath.section == 3 {
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
