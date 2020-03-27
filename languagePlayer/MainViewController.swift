//
//  MainViewController.swift
//  languagePlayer
//
//  Created by Harunori Uchida on 2020/03/27.
//  Copyright © 2020 atrasc.co.jp. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UITableViewController {
	
	var items:[String] = [];
	var selectedIndex:Int = -1;
	private var audioPlayer:AVAudioPlayer!;

    override func viewDidLoad() {
        super.viewDidLoad()

		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		
		let path = Bundle.main.bundlePath;
		let fileManager = FileManager();
		do {
			let files = try fileManager.contentsOfDirectory(atPath: path);
			for file in files {
				if(file.hasSuffix(".wav")){
					items.append(file);
				}
			}
		}
		catch let error {
			print(error);
		}
		items = items.sorted { $0 < $1 }
    }
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.count;
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	  let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
	  ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")

		cell.textLabel?.text = self.items[indexPath.row];

	  return cell
	}
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
		indexPath.row == indexPathForSelectedRow.row{
			//print(indexPath, indexPathForSelectedRow)
			audioPlayer.stop();
			tableView.deselectRow(at: indexPathForSelectedRow, animated: false)
			return nil;
		}
		return indexPath;
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let fileName = self.items[indexPath.row].fileName();
		self.playSound(name:fileName );
	}
	

	
}

extension MainViewController:AVAudioPlayerDelegate  {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "wav") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch {
        }
    }
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {    if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
		tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
		}
	}
}


extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
