#import "STLogExpressionParser.h"
#import <PEGKit/PEGKit.h>
    
#pragma GCC diagnostic ignored "-Wundeclared-selector"


@interface STLogExpressionParser ()

@end

@implementation STLogExpressionParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";
        self.tokenKindTab[@"false"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE);
        self.tokenKindTab[@">="] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_GE);
        self.tokenKindTab[@"=="] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ);
        self.tokenKindTab[@"<"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"<="] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_LE);
        self.tokenKindTab[@"["] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@"true"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"."] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_DOT);
        self.tokenKindTab[@"isa"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_ISA);
        self.tokenKindTab[@">"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"]"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"YES"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER);
        self.tokenKindTab[@"!="] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_NE);
        self.tokenKindTab[@"NO"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER);

        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ] = @"==";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_ISA] = @"isa";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER] = @"YES";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_NE] = @"!=";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER] = @"NO";

    }
    return self;
}

- (void)start {

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)expr_ {
    
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
    [t.symbolState add:@"isa"];
    [t.symbolState add:@"=="];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];

    }];
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM, STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self classExpr_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE, STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER, STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE, STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self value_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_ISA, 0]) {
        [self runtimeExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'expr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)classExpr_ {
    
    [self runtimeType_]; 
    if ([self speculate:^{ [self keyPath_]; [self op_]; [self value_]; }]) {
        [self keyPath_]; 
        [self op_]; 
        [self value_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchClassExpr:)];
}

- (void)runtimeExpr_ {
    
    [self isa_]; 
    [self runtimeType_]; 

    [self fireDelegateSelector:@selector(parser:didMatchRuntimeExpr:)];
}

- (void)runtimeType_ {
    
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self class_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM, 0]) {
        [self protocol_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'runtimeType'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRuntimeType:)];
}

- (void)keyPath_ {
    
    do {
        [self propertyPath_]; 
    } while ([self speculate:^{ [self propertyPath_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchKeyPath:)];
}

- (void)propertyPath_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_DOT discard:YES]; 
    [self propertyName_]; 

    [self fireDelegateSelector:@selector(parser:didMatchPropertyPath:)];
}

- (void)propertyName_ {
    
    [self testAndThrow:(id)^{ return islower([LS(1) characterAtIndex:0]); }]; 
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPropertyName:)];
}

- (void)protocol_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM discard:YES]; 
    [self objCId_]; 
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchProtocol:)];
}

- (void)class_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self objCId_]; 
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchClass:)];
}

- (void)objCId_ {
    
    [self testAndThrow:(id)^{ return isupper([LS(1) characterAtIndex:0]); }]; 
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchObjCId:)];
}

- (void)value_ {
    
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE, STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER, 0]) {
        [self booleanTrue_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE, STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER, 0]) {
        [self booleanFalse_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self number_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self string_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'value'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchValue:)];
}

- (void)string_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self matchWord:NO]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'string'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchString:)];
}

- (void)number_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNumber:)];
}

- (void)booleanTrue_ {
    
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER, 0]) {
        [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER discard:NO]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE, 0]) {
        [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'booleanTrue'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBooleanTrue:)];
}

- (void)booleanFalse_ {
    
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER, 0]) {
        [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER discard:NO]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE, 0]) {
        [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'booleanFalse'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBooleanFalse:)];
}

- (void)op_ {
    
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ, 0]) {
        [self eq_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_NE, 0]) {
        [self ne_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM, 0]) {
        [self lt_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM, 0]) {
        [self gt_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_LE, 0]) {
        [self le_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_GE, 0]) {
        [self ge_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'op'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOp:)];
}

- (void)lt_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)gt_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)eq_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)ne_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_NE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNe:)];
}

- (void)le_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_LE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLe:)];
}

- (void)ge_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_GE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGe:)];
}

- (void)isa_ {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_ISA discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIsa:)];
}

@end