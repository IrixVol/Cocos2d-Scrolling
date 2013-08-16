

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShopMenuItemLabel : CCMenuItemLabel {
    int num;
    int price;
    int maxQuantity;
}
@property(readwrite) int num;
@property(readwrite) int price;
@property(readwrite) int maxQuantity;

@end
