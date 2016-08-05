%hook UIViewController
- (void)presentViewController:(UIAlertController *)arg1 animated:(BOOL)arg2 completion:(void (^)(void))arg3
{
	BOOL canShow = YES;
	NSLog(@"presentViewController() was called ------------------------------------------------");
	NSArray *array = [[arg1 title] componentsSeparatedByString:@" "];
	long arraylen = (long)[array count];
	NSLog(@"title length: %lu", arraylen);
	if(arraylen == 0){//check if the "dialog's" title is empty, dont continue
		%orig;
	}
	else{
		for(NSString* string in array)
		{
			if([[string lowercaseString] isEqualToString:@"rate"])
				canShow = NO;
		}
		array = [[arg1 message] componentsSeparatedByString:@" "];
		for(NSString* string in array)
		{
			if([[string lowercaseString] isEqualToString:@"rate"])
				canShow = NO;
		}
		if(canShow){
			%orig;
		}
		else{
			NSArray *actions = [arg1 actions];
			long actionslen = (long)[actions count];
			NSLog(@"actions length: %lu", actionslen);
			for(UIAlertAction* action in actions)
			{
				if([[[action title] lowercaseString] isEqualToString:@"cancel"]){
					NSLog(@"cancel found");
				}
			}
		}
	}
}
%end

%ctor
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	if([NSHomeDirectory() hasPrefix:@"/var/mobile/Containers/Data/Application/"])	// only hook App Store applications
	{
		%init;
	}
	[pool drain];
}
