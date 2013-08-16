//
//  HelloWorldLayer.m
//  ShopScroll
//
//  Created by Irix on 14.08.13.
//  Copyright IrixTeam 2013. All rights reserved.
//


#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "ShopMenu.h"


#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        CGSize size = [[CCDirector sharedDirector] winSize];
        float kIphoneI5 = 1;
        if (isIphone5()) {kIphoneI5 = 1136.0/960.0;};
        
        // 1 - добавили фон, для Iphone5 его нужно промастабировать
        CCSprite* background = [CCSprite spriteWithFile:@"menu.png"];
        [background setScale: kIphoneI5];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild: background z:-1];
        
		// 2 - добавили надпись Game (останется пустышкой)
        CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Game" fontName:@"Marker Felt" fontSize:54];
        CCMenuItemFont *item1 = [CCMenuItemLabel itemWithLabel: label1 target:self selector:@selector(startGame)];
        [item1 setColor:ccc3(51, 102, 0)];
        
        // 3 - добавили надпись Shop (здесь будет основная процедура)
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Shop" fontName:@"Marker Felt" fontSize:54];
        CCMenuItemFont *item2 = [CCMenuItemLabel itemWithLabel: label2 target:self selector:@selector(goToShop)];
        [item2 setColor:ccc3(51, 102, 0)];

	    // 4 - создали меню
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, nil];
        //CCMenu *menu = [CCMenu menuWithItems: item2, nil];
		
		[menu alignItemsVerticallyWithPadding:0];
		[menu setPosition:ccp( size.width/2, size.height*3/4 )];
		
		[self addChild:menu];

	}
	return self;
}

- (void) startGame
{
    
}

- (void) goToShop
{
   [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ShopArt.plist"];
   [[CCDirector sharedDirector] pushScene:[CCTransitionCrossFade transitionWithDuration:0.2 scene:[ShopMenu node]]]; 
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{

	[super dealloc];
}


@end
