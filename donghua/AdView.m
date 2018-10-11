//
//  AdView.m
//  donghua
//
//  Created by ° 郭伟 on 2018/10/11.
//  Copyright © 2018年 guowei. All rights reserved.
//

#import "AdView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface AdView ()
//播放器ViewController
@property(nonatomic, strong)AVPlayerViewController *AVPlayer;
@end

@implementation AdView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setMoviePlayer];
    }
    return self;
}

-(void)setMoviePlayer{
    
    //初始化AVPlayer
    self.AVPlayer = [[AVPlayerViewController alloc]init];
    //多分屏功能取消
    if (@available(iOS 9.0, *)) {
        self.AVPlayer.allowsPictureInPicturePlayback = NO;
    } else {
        // Fallback on earlier versions
    }
    //设置是否显示媒体播放组件
    self.AVPlayer.showsPlaybackControls = false;
    
    //本地路径
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"movie.mp4" ofType:nil];
    
    /***
     *  [NSURL fileURLWithPath:path]   URL获取本地路径 fileURLWithPath
     */
    
    //初始化一个播放单位。给AVplayer 使用
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:path]];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    
    //layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    [layer setFrame:[UIScreen mainScreen].bounds];
    //设置填充模式
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.AVPlayer.player = player;
    //添加到self.view上面去
    [self.layer addSublayer:layer];
    //开始播放
    [self.AVPlayer.player play];
    
    
    
    //这里设置的是重复播放。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
    
    
    //定时器。延迟3秒再出现进入应用按钮
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(setupLoginView) userInfo:nil repeats:YES];
    
}


//播放完成的代理
- (void)playDidEnd:(NSNotification *)Notification{
    //播放完成后。设置播放进度为0 。 重新播放
    [self.AVPlayer.player seekToTime:CMTimeMake(0, 1)];
    //开始播放
    [self.AVPlayer.player play];
}



- (void)setupLoginView
{
    //进入按钮
    UIButton *enterMainButton = [[UIButton alloc] init];
    enterMainButton.frame = CGRectMake(24, [UIScreen mainScreen].bounds.size.height - 32 - 48, [UIScreen mainScreen].bounds.size.width - 48, 48);
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 24;
    enterMainButton.alpha = 0;
    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    [self addSubview:enterMainButton];
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
        enterMainButton.alpha = 1;
    }];
}



- (void)enterMainAction:(UIButton *)btn {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
