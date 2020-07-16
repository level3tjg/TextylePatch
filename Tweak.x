#import <substrate.h>
#import <substitute.h>
#import <mach-o/dyld.h>
#import "fishhook/fishhook.h"

@interface UIKeyboardDockItem
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) UIButton *button;
@end

@interface UISystemKeyboardDockController : UIViewController
@end

int (*substitute_hook_functions_ptr)(const struct substitute_function_hook *hooks, size_t nhooks, struct substitute_function_hook_record **recordp, int options);

void HookFunction(const char *funcname, void *replacement, void **replaced){
	#if __arm64e__
		struct substitute_function_hook hook = {dlsym(RTLD_DEFAULT, funcname), replacement, replaced};
		substitute_hook_functions_ptr(&hook, 1, NULL, SUBSTITUTE_NO_THREAD_SAFETY);
	#else
		struct rebinding binding = {funcname, replacement, replaced};
		rebind_symbols(&binding, 1);
	#endif
}

Ivar (*orig_class_getInstanceVariable)(Class _class, const char *name);
Ivar hook_class_getInstanceVariable(Class _class, const char *name){
	return orig_class_getInstanceVariable(_class, "_subviewCache");
}

%hook NSArray
%new
-(UIColor *)backgroundColor{
	return [UIColor new];
}
%new
-(void)setBackgroundColor:(UIColor *)color{
	return;
}
%end

%hook UICalloutBarBackground
-(void)layoutSubviews{
	HookFunction("class_getInstanceVariable", (void *)hook_class_getInstanceVariable, (void **)&orig_class_getInstanceVariable);
	%orig;
	HookFunction("class_getInstanceVariable", (void *)orig_class_getInstanceVariable, NULL);
}
%end

%hook TXTDockItemButton
-(void)setImage:(UIImage *)image forState:(NSUInteger)state{
	%orig([UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Textyle.bundle/menuIcon.png"], state);
}
%end

%hook UISystemKeyboardDockController
-(void)loadView{
	%orig;
	UIView *dictationButton = ((UIKeyboardDockItem *)[self valueForKey:@"_dictationDockItem"]).button;
	UIView *globeButton = ((UIKeyboardDockItem *)[self valueForKey:@"_globeDockItem"]).button;
	CGRect newFrame = CGRectMake(dictationButton.frame.origin.x, globeButton.frame.origin.y, dictationButton.frame.size.width, dictationButton.frame.size.height);
	dictationButton.frame = newFrame;
}
%end

%ctor{
	dlopen("/Library/MobileSubstrate/DynamicLibraries/Textyle.dylib", RTLD_NOW);
	#if __arm64e__
	substitute_hook_functions_ptr = (int (*)(const struct
      substitute_function_hook *, size_t, struct substitute_function_hook_record
      **, int))dlsym(dlopen("/usr/lib/libsubstrate.dylib", 1), "substitute_hook_functions");
	#endif
}