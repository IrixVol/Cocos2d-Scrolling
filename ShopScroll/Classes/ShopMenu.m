

#import "ShopMenu.h"
#import "Utils.h"



@implementation ShopMenu
@synthesize cLayer;

- (id)init {
    
    if ((self = [super init])) {       
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // задний фон с затемнением
        [self makeMainFon];
        
        // верхняя доска
        CCSprite *deskTop = [CCSprite spriteWithSpriteFrameName:@"boxDesk.png"];
        deskTop.position = ccp(0,size.height);
        deskTop.flipY = YES;
        deskTop.anchorPoint = ccp (0.0,1.0);
        [self addChild: deskTop z:2];
        
        // нижняя доска
        CCSprite *deskBotton = [CCSprite spriteWithSpriteFrameName:@"boxDesk.png"];
        deskBotton.position = ccp(0,0);
        deskBotton.anchorPoint = ccp (0.0,0.0);
        [self addChild: deskBotton z:2];

        // кнопка выход
        CCLabelBMFont* LabelBack = [CCLabelBMFont labelWithString: @"НАЗАД" fntFile:@"ShopFont.fnt"];
        CCMenuItemLabel * buttonBack = [CCMenuItemLabel itemWithLabel: LabelBack target:self selector:@selector(exitShop)];
        CCMenu *menuBack = [CCMenu menuWithItems: buttonBack, nil];
        menuBack.position = ccp(size.width*0.20, deskTop.boundingBox.size.height/2);
        [deskTop addChild: menuBack];
        
        // скроллинг слой
        self.cLayer = [MenuScroll nodeWithTop:deskTop.boundingBox.size.height];
        [self addChild: cLayer z:1];
    }
              	
	return self;
}

-(void) makeMainFon
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    float kIphoneI5 = 1;  // коэффициент масштабирования заднего фона для Iphone5
    if (isIphone5()) {kIphoneI5 = 1136.0/960.0;};
    
    // 1 - добавили фон, для Iphone5 его нужно промастабировать
    CCSprite* background = [CCSprite spriteWithFile:@"menu.png"];
    [background setScale: kIphoneI5];
    background.position = ccp(size.width/2, size.height/2);
    [self addChild: background z:-2];
    
    // затемнение
    CCSprite* tmpSp = spriteWithColor(ccc4(0,0,0,255), size);
    tmpSp.position= CGPointMake(size.width/2, size.height/2);    
    [tmpSp setOpacity:160];
    [self addChild:tmpSp z:-1 ];

}


- (void)dealloc {
    
    [cLayer release];
    [super dealloc];
}

-(void) exitShop
{
    [[CCDirector sharedDirector] popScene];
}



@end

//------------------------------
#define kMenu 2000                  // tag меню 
#define SPIN_TRIGGER_THRESHOLD 2.0  // минимальное движение, на которое не нужно выполнять прокрутку
#define maxVelocity 6000            // максимально быстрое двидение пальцем
#define kVelosity 500               // быстрое движение пальцем, которое запускает скролинг крутиться, когда палец уже не двигается по экрану

@implementation MenuScroll

+(id) nodeWithTop: (float) top
{
	return [[[self alloc] initWithTop:top] autorelease];
}

// размещаем покупки (картинки, надписи, кнопки "купить" и т.п.) на скроллинг-слое
// кнопка купить - элемент меню
- (id) initWithTop: (float) top
{
    
    float kPadding;
    int   kRowCount  = 8;   // 1 -количество покупок в магазине
    int   kPad       = 1;   if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {kPad = 2;};
    float kRowHeight;
    
    // 2 - рассчет высоты одной строки
    if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        kRowHeight = 266; 
    } else {
        if (isIphone5()) {kRowHeight = 114;
        } else {kRowHeight = 123;}  
    }

    CGSize size = [[CCDirector sharedDirector] winSize];    
    // 3 - высота скролинга
    contentHeight_ = kRowCount*kRowHeight;
	if ((self = [super initWithColor:ccc4(0,0,0,50) width:size.width  height:contentHeight_]))
	{
        // 4 - задействуем BatchNode
        spriteBatch = [CCSpriteBatchNode batchNodeWithFile:@"ShopArt.pvr.ccz"];
        [self addChild:spriteBatch z:1];
        
        // 5 - устанавливаем набор параметров
        self.touchEnabled = YES;
		touched = NO;                // скроллинг не начинал движение
		isDragging = NO;             // помечаем процесс движения пальца по скроллингу не начался. Кнопку "купить" можно нажать
        isOverSize = NO;             // скроллинг не вышел за пределы своего допустимого положения
        float bottom = top;

        // 6 - определяем позицию скролинга
        scrollWindowRect_ = CGRectMake(0, bottom, size.width, size.height - top);
        self.anchorPoint = ccp (0,0);
        self.position = ccp(0, (0 - contentHeight_ + scrollWindowRect_.size.height));
        
        // 7 - размещаем меню
        CCLabelBMFont *itemTmp = [CCLabelBMFont labelWithString: @"КУПИТЬ" fntFile:@"ShopFont.fnt" ];
        kPadding = kRowHeight-2*itemTmp.boundingBox.size.height;
        float w = itemTmp.boundingBox.size.width;
        
        // 8 - объявление меню
        CCMenu *itemMenu = [CCMenu menuWithItems:nil];
        for (int i=1; i<=kRowCount; i++ ) {
            
            NSString *fileName, *descript;
            int idObj, price, maxQuantity;
            
            switch (i) {
                case 1: fileName=@"helmet.png";   descript=NSLocalizedString(@"helmetDescription", "@");   idObj=1; price=50;   maxQuantity=1; break;
                case 2: fileName=@"bombaRed.png"; descript=NSLocalizedString(@"bombDescription", "@");     idObj=2; price=150;  maxQuantity=1; break;
                case 3: fileName=@"bullet2x.png"; descript=NSLocalizedString(@"2XSpeedDescription", "@");  idObj=3; price=100;  maxQuantity=1; break;
                case 4: fileName=@"clock.png";    descript=NSLocalizedString(@"timeStopDescription", "@"); idObj=4; price=110;  maxQuantity=1; break;
                case 5: fileName=@"Gun2.png";     descript=NSLocalizedString(@"gunRoketDescription", "@"); idObj=5; price=1000; maxQuantity=1; break;
                case 6: fileName=@"Gun3.png";     descript=NSLocalizedString(@"gun3Description", "@");     idObj=6; price=2000; maxQuantity=1; break;
                case 7: fileName=@"Gun4.png";     descript=NSLocalizedString(@"gun4Description", "@");     idObj=7; price=2000; maxQuantity=1; break;
                case 8: fileName=@"Gun5.png";     descript=NSLocalizedString(@"gun5Description", "@");     idObj=8; price=2000; maxQuantity=1; break;
                    
            }
            
            CCLabelBMFont *itemLabel = [CCLabelBMFont labelWithString: @"КУПИТЬ" fntFile:@"ShopFont.fnt" ];
            ShopMenuItemLabel *item = [ShopMenuItemLabel itemWithLabel :itemLabel target:self selector:@selector(selectMenuItem:) ];
            item.num = i;
            item.tag = idObj;
            item.price = price;
            item.maxQuantity = maxQuantity;
            // 10 - задали размер кнопке "Купить"
            [item setContentSize:CGSizeMake(w, (kRowHeight-kPadding))];
            item.anchorPoint = ccp(0.0,0.5);
            [itemMenu addChild:item];
            
            // 13- описание покупки
            CCLabelBMFont *desc = [CCLabelBMFont labelWithString: descript fntFile:@"shop.fnt" width:210*kPad alignment:kCCTextAlignmentLeft];
            desc.anchorPoint = ccp(0.0, 0.5);
            [desc setPosition:ccp(size.width*0.33, (kRowCount-i+0.7)*kRowHeight) ];
            [self addChild:desc];
            
            // 14 - символ монетки
            CCSprite *coin = [CCSprite spriteWithSpriteFrameName:@"controlMoney.png"];
            [coin setPosition:ccp(size.width*0.61, (kRowCount-i+0.5)*kRowHeight-30*kPad) ]; 
            //[coin setScale:3];
            [self addChild:coin];
            
            // 14 - цена
            CCLabelBMFont *pr = [CCLabelBMFont labelWithString: [NSString stringWithFormat:@"%d",price] fntFile:@"ShopFont.fnt" ];
            [pr setPosition:ccp(size.width*0.45, (kRowCount-i+0.5)*kRowHeight-30*kPad )]; 
            [self addChild:pr];
            
            // 12 - картинку покупки отражаем в кружочке
            CCSprite *sp1 = [CCSprite spriteWithSpriteFrameName:@"roundBig.png"]; 
            [sp1 setPosition:ccp(size.width*0.16, (kRowCount-i+0.5)*kRowHeight) ];  
            [spriteBatch addChild:sp1];
            
            // 12 - картинка покупки
            CCSprite *sp2 = [CCSprite spriteWithSpriteFrameName:fileName];
            [sp2 setPosition:ccp(sp1.boundingBox.size.width/2,sp1.boundingBox.size.height/2) ];
            [sp1 addChild:sp2];
            
            // полоска разделитель
            // полоса-разделитель между покупками (товарами)
            if (i<=kRowCount) {
                CCSprite *desk1 = [CCSprite spriteWithSpriteFrameName:@"separator.png"];
                desk1.position = ccp(size.width/2,i*kRowHeight);
                desk1.anchorPoint = ccp(0.5,0.5);
                [spriteBatch addChild:desk1 z:1];
            }
            
        }
        
        // завершающий разделитель
        CCSprite *desk1 = [CCSprite spriteWithSpriteFrameName:@"separator.png"];
        desk1.position = ccp(size.width/2,0*kRowHeight);
        [spriteBatch addChild:desk1 z:1];
        
        // 9 - упорядочение кнопок внутри меню 
        [itemMenu alignItemsVerticallyWithPadding:kPadding];
        [itemMenu setPosition:ccp(size.width*0.68, contentHeight_ /2.0-16*kPad)]; //
        [itemMenu setIsTouchEnabled:NO];
        [self addChild:itemMenu z:1 tag:kMenu];
        
   
    }
	return self;    
}


- (void) dealloc {
    
	[super dealloc];
}

- (void) selectMenuItem:(ShopMenuItemLabel*)item {
   int tt = item.tag;
    
    NSLog(@"Покупка %i, price = % i ", tt, item.price);
    
    int t=0; // допустимое количество покупок еще - переменная определяется логикой вашей программы, условно присваиваю 0
    
    if (t==0) {  // последняя покупка, кнопка купить блокируется
        [item runAction: [CCSequence actions:
                      [CCDelayTime actionWithDuration:0.2],
                      [CCCallFuncN actionWithTarget:self selector:@selector(itemDisable:)],  
                      nil  ]];
    
    } else {  // кнопка купить возвращается в исходное состояние
        [item runAction: [CCSequence actions:
                      [CCDelayTime actionWithDuration:0.2],
                      [CCCallFuncN actionWithTarget:item selector:@selector(unselected)],
                      nil  ]];
    }
    
}


- (void) itemDisable:(id) sender
{
    CCMenuItemLabel* item = sender;
    [item unselected];
    item.isEnabled = NO;

}

- (void) scrollMenu: (float) velocity {
	
    float sizeH = [[CCDirector sharedDirector] winSize].height  ;
    float moveMenuBy = 0.0;

    if (accumulatedYDifference < -SPIN_TRIGGER_THRESHOLD) {
		moveMenuBy = accumulatedYDifference;
		accumulatedYDifference = 0;
	} else if (accumulatedYDifference > SPIN_TRIGGER_THRESHOLD) {
		moveMenuBy = accumulatedYDifference;
		accumulatedYDifference = 0;
	}
    
    CCAction *moveAction;
    float xTime = 0.0f;
    
    // обрабатываем быстрое движение
    if (velocity>maxVelocity) {velocity = maxVelocity;};
    if (ABS(velocity)>kVelosity ) {
        // максимум 3(или4) листа
        moveMenuBy= sizeH*5*velocity/maxVelocity ;
        xTime = 1.2f;
    };
    

	if (moveMenuBy != 0.0) {  // перемещение есть
		
		CGPoint nowPosition = self.position;
		float nextPositionY = self.position.y + moveMenuBy;

        // нашли новую позицию
        float maxPos = scrollWindowRect_.origin.y;
        float minPos = -contentHeight_ + scrollWindowRect_.size.height;
        
        // вышли за пределы допустимой области 
        if ((nextPositionY > maxPos) || (nextPositionY<minPos)) {
            isOverSize = YES;
            
            if (velocity!=0) {
                // свап
                // скроллинг отодвигается не более чем на четверть экрана за пределы допустимой области
                nextPositionY = MIN(maxPos+sizeH/4,  MAX(minPos-sizeH/4, nextPositionY));  
                nowPosition.y = nextPositionY;
                xTime = 0.2f;
            } else {
                // если вышли за пределы допустимой области нужно уменьшить перемещение за пальцем
                nowPosition.y += moveMenuBy/4;  
            };
            
            
            if (xTime == 0.0) {  
                moveAction = [CCPlace actionWithPosition:nowPosition];}
            else {
                moveAction = [CCSequence actions: [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:xTime position: nowPosition] rate:3.0f] ,
                              [CCCallFunc actionWithTarget:self selector:@selector(scrollMenuEnd)],nil];
                              };
		} else {
			isOverSize = NO;
            nowPosition.y += moveMenuBy;
            if (xTime == 0.0) {
                moveAction = [CCPlace actionWithPosition:nowPosition];}
            else {
                moveAction = [CCSequence actions: [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:xTime position: nowPosition] rate:3.0f], 
                              [CCCallFunc actionWithTarget:self selector:@selector(scrollMenuEnd)],nil];
            };
		}
        moveAction.tag = tMove;
        [self runAction: moveAction];
	}
}

// после окончания движения надо проверить, что область скроллинга не вышла за пределы, если вышла поставить ее обратно
- (void) scrollMenuEnd
{
	
        CGPoint nowPosition = self.position;
        nowPosition.y = MAX( (0 - contentHeight_ + scrollWindowRect_.size.height), nowPosition.y );
        nowPosition.y = MIN( scrollWindowRect_.origin.y, nowPosition.y );
		
        isOverSize = NO;
        [self runAction: [CCMoveTo actionWithDuration:0.1f position:nowPosition]];
         
}



#pragma mark Touch Methods

- (void) ccTouchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
    
    // в начале движения пальцем мы фиксируем время и позицию пальца
    // фиксировать время нам приходится, чтобы отследить и обработать быстрые движения,
    // при которых скроллинг должен продолжать прокручиваться, когда палец уже не двигается по экрану
    
    UITouch *touch = [touches anyObject];
    touchStart  = touch.timestamp;  // 1- запомнили время начала движения для проверки быстрых жестов

    [self stopActionByTag:tMove];
    
	CGPoint b = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    touchStartY = b.y;              // 2- запомнили координату Y 
    
	if (CGRectContainsPoint(scrollWindowRect_, b)) {
		touched = YES;
	};
    
}

- (void) ccTouchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
	   
    if ((touched == NO) || (contentHeight_ < scrollWindowRect_.size.height)) {
		// прокрутку не запускали и не обрабатываем
        return;
	}
    
    // при плавном движении скроллинг двигается за пальцем
    // но если перемещение очень маленькое, то оно аккумулируется в переменной accumulatedYDifference,
    // и перемещение скроллинга произойдет только когда accumulatedYDifference превысит определенный порог
	UITouch *touch = [touches anyObject];
	CGPoint a = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:touch.view]];
	CGPoint b = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    
	float diff = (b.y - a.y);
	accumulatedYDifference += diff;
	if (abs(diff) > SPIN_TRIGGER_THRESHOLD) {
        accumulatedYDifference = diff;
        [self scrollMenu: 0]; // передача нулевой велосити означает, что скроллинг двигается точно за пальцем
		isDragging = YES;
	}
    
}


- (void) ccTouchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
{

    
    UITouch *touch = [touches anyObject];
	

	CGPoint b = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
	float diff1 = (b.y - touchStartY);
    float velocity = diff1/(event.timestamp-touchStart);

    // 1 - проверяем было ли быстрое движение пальцем
    if (abs(velocity) >kVelosity) {
        [self scrollMenu: velocity ];
    } else {
        // 2 -после окончания движения надо проверить, что область скроллинга не вышла за пределы, если вышла поставить ее обратно
        if (isOverSize == YES) { [self scrollMenuEnd] ;};
    };
    
    // 3 - проверяем была ли нажата кнопка меню
	if (touched) {
		UITouch *touch = [touches anyObject];
		
		if ((isDragging == NO) && ([touch tapCount] == 1)) {
			// We tapped instead of swiping or dragging.  Give the event to the menu.
            CCMenu *itemMenu = (CCMenu*)[self getChildByTag:kMenu];
			CCMenuItem* item = [itemMenu itemForTouch:touch];
			if (item != nil) {
                [item activate];
                [item selected];
			}
		}
	}
	
	touched = NO;
	isDragging = NO;

}


@end








