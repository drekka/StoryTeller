#import <PEGKit/PKParser.h>

enum {
    STLOGEXPRESSIONPARSER_TOKEN_KIND_FALSE = 14,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_GE = 15,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_EQ = 16,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_LT_SYM = 17,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_LE = 18,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_OPEN_BRACKET = 19,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_TRUE = 20,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_DOT = 21,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_GT_SYM = 22,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_CLOSE_BRACKET = 23,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_YES_UPPER = 24,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_NE = 25,
    STLOGEXPRESSIONPARSER_TOKEN_KIND_NO_UPPER = 26,
};

@interface STLogExpressionParser : PKParser

@end

