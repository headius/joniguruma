require 'jruby'

module Oniguruma
  class ORegexp < Regexp
    def gsub(str, replacement = nil, &block)
      replacement ? str.gsub(self, replacement) : str.gsub(self, &block)
    end
    
    def gsub!(str, replacement = nil, &block)
      replacement ? str.gsub!(self, replacement) : str.gsub!(self, &block)
    end
    
    def sub(str, replacement = nil, &block)
      replacement ? str.sub(self, replacement) : str.sub(self, &block)
    end

    def sub!(str, replacement = nil, &block)
      replacement ? str.sub!(self, replacement) : str.sub!(self, &block)
    end
  end
end

class String
  alias :ogsub :gsub
  alias :ogsub! :gsub!
  alias :osub :sub
  alias :osub! :sub!
end

class MatchData
  alias :_aref :[]
  private :_aref
  def [](*args)
    raise ArgumentError if args.size == 0
    case args[0]
    when Fixnum, Range
      _aref(*args)
    else
      index = to_index(args[0])
      index ? _aref(index) : nil
    end
  end
  
  alias :_end :end
  private :_end
  def end(name_or_sym = nil)
    name_or_sym ? _end(_backref_number(name_or_sym)) : _end(0)
  end
  
  alias :_begin :begin
  private :_begin
  def begin(name_or_sym = nil)
    name_or_sym ? _begin(_backref_number(name_or_sym)) : _begin(0)
  end
  
  alias :_offset :offset
  private :_offset
  def offset(name_or_sym = nil)
    name_or_sym ? _offset(_backref_number(name_or_sym)) : _offset(0)
  end
    
  def to_index(name)
    begin
      _backref_number(name)
    rescue IndexError
      nil
    end
  end
  
  def _backref_number(name)
    _reference.backref_number(JRuby.reference(name))
  end
  private :_backref_number
  
  def _reference
    @reference ||= JRuby.reference(self)
  end
  private :_reference
end

# constants; noisy, so I put them down here
module Oniguruma
  VERSION                     = "5.9.1"
  
  OPTION_NONE                 = 0
  OPTION_IGNORECASE           = 1
  OPTION_EXTEND               = (OPTION_IGNORECASE         << 1)
  OPTION_MULTILINE            = (OPTION_EXTEND             << 1)
  OPTION_SINGLELINE           = (OPTION_MULTILINE          << 1)
  OPTION_FIND_LONGEST         = (OPTION_SINGLELINE         << 1)
  OPTION_FIND_NOT_EMPTY       = (OPTION_FIND_LONGEST       << 1)
  OPTION_NEGATE_SINGLELINE    = (OPTION_FIND_NOT_EMPTY     << 1)
  OPTION_DONT_CAPTURE_GROUP   = (OPTION_NEGATE_SINGLELINE  << 1)
  OPTION_CAPTURE_GROUP        = (OPTION_DONT_CAPTURE_GROUP << 1)
  OPTION_NOTBOL               = (OPTION_CAPTURE_GROUP << 1)
  OPTION_NOTEOL               = (OPTION_NOTBOL << 1)
  OPTION_POSIX_REGION         = (OPTION_NOTEOL << 1)
  OPTION_MAXBIT               = OPTION_POSIX_REGION
  OPTION_DEFAULT              = OPTION_NONE

  OPTIONS_SHORTCUTS = {
   'i' => OPTION_IGNORECASE,
   'x' => OPTION_EXTEND,
   'm' => OPTION_MULTILINE,
   's' => OPTION_SINGLELINE,
   'l' => OPTION_FIND_LONGEST,
   'E' => OPTION_FIND_NOT_EMPTY,
   'S' => OPTION_NEGATE_SINGLELINE,
   'G' => OPTION_DONT_CAPTURE_GROUP,
   'g' => OPTION_CAPTURE_GROUP,
   'B' => OPTION_NOTBOL,
   'E' => OPTION_NOTEOL,
  }

  SYNTAX_ASIS                 = 0
  SYNTAX_POSIX_BASIC          = 1
  SYNTAX_POSIX_EXTENDED       = 2
  SYNTAX_EMACS                = 3
  SYNTAX_GREP                 = 4
  SYNTAX_GNU_REGEX            = 5
  SYNTAX_JAVA                 = 6
  SYNTAX_PERL                 = 7
  SYNTAX_PERL_NG              = 8
  SYNTAX_RUBY                 = 9
  SYNTAX_DEFAULT              = 10

  ENCODING_ASCII              = 0
  ENCODING_ISO_8859_1         = 1
  ENCODING_ISO_8859_2         = 2
  ENCODING_ISO_8859_3         = 3
  ENCODING_ISO_8859_4         = 4
  ENCODING_ISO_8859_5         = 5
  ENCODING_ISO_8859_6         = 6
  ENCODING_ISO_8859_7         = 7
  ENCODING_ISO_8859_8         = 8
  ENCODING_ISO_8859_9         = 9
  ENCODING_ISO_8859_10        = 10
  ENCODING_ISO_8859_11        = 11
  ENCODING_ISO_8859_12        = 12
  ENCODING_ISO_8859_13        = 13
  ENCODING_ISO_8859_14        = 14
  ENCODING_ISO_8859_15        = 15
  ENCODING_ISO_8859_16        = 16
  ENCODING_UTF8               = 17
  ENCODING_UTF16_BE           = 18
  ENCODING_UTF16_LE           = 19
  ENCODING_UTF32_BE           = 20
  ENCODING_UTF32_LE           = 21
  ENCODING_EUC_JP             = 22
  ENCODING_EUC_TW             = 23
  ENCODING_EUC_KR             = 24
  ENCODING_EUC_CN             = 25
  ENCODING_SJIS               = 26
  ENCODING_KOI8               = 27
  ENCODING_KOI8_R             = 28
  ENCODING_CP1251             = 29
  ENCODING_BIG5               = 30
  ENCODING_GB18030            = 31
  ENCODING_UNDEF              = 32
end