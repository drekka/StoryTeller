#import "STLogExpressionParser.h"
#import <PEGKit/PEGKit.h>
    
#pragma GCC diagnostic ignored "-Wundeclared-selector"


@interface STLogExpressionParser ()

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *loggerExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *classIdentifier_memo;
@property (nonatomic, retain) NSMutableDictionary *keyPath_memo;
@property (nonatomic, retain) NSMutableDictionary *property_memo;
@property (nonatomic, retain) NSMutableDictionary *protocol_memo;
@property (nonatomic, retain) NSMutableDictionary *class_memo;
@property (nonatomic, retain) NSMutableDictionary *id_memo;
@property (nonatomic, retain) NSMutableDictionary *bool_memo;
@property (nonatomic, retain) NSMutableDictionary *literal_memo;
@property (nonatomic, retain) NSMutableDictionary *op_memo;
@property (nonatomic, retain) NSMutableDictionary *lt_memo;
@property (nonatomic, retain) NSMutableDictionary *gt_memo;
@property (nonatomic, retain) NSMutableDictionary *eq_memo;
@property (nonatomic, retain) NSMutableDictionary *ne_memo;
@property (nonatomic, retain) NSMutableDictionary *le_memo;
@property (nonatomic, retain) NSMutableDictionary *ge_memo;
@property (nonatomic, retain) NSMutableDictionary *yes_memo;
@property (nonatomic, retain) NSMutableDictionary *no_memo;
@property (nonatomic, retain) NSMutableDictionary *true_memo;
@property (nonatomic, retain) NSMutableDictionary *false_memo;
@property (nonatomic, retain) NSMutableDictionary *dot_memo;
@end

@implementation STLogExpressionParser { }

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";
        self.tokenKindTab[@"false"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE);
        self.tokenKindTab[@">="] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_GE);
        self.tokenKindTab[@"<"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"<="] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_LE);
        self.tokenKindTab[@"true"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"["] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@"="] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ);
        self.tokenKindTab[@"."] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_DOT);
        self.tokenKindTab[@">"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"]"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"no"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_NO);
        self.tokenKindTab[@"yes"] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_YES);
        self.tokenKindTab[@"!="] = @(STLOGEXPRESSIONPARSER_TOKEN_KIND_NE);

        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ] = @"=";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_NO] = @"no";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_YES] = @"yes";
        self.tokenKindNameTab[STLOGEXPRESSIONPARSER_TOKEN_KIND_NE] = @"!=";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.loggerExpr_memo = [NSMutableDictionary dictionary];
        self.classIdentifier_memo = [NSMutableDictionary dictionary];
        self.keyPath_memo = [NSMutableDictionary dictionary];
        self.property_memo = [NSMutableDictionary dictionary];
        self.protocol_memo = [NSMutableDictionary dictionary];
        self.class_memo = [NSMutableDictionary dictionary];
        self.id_memo = [NSMutableDictionary dictionary];
        self.bool_memo = [NSMutableDictionary dictionary];
        self.literal_memo = [NSMutableDictionary dictionary];
        self.op_memo = [NSMutableDictionary dictionary];
        self.lt_memo = [NSMutableDictionary dictionary];
        self.gt_memo = [NSMutableDictionary dictionary];
        self.eq_memo = [NSMutableDictionary dictionary];
        self.ne_memo = [NSMutableDictionary dictionary];
        self.le_memo = [NSMutableDictionary dictionary];
        self.ge_memo = [NSMutableDictionary dictionary];
        self.yes_memo = [NSMutableDictionary dictionary];
        self.no_memo = [NSMutableDictionary dictionary];
        self.true_memo = [NSMutableDictionary dictionary];
        self.false_memo = [NSMutableDictionary dictionary];
        self.dot_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearMemo {
    [_expr_memo removeAllObjects];
    [_loggerExpr_memo removeAllObjects];
    [_classIdentifier_memo removeAllObjects];
    [_keyPath_memo removeAllObjects];
    [_property_memo removeAllObjects];
    [_protocol_memo removeAllObjects];
    [_class_memo removeAllObjects];
    [_id_memo removeAllObjects];
    [_bool_memo removeAllObjects];
    [_literal_memo removeAllObjects];
    [_op_memo removeAllObjects];
    [_lt_memo removeAllObjects];
    [_gt_memo removeAllObjects];
    [_eq_memo removeAllObjects];
    [_ne_memo removeAllObjects];
    [_le_memo removeAllObjects];
    [_ge_memo removeAllObjects];
    [_yes_memo removeAllObjects];
    [_no_memo removeAllObjects];
    [_true_memo removeAllObjects];
    [_false_memo removeAllObjects];
    [_dot_memo removeAllObjects];
}

- (void)start {

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)__expr {
    
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];

    }];
    [self loggerExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__loggerExpr {
    
    [self classIdentifier_]; 
    [self keyPath_]; 
    [self op_]; 
    [self literal_]; 

    [self fireDelegateSelector:@selector(parser:didMatchLoggerExpr:)];
}

- (void)loggerExpr_ {
    [self parseRule:@selector(__loggerExpr) withMemo:_loggerExpr_memo];
}

- (void)__classIdentifier {
    
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self class_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM, 0]) {
        [self protocol_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'classIdentifier'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchClassIdentifier:)];
}

- (void)classIdentifier_ {
    [self parseRule:@selector(__classIdentifier) withMemo:_classIdentifier_memo];
}

- (void)__keyPath {
    
    do {
        [self property_]; 
    } while ([self speculate:^{ [self property_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchKeyPath:)];
}

- (void)keyPath_ {
    [self parseRule:@selector(__keyPath) withMemo:_keyPath_memo];
}

- (void)__property {
    
    [self dot_]; 
    [self id_]; 

    [self fireDelegateSelector:@selector(parser:didMatchProperty:)];
}

- (void)property_ {
    [self parseRule:@selector(__property) withMemo:_property_memo];
}

- (void)__protocol {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM discard:YES]; 
    [self id_]; 
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchProtocol:)];
}

- (void)protocol_ {
    [self parseRule:@selector(__protocol) withMemo:_protocol_memo];
}

- (void)__class {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self id_]; 
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchClass:)];
}

- (void)class_ {
    [self parseRule:@selector(__class) withMemo:_class_memo];
}

- (void)__id {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchId:)];
}

- (void)id_ {
    [self parseRule:@selector(__id) withMemo:_id_memo];
}

- (void)__bool {
    
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_YES, 0]) {
        [self yes_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_NO, 0]) {
        [self no_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE, 0]) {
        [self true_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE, 0]) {
        [self false_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)bool_ {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

- (void)__literal {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE, STLOGEXPRESSIONPARSER_TOKEN_KIND_NO, STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE, STLOGEXPRESSIONPARSER_TOKEN_KIND_YES, 0]) {
        [self bool_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)literal_ {
    [self parseRule:@selector(__literal) withMemo:_literal_memo];
}

- (void)__op {
    
    if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM, 0]) {
        [self lt_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM, 0]) {
        [self gt_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ, 0]) {
        [self eq_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_NE, 0]) {
        [self ne_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_LE, 0]) {
        [self le_]; 
    } else if ([self predicts:STLOGEXPRESSIONPARSER_TOKEN_KIND_GE, 0]) {
        [self ge_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'op'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOp:)];
}

- (void)op_ {
    [self parseRule:@selector(__op) withMemo:_op_memo];
}

- (void)__lt {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)lt_ {
    [self parseRule:@selector(__lt) withMemo:_lt_memo];
}

- (void)__gt {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)gt_ {
    [self parseRule:@selector(__gt) withMemo:_gt_memo];
}

- (void)__eq {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)eq_ {
    [self parseRule:@selector(__eq) withMemo:_eq_memo];
}

- (void)__ne {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_NE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNe:)];
}

- (void)ne_ {
    [self parseRule:@selector(__ne) withMemo:_ne_memo];
}

- (void)__le {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_LE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLe:)];
}

- (void)le_ {
    [self parseRule:@selector(__le) withMemo:_le_memo];
}

- (void)__ge {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_GE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGe:)];
}

- (void)ge_ {
    [self parseRule:@selector(__ge) withMemo:_ge_memo];
}

- (void)__yes {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_YES discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchYes:)];
}

- (void)yes_ {
    [self parseRule:@selector(__yes) withMemo:_yes_memo];
}

- (void)__no {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_NO discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNo:)];
}

- (void)no_ {
    [self parseRule:@selector(__no) withMemo:_no_memo];
}

- (void)__true {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)true_ {
    [self parseRule:@selector(__true) withMemo:_true_memo];
}

- (void)__false {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)false_ {
    [self parseRule:@selector(__false) withMemo:_false_memo];
}

- (void)__dot {
    
    [self match:STLOGEXPRESSIONPARSER_TOKEN_KIND_DOT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDot:)];
}

- (void)dot_ {
    [self parseRule:@selector(__dot) withMemo:_dot_memo];
}

@end