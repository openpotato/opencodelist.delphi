{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Rows;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.ObjectList,
  OpenCodeList.Column,
  OpenCodeList.Row;

type

  /// <summary>
  /// The Row definitions of a code list.
  /// </summary>
  TRows = class(TExtendedObjectList<TRow>)
  private
    FDocument: TObject;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="TRows" />
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    constructor Create(Document: TObject; AOwnsObjects: Boolean = true);

    /// <summary>
    /// Parses a <see cref="TJSONArray"/> array into a new <see cref="TRow"/> instances
    /// and adds them to the internal collection.
    /// </summary>
    /// <param name="JsonArrayToBeParsed">The json array</param>
    procedure ParseAndAdd(JsonArrayToBeParsed: TJSONArray);

    /// <summary>
    /// Removes all values with reference to a given column
    /// </summary>
    /// <param name="ColumnId">The column Id</param>
    procedure RemoveValues(const ColumnId: string); overload;

    /// <summary>
    /// Removes all values with reference to a given column
    /// </summary>
    /// <param name="Column">The column</param>
    procedure RemoveValues(Column: TColumn); overload;

  end;

implementation

uses
  OpenCodeList.CodeListDocument,
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TRows }

constructor TRows.Create(Document: TObject; AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
  FDocument := Document;
end;

procedure TRows.ParseAndAdd(JsonArrayToBeParsed: TJSONArray);
begin
  for var JsonValue in JsonArrayToBeParsed do
  begin
    if JsonValue is TJSONObject then
    begin
      Add(TRow.Parse(FDocument, JsonValue as TJSONObject))
    end
  end;
end;

procedure TRows.RemoveValues(const ColumnId: string);
begin
  for var Row in Self do
  begin
    Row.RemoveValue(ColumnId);
  end;
end;

procedure TRows.RemoveValues(Column: TColumn);
begin
  RemoveValues(Column.Id);
end;

end.

