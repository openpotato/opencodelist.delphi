{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.TypeConsts;

interface

type

  /// <summary>
  /// Type values for OpenCodeList document content
  /// </summary>
  TTypeConsts = class
  public
    const Boolean = 'boolean';
    const CodeListRef = 'codeListRef';
    const CodeListSetRef = 'codeListSetRef';
    const DateOnly = 'date';
    const DateTime = 'date-time';
    const Document = 'document';
    const Enum = 'enum';
    const EnumSet = 'enum-set';
    const Integer = 'integer';
    const Number = 'number';
    const &String = 'string';
    const TimeOnly = 'time';
  end;

implementation

end.


