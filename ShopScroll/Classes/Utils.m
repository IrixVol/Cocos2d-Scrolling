//
//  Utils.m
//  CrowHunterVer1
//
//  Created by Irix on 03.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"


BOOL isIphone5()
{
    BOOL ret = NO;
#ifdef __CC_PLATFORM_IOS
    if (( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) & ( CC_CONTENT_SCALE_FACTOR() == 2 ) & ([[CCDirector sharedDirector] winSize].height ==568))
    { ret = YES;    }
#endif
    return ret;
}

float kIphoneIpad()
{
    float ret = 1.0;
#ifdef __CC_PLATFORM_IOS
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    { ret = 1024.0/480.0;   }
#endif
    return ret;
}

float kIpadIphone()
{
    float ret = 1;
#ifdef __CC_PLATFORM_IOS
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (isIphone5()) {ret = 568.0/(1024.0);} else {ret = 480.0/(1024.0); };
    }
#endif
    return ret;
}

float kIpadIphoneW()
{
    float ret = 1.0;
#ifdef __CC_PLATFORM_IOS
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    { ret = 320.0/768.0;   }
#endif
    return ret;
}



CCSprite* spriteWithColor (ccColor4B bgColor, CGSize textureSize)
{
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize.width height:textureSize.height];
    
    
    ccColor4F tmpColor = ccc4FFromccc4B(bgColor);
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:tmpColor.r g:tmpColor.g b:tmpColor.b a:tmpColor.a];
    
    // 3: Draw into the texture
    // We'll add this later
    
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}


