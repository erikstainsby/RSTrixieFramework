//
//  RSCompoundRule.m
//  RSTrixiePluginFramework
//
//  Created by Erik Stainsby on 12-02-25.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixieRule.h"


/**
 *	This is the consolidated result of the constituent subclasses:
 *	RSTrixieRule wraps up all the instances of Action-, Reaction-, Condition-rules.
 *	This is the object which is presented in the table view.
 *	This is the object which provides the javascript which is inserted into the page.
 **/
@implementation RSTrixieRule

@synthesize action;
@synthesize reactions;
@synthesize filters;
@synthesize comment=_comment;
@dynamic script;

- (id)init
{
    self = [super init];
    if (self) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		action =		[[RSActionRule alloc] init];
        reactions =		[NSArray array];
		filters =		[NSArray array];
		_comment =		@"";
    }
    return self;
}

- (NSString *) description {
	NSString * desc = [NSString stringWithFormat:@"<%@ %p> { \n",[self className],self];
		
	desc = [desc stringByAppendingString:[action description]];
 	desc = [desc stringByAppendingString:@",\n"];
	for( RSReactionRule * r in reactions) 
	{
		desc = [desc stringByAppendingString:[r description]];
		desc = [desc stringByAppendingString:@",\n"];
	}
	for( RSFilterRule * r in filters) 
	{
		desc = [desc stringByAppendingString:[r description]];
		desc = [desc stringByAppendingString:@",\n"];
	}

	desc = [desc stringByAppendingFormat:@"'comment': \"%@\"\n",_comment]; 

	desc = [desc stringByAppendingString:@"}\n"];
	return desc;
}

- (NSString *) selector {
	return [action selector];
}
- (NSString *) event {
	return [action event];
}
- (BOOL) preventDefault {
	return [action preventDefault];
}
- (BOOL) stopBubbling {
	return  [action stopBubbling];
}


- (void) setScript:(NSString*) stringSource {
	_script = stringSource;
}

- (NSString *) script {
	
	if( [_script length] > 0 ) {
		return _script;
	}
	
	NSString * script = @"";
	script = [script stringByAppendingFormat:@"$('%@')",[action selector]];
	script = [script stringByAppendingFormat:@".bind('%@',function(event){ ",[action event]];
	script = [script stringByAppendingString:@"$(this)"];
	for(RSReactionRule * reaction in reactions) 
	{
		script = [script stringByAppendingFormat:@"%@",[reaction script]];
	}
	if([action preventDefault]) {
		script = [script stringByAppendingString:@".preventDefault()"];
	}
	if([action stopBubbling]) {
		script = [script stringByAppendingString:@".stopBubbling()"];
	}
	for(RSFilterRule * filter in filters) 
	{
		script = [script stringByAppendingFormat:@"%@",[filter script]];
	}
	script = [script stringByAppendingString:@"});"];
	
	return script;
}

- (NSString *) emitScript {
	
	NSString * script = [NSString stringWithString:@"/** RSTrixie inserted script **/\n"];
	
	if( [_comment length] > 0 ) {
		script = [script stringByAppendingFormat:@"/** %@ **/\n", _comment];
	}
	else {
		script = [script stringByAppendingFormat:@"/** Pro tip: Help yourself remember what you were trying to do by commenting your code when you create it. **/\n", _comment];
	}
	
	return [script stringByAppendingFormat:@"%@",[self script]];
}


- (id) valueForUndefinedKey:(NSString *) key {
	NSLog(@"%s- [%04d] Undefined key: %@", __PRETTY_FUNCTION__, __LINE__, key);
	return @"undefined";
}


@end
