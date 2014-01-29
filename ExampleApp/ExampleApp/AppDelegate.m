//
//  AppDelegate.m
//  ExampleApp
//
//  Created by Thong Nguyen on 20/01/2014.
//  Copyright (c) 2014 Thong Nguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"
#import "STKAutoRecoveringHTTPDataSource.h"
#import "SampleQueueId.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate()
{
    STKAudioPlayer* audioPlayer;
}
@end

@implementation AppDelegate


-(BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    NSError* error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	self.window.backgroundColor = [UIColor whiteColor];
    
	audioPlayer = [[STKAudioPlayer alloc] init];
	AudioPlayerView* audioPlayerView = [[AudioPlayerView alloc] initWithFrame:self.window.bounds];
    
	audioPlayerView.delegate = self;
	audioPlayerView.audioPlayer = audioPlayer;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
	
	[self.window addSubview:audioPlayerView];
	
    [self.window makeKeyAndVisible];
	
    return YES;
}

-(BOOL) canBecomeFirstResponder
{
    return YES;
}

-(void) audioPlayerViewPlayFromHTTPSelected:(AudioPlayerView*)audioPlayerView
{
	NSURL* url = [NSURL URLWithString:@"http://fs.bloom.fm/oss/audiosamples/sample.mp3"];
    
    STKAutoRecoveringHTTPDataSource* dataSource = [[STKAutoRecoveringHTTPDataSource alloc] initWithHTTPDataSource:(STKHTTPDataSource*)[audioPlayer dataSourceFromURL:url]];
    
	[audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(void) audioPlayerViewQueueShortFileSelected:(AudioPlayerView*)audioPlayerView
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"airplane" ofType:@"aac"];
	NSURL* url = [NSURL fileURLWithPath:path];
    
	[audioPlayer queueDataSource:[audioPlayer dataSourceFromURL:url] withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(void) audioPlayerViewPlayFromLocalFileSelected:(AudioPlayerView*)audioPlayerView
{
	NSString* path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"m4a"];
	NSURL* url = [NSURL fileURLWithPath:path];
	
	[audioPlayer setDataSource:[audioPlayer dataSourceFromURL:url] withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

@end
