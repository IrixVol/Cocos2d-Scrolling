//
//  HelloWorldLayer.h
//  ShopScroll
//
//  Created by Irix on 14.08.13.
//  Copyright IrixTeam 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "Utils.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer //<GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
