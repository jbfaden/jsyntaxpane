/**
 * XML Simple Syntax by Ayman Al-Sairafi
 */

package jsyntaxpane.lexers;

import jsyntaxpane.Lexer;
import jsyntaxpane.Token;
import jsyntaxpane.TokenType;

%%

%public
%class XmlLexer
%implements Lexer
%final
%unicode
%char
%type Token

%{
    /**
     * Create an empty lexer, yyrset will be called later to reset and assign
     * the reader
     */
    public XmlLexer() {
        super();
    }

    private Token token(TokenType type) {
        return new Token(type, yychar, yylength());
    }

    public static String[] LANGS = new String[] {"xml"};

%}

/* main character classes */

/* comments */
Comment = "<!--" [^--] ~"-->" | "<!--" "-"+ "->"

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace = {LineTerminator} | [ \t\f]+


LetterDigit = [a-zA-Z0-9_]

/*
TagStart = [<>] 
TagEnd = "</" | ">" | "/>"
Tag = {TagStart} | {TagEnd}
Tag = [<>/]
*/

DocType = "<?xml" [^?]* "?>"

/* Tag Delimiters */
TagStart = "<" {LetterDigit}+
TagEnd = ("</" {LetterDigit}+ ">") | "/>" | ">"
Tag = {TagStart} | {TagEnd}

/* attribute */
Attribute = {LetterDigit}+ "="


/* string and character literals */
StringCharacter = [^\r\n\"\\]

%%

<YYINITIAL> {
  \"{StringCharacter}+\"         { return token(TokenType.STRING); }
  
  {Comment}                      { return token(TokenType.COMMENT); }

  {Tag}                          { return token(TokenType.OPER); }

  {Attribute}                    { return token(TokenType.IDENT); }

  {DocType}                      { return token(TokenType.KEYWORD); }

  {LetterDigit}+                 { return token(TokenType.IDENT); }

  {WhiteSpace}+                  { /* skip */ }
}


/* error fallback */
.|\n                             {  }
<<EOF>>                          { return null; }
