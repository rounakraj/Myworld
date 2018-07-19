//
//  PlayerView.swift
//  MyWorld
//
//  Created by Shankar Kumar on 07/01/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit
import CoreFoundation

protocol PlayerViewDelegate{
    func backFromPlayerView(url:String)
}

class PlayerView: UIView {
    var delegate: PlayerViewDelegate?
    var player:AVPlayer?
    var videoURL:NSURL?
    var urlStr = String()

    @IBOutlet weak var uiview: UIView!
    @IBOutlet weak var playBtn: UIButton!
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    /* func setUpview(url:String?){
     let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
     let player = AVPlayer(url: videoURL!)
     let playerViewController = AVPlayerViewController()
     playerViewController.player = player
     playerViewController.view.frame = self.frame
     self.addSubview(playerViewController.view)
     }*/
    
    func setUpview(url:String?) {
        self.urlStr = url ?? ""
        videoURL = NSURL(string: url ?? "")
        let item = AVPlayerItem.init(url: videoURL! as URL)
        player = AVPlayer(playerItem: item)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = uiview.layer.bounds
        //playerLayer.videoGravity = AVLayerVideoGravity.resize
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        uiview.layer.backgroundColor = UIColor.green.cgColor
        uiview.backgroundColor = UIColor.yellow
        uiview.layer.addSublayer(playerLayer)
        player?.volume = 50
        player?.automaticallyWaitsToMinimizeStalling = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        uiview.layer.masksToBounds = true
        //self.addZoomBtn()
    }
   
    @IBAction func PlayAction(_ sender: UIButton) {
       /* if sender.currentTitle == "Play" {
            player?.play()
            sender.setTitle("Pause", for: .normal)
        }else{
            player?.pause()
            sender.setTitle("Play", for: .normal)
        }*/
        self.Zoom()
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        playBtn.setTitle("Play", for: .normal)
    }
    
    
    /*func addZoomBtn(){
        //let window = UIApplication.shared.keyWindow!
        let v = UIView(frame: CGRect(x: self.frame.size.width/2 - 100, y: self.frame.size.height/2 - 100, width: 100, height: 100))
        v.backgroundColor = UIColor.black
        //window.addSubview(v);
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Zoom))
        v.addGestureRecognizer(tapGesture)
        self.superview?.addSubview(v)
    }*/
    
    @objc func Zoom(){
       delegate?.backFromPlayerView(url: self.urlStr)
    }
    
}
