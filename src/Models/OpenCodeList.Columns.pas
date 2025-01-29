{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Columns;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.Column,
  OpenCodeList.BooleanColumn,
  OpenCodeList.DateOnlyColumn,
  OpenCodeList.DateTimeColumn,
  OpenCodeList.EnumColumn,
  OpenCodeList.EnumSetColumn,
  OpenCodeList.IntegerColumn,
  OpenCodeList.JsonColumn,
  OpenCodeList.NumberColumn,
  OpenCodeList.ObjectList,
  OpenCodeList.StringColumn,
  OpenCodeList.TimeOnlyColumn;

type

  /// <summary>
  /// The column definitions of a code list.
  /// </summary>
  TColumns = class(TExtendedObjectList<TColumn>)
  private
    FDocument: TObject;
  protected
    procedure Notify(const Item: TColumn; Action: TCollectionNotification); override;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="TColumns" />
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    constructor Create(ADocument: TObject; AOwnsObjects: Boolean = true);

    /// <summary>
    /// Parses a <see cref="TJSONArray"/> array into a new <see cref="TColumn"/> instances
    /// and adds them to the internal collection.
    /// </summary>
    /// <param name="JsonArrayToBeParsed">The json array</param>
    procedure ParseAndAdd(JsonArrayToBeParsed: TJSONArray);

    /// <summary>
    /// Does a certain column exist?
    /// </summary>
    /// <param name="ID">The ID of the column</param>
    /// <returns>True, if found</returns>
    function Contains(const ID: string): Boolean; overload;

    /// <summary>
    /// Tries to find a <see cref="TColumn"/> instance by its ID.
    /// </summary>
    /// <param name="ID">The ID of the column</param>
    /// <param name="FoundColumn">The found column</param>
    /// <returns>True, if successfull</returns>
    function TryGet(const ID: string; out FoundColumn: TColumn): Boolean; overload;

  end;

implementation

uses
  OpenCodeList.CodeListParserException,
  OpenCodeList.CodeListDocument,
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TColumns }

constructor TColumns.Create(ADocument: TObject; AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
  FDocument := ADocument;
end;

function TColumns.TryGet(const ID: string; out FoundColumn: TColumn): Boolean;
begin
  Result := TryGet(
    function(Column: TColumn): Boolean
    begin
      Result := Column.ID = ID;
    end,
    FoundColumn
  );
end;

function TColumns.Contains(const ID: string): Boolean;
begin
  Result := Contains(
    function(Column: TColumn): Boolean
    begin
      Result := Column.ID = ID;
    end
  );
end;

procedure TColumns.ParseAndAdd(JsonArrayToBeParsed: TJSONArray);
var
  JsonString: TJSONString;
  JsonObject: TJSONObject;
  Column: TColumn;
begin
  for var JsonValue in JsonArrayToBeParsed do
  begin
    if JsonValue is TJSONString then
    begin
      if TCodeListDocument(FDocument).Columns.TryGet(JsonValue.Value, Column) then
        Add(Column)
      else
        raise ECodeListParserException.CreateFmt('Column ID "%s" not found.', [JsonValue.Value]);
    end else
    if JsonValue is TJSONObject then
    begin
      JsonObject := JsonValue as TJSONObject;
      if JsonObject.GetRequiredJsonString(TPropertyNames.Type, JsonString) then
      begin
        if JsonString.Value = TTypeConsts.String then
          Add(TStringColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.Enum then
          Add(TEnumColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.EnumSet then
          Add(TEnumSetColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.Number then
          Add(TNumberColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.Integer then
          Add(TIntegerColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.Boolean then
          Add(TBooleanColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.DateOnly then
          Add(TDateOnlyColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.DateTime then
          Add(TDateTimeColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.TimeOnly then
          Add(TTimeOnlyColumn.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.Document then
          Add(TJsonColumn.Parse(JsonObject))
        else
          raise ECodeListParserException.CreateFmt('Unknown column type "%s".', [JsonString.Value]);
      end else
        raise ECodeListParserException.Create('Type property is missing.');

    end
  end;
end;

procedure TColumns.Notify(const Item: TColumn; Action: TCollectionNotification);
begin
  if Action in [cnRemoved, cnExtracted] then
  begin
    (FDocument as TCodeListDocument).Keys.RemoveAll(Item);
    (FDocument as TCodeListDocument).ForeignKeys.RemoveAll(Item);
    (FDocument as TCodeListDocument).Rows.RemoveValues(Item);
  end;
end;

end.

