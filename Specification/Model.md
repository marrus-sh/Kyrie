#  The KyrieScript Data Model  #

The following document gives an overview of the data model used by the
  KyrieScript engine.
The result of parsing a KyrieScript document is a KyrieScript State,
  as defined below.

##  Literal Types  ##

KyrieScript supports three main data types: Strings, Numbers, and
  Booleans.
These are collectively known as Literals.

Each KyrieScript Literal type is convertible to the others.
However, these conversions are rarely lossless.

###  Strings:

A KyrieScript **String** is a sequence of Unicode codepoints.
The String must be valid Unicode, must not contain control characters
  or noncharacters, and must not exceed 2<sup>32</sup>&minus;1
  codepoints in length.

There are no further requirements on the contents of a String.

The following algorithm describes the conversion of a String into a
  Number:

1.  If the first character in the String is `U+002D - HYPHEN-MINUS`,
      `U+2212 − MINUS SIGN`, `U+FE63 ﹣ SMALL HYPHEN-MINUS`, or
      `U+FF0D － FULLWIDTH HYPHEN-MINUS`, let `n` be `"negative"` and
      let `s` be the sequence of codepoints in the String which follow this first character.

    If the first character in the String is `U+002B + PLUS SIGN`,
      `U+FE62 ﹢ SMALL PLUS SIGN`, or `U+FF0B ＋ FULLWIDTH PLUS SIGN`,
      let `n` be `"positive"` and let `s` be the sequence of codepoints
      in the String which follow this first character.

    Otherwise, let `n` be `"positive"` and let `s` be the sequence of
      codepoints in the String.

2.  Remove all characters which are `White_Space` as defined by the
      Unicode Character Database from `s`.

3.  If `s` contains no characters (is empty), return zero.

4.  If there are any characters in `s` not in the range
      `U+0030..U+0039` or `U+FF10..U+FF19`, return _**nonintegral**_.

5.  Let `i` be the result of interpreting `s` as a decimal number, with
      the one's digit in its last place, and treating the fullwidth
      characters in `U+FF10..U+FF19` as though they were their ASCII
      equivalents.

6.  If `i` is greater than 2<sup>31</sup>&minus;1, return
      _**nonintegral**_.

7.  If `n` is `"negative"`, return the product of `i` and -1.
    Otherwise, return `i`.

If a String is empty (contains zero characters), its Boolean
  representation is _**false**_.
Otherwise, its Boolean representation is _**true**_.

###  Numbers:

A KyrieScript **Number** represents a numeric value.
Only the integers in the range
  \[&minus;2<sup>31</sup>+1, 2<sup>31</sup>&minus;1] are valid
  KyrieScript Numbers.
In addition, the special Number _**nonintegral**_ indicates values
  which are not integers or otherwise not representable.

The String representation of integral Numbers is given by their decimal
  representation, using only the characters in the range
  `U+0030..U+0039`, with the one's digit in the final position, and
  prefixed with `U+2212 − MINUS SIGN` if the number is negative.
The String representation of _**nonintegral**_ is the empty string.

The Boolean representation of a Number is _**false**_ if it is zero,
  and _**true**_ otherwise.

###  Booleans:

A KyrieScript **boolean** is a Literal which is either _**true**_ or
  _**false**_.

The String representation of a Boolean is `"yes"` if it is _**true**_,
  and `"no"` if it is _**false**_.

The Number representation of a Boolean is one if it is _**true**_, and
  zero if it is _**false**_.

##  Lists  ##

A KyrieScript **List** is an ordered sequence of values, each of which
  may be either a Literal, or another List.
Lists must not be recursive, and must not have more than
  2<sup>31</sup>&minus;1 values.

Any Literal may be converted into a List by simply creating a List
  which contains only that value.

A List may be converted into a String by concatenating the String
  representations of each of its values, in order, with a single
  `U+0020 SPACE` character between each representation.
If this resulting sequence of characters is longer than
  2<sup>32</sup>&minus;1 codepoints in length, it must be truncated to
  2<sup>32</sup>&minus;1 codepoints by removing characters from the end
  of the string.

The Number representation of a List is the number of values directly
  contained in the List.

The Boolean representation of a List is _**false**_ if it contains no
  values, and _**true**_ otherwise.

##  Object Types  ##

The following **Objects** are all collections of **properties**.
Properties may point to other Objects, to Lists, or to Literals.
Each Object type provides its own restrictions on the values pointed to
  by its properties.

###  Identifiers:

A KyrieScript **Identifier** is used to identify an Object.
It is an Object with two properties:

+ The **name**, which must be a String
+ The **type**, which must be _**general**_, _**setting**_,
    _**character**_, _**moment**_, _**attribute**_, or _**command**_

Names must not *begin* with any of the following characters: `!.?@`.
Names must not *begin or end* with any Unicode character which has the
  property `White_Space`.
Names must not *end* with any of the following characters: `*+/~`
Names must not *contain* any of the following characters:
  ``%<=>[]`{|}``.

For Identifiers with a type of _**attribute**_, names furthermore must
  not *contain* any of the following characters: `()+,^~`.

For Identifiers with a type of _**command**_, only the following
  Strings are valid names:

+ `"CALL"`
+ `"DONE"`
+ `"EXIT"`
+ `"FMT:"`
+ `"GOTO"`
+ `"INIT"`
+ `"NULL"`
+ `"TAG:"`
+ `"WAIT"`

###  Variables:

A KyrieScript **Variable** associates an Identifier with a value.
It is an Object with two properties:

+ The **identifier**, which must be an Identifier
+ The **value**, which may be a Literal or List

If the type of the identifier is _**command**_, then:

+ If the name of the identifier is `"INIT"` or `"NULL"`, then the
    value must be a List with no values
+ If the name of the identifier is `"TAG:"`, then the value must be a
    String
+ If the name of the identifier is `"FMT:"`, then the value must be a
    List containing two or more Strings, and no other values
+ If the name of the identifier is `"CALL"` or `"GOTO"`, then the value
    must be a List containing one or more values, and the first value
    in this List must be a String which is a valid Identifier name
+ Otherwise, the value may be any Literal or List

###  Contexts:

A KyrieScript **Context** provides the context for a Block.
It is an Object with two properties:

+ The **identifier**, which must be of type _**setting**_ or
    _**character**_
+ The **attributes**, which must be an unordered sequence of
    Identifiers with type _**attribute**_

###  Conditions:

A KyrieScript **Condition** represents a comparison between the
  associated values of two Literals, Lists, or Identifiers.
It is an Object with three properties:

+ The **base**, which must be an Identifier whose type is *not*
    _**command**_, a List, or a Literal
+ The **operator**, which must be one of _**equal**_, _**not equal**_,
    _**less than**_, _**greater than**_, _**not less than**_, or
    _**not greater than**_
+ The **other**, which must be an Identifier whose type is *not*
    _**command**_, a List, or a Literal

###  Assignments:

A KyrieScript **Assignment** represents an assigment of a value to an
  Identifier.
It is an Object with four properties:

+ The **conditions**, which must be an unordered sequence of Conditions
+ The **destination**, which must be an Identifier whose type is *not*
    _**command**_
+ The **method**, which must be one of _**replacing**_, _**adding**_,
    _**subtracting**_, _**multiplying**_, _**dividing**_, or
    _**taking remainder**_
+ The **source**, which must be an Identifier whose type is *not*
    _**command**_, a List, or a literal value

###  Spans:

A KyrieScript **Span** represents a span of text.
It is an Object with four properties:

+ The **conditions**, which must be an unordered sequence of Conditions
+ The **body**, which must be a String
+ The **command**, which must be a Variable whose identifier has type
    _**command**_
+ The **standalone**, which must be a Boolean

###  Choices:

A KyrieScript **Choice** represents a choosable option.
It is an Object with three properties:

+ The **persistence**, which must be one of _**once-only**_,
    _**sticky**_, or _**fallthrough**_
+ The **span**, which must be a Span
+ The **freshness**, which must be a Boolean

###  Cycle:

A KyrieScript **Cycle** represents a collection of commands, only one
  of which is handled at a time.
It is an Object with four properties:

+ The **context**, which must be an Identifier with a type of
    _**setting**_ or _**character**_
+ The **commands**, which must be an *ordered* sequence of Variables
    whose identifiers have type _**command**_
+ The **mode**, which must be one of _**list**_, _**loop**_,
    _**only once**_, or _**random**_
+ The **nextPosition**, which must be a Number

If mode is _**random**_, the value of nextPosition must be zero.

###  Block:

A KyrieScript **Block** represents a block of text.
It is an Object with two properties:

+ The **context**, which must be an Identifier with a type of
    _**setting**_ or _**character**_
+ The **contents**, which must be an *ordered* sequence of any of the
    following, in any order:
  + Assignments
  + Choices
  + Cycles
  + Spans
  + Identifiers, which must not be of type _**command**_

###  Moments:

A KyrieScript **Moment** represents a callable position in the script.
It is an Object with three properties:

+ The **identifier**, which must be an Identifier with a type of
    _**moment**_
+ The **arguments**, which must be an unordered sequence of Identifiers
    with type _**general**_
+ The **blocks**, which must be an *ordered* sequence of Blocks

###  State:

A KyrieScript **State** represents the current state of the KyrieScript
  engine.
It is an Object with five properties:

+ The **characters**, which must be an unordered sequence of Contexts
    with identifiers of type _**character**_
+ The **moments**, which must be an *ordered* sequence of Moments
+ The **settings**, which must be an unordered sequence of Contexts
    with identifiers of type _**setting**_
+ The **variables**, which must be an unordered sequence of Variables
+ The **position**, which must be either a List with no values, or a
    List of exactly three Numbers

The position of a State represents the index of the next Moment,
  Block, and Object in the Block's contents, starting at zero.
A position with no values indicates a terminated script.
