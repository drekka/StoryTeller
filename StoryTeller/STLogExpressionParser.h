#import <PEGKit/PKParser.h>

enum {
    STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE = 14,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_GE = 15,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_LOGROOT = 16,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_IS = 17,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ = 18,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM = 19,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET = 20,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE = 21,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_NIL = 22,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_LOGALL = 23,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_DOT = 24,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM = 25,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_CLOSE_BRACKET = 26,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_LE = 27,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER = 28,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_NE = 29,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER = 30,
};

@interface STLogExpressionParser : PKParser

@end

