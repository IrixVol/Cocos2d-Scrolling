

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ShopMenuItemLabel.h"
//#import <StoreKit/StoreKit.h>

#define tMove  700                    // tag moveAction of scrolling layer


@class MenuScroll;
@interface ShopMenu : CCScene {
    
    MenuScroll*  cLayer;  
}
@property (nonatomic, retain) MenuScroll * cLayer;

@end



@interface MenuScroll : CCLayerColor
{
    
	BOOL isDragging;                    // помечаем процесс движения пальца по скроллингу. Кнопка "купить" при таком движении блокируется
    BOOL isOverSize;                    // скроллинг вышел за пределы своего допустимого положения
	BOOL touched;                       // скроллинг начинает движение
	float accumulatedYDifference;       // перемещение пальца, накопленное в процессе ccTouchesMoved, но еще не примененное к скроллингу (микродвижения не должны двигать скроллинг)
    float touchStartY;                  // начальная координата Y движения пальца, нужно для отслеживания быстрых движений
    NSTimeInterval touchStart;          // начальное время движения пальца, нужно для отслеживания быстрых движений

    float contentHeight_;               // высота всего скроллинга
    CGRect scrollWindowRect_;           // видимый прямоугольник скроллинга (пространство между верхней и нижней доской)
    
    CCSpriteBatchNode* spriteBatch;
    
}
+(id) nodeWithTop: (float) top;


@end

