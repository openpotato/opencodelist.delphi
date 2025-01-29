{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Column;

interface

uses
  System.JSON,
  System.SysUtils,
  OpenCodeList.Nullable,
  OpenCodeList.BaseObjects;

type

  /// <summary>
  /// A code list column.
  /// </summary>
  TColumn = class abstract(TIdentifiableObject)
  private
    FDescription: Nullable<string>;
    FName: string;
    FNullable: Nullable<Boolean>;
    FOptional: Nullable<Boolean>;
  public

    /// <summary>
    /// A human-readable description of the code list column.
    /// </summary>
    property Description: Nullable<string> read FDescription write FDescription;

    /// <summary>
    /// The name of the code list column.
    /// </summary>
    property Name: string read FName write FName;

    /// <summary>
    /// Specifies whether the column value can be `null`.
    /// </summary>
    property Nullable: Nullable<Boolean> read FNullable write FNullable;

    /// <summary>
    /// Defines whether this column is optional, i.e., whether it can be
    /// completely omitted from a data row.
    /// </summary>
    property Optional: Nullable<Boolean> read FOptional write FOptional;

  end;

implementation

end.

