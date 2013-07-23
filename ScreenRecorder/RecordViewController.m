//
//  RecordViewController.m
//  ScreenRecorder
//
//  Created by Yoshiki Kurihara on 2013/07/23.
//  Copyright (c) 2013年 Yoshiki Kurihara. All rights reserved.
//

#import "RecordViewController.h"
#import <AVFoundation/AVFoundation.h>

#define DocumentsFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecordViewController ()

@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *stopButton;
@property (strong, nonatomic) CSScreenRecorder *screenRecorder;

@end

@implementation RecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _screenRecorder = [[CSScreenRecorder alloc] init];
        _screenRecorder.delegate = self;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"recordaudio"];
        [defaults synchronize];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    [_startButton sizeToFit];
    [_startButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    _stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [_stopButton sizeToFit];
    [_stopButton addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopButton];
    _stopButton.frame = CGRectOffset(_stopButton.frame, 0.0f, CGRectGetHeight(_startButton.frame));
    _stopButton.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)startRecord {
    NSString *moviePath = [NSString stringWithFormat:@"%@/video.mov", DocumentsFolder];
    if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
    }
    NSString *videoPath = [NSString stringWithFormat:@"%@/video.mp4", DocumentsFolder];
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
    }
    NSString *audioPath = [NSString stringWithFormat:@"%@/audio.caf", DocumentsFolder];
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
    }
    _startButton.enabled = NO;
    _stopButton.enabled = YES;
    _screenRecorder.videoOutPath = [NSString stringWithFormat:@"%@/video.mp4", DocumentsFolder];
    _screenRecorder.audioOutPath = [NSString stringWithFormat:@"%@/audio.caf", DocumentsFolder];
    [_screenRecorder startRecordingScreen];
}

- (void)stopRecord {
    _stopButton.enabled = NO;
    [_screenRecorder stopRecordingScreen];
    _startButton.enabled = YES;
}

@end
