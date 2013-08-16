

#import "ShopMenuItemLabel.h"


@implementation ShopMenuItemLabel
@synthesize  num, price, maxQuantity;

-(void) setIsEnabled: (BOOL)enabled
{
	if( _isEnabled != enabled ) {
		if(enabled == NO) {
			_colorBackup = [_label color];
            [_label setOpacity:150];
		}
		else
            [_label setOpacity:255];
	}
    
	[super setIsEnabled:enabled];
}


@end
