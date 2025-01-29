{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Row;

interface

uses
  System.Classes,
  System.JSON,
  System.SysUtils,
  System.Variants,
  System.Generics.Collections,
  OpenCodeList.Nullable,
  OpenCodeList.BaseObjects,
  OpenCodeList.Values,
  OpenCodeList.Column,
  OpenCodeList.BooleanColumn,
  OpenCodeList.DateOnlyColumn,
  OpenCodeList.DateTimeColumn,
  OpenCodeList.EnumColumn,
  OpenCodeList.EnumSetColumn,
  OpenCodeList.IntegerColumn,
  OpenCodeList.JsonColumn,
  OpenCodeList.NumberColumn,
  OpenCodeList.StringColumn,
  OpenCodeList.TimeOnlyColumn;

type

  /// <summary>
  /// A data row of a code list.
  /// </summary>
  TRow = class(TBaseObject)
  private
    FDocument: TObject;
    FValues: TDictionary<string, TValue>;
    function GetValue(const ColumnId: string): TValue; overload;
    procedure SetValue(const ColumnId: string; Value: TValue); overload;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TRow"/> instance.
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TRow"/> instance</returns>
    class function Parse(Document: TObject; JsonObjectToBeParsed: TJSONObject): TRow;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TRow" />
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    constructor Create(Document: TObject);

    /// <summary>
    /// Cleans up resources
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Clears all values in the row.
    /// </summary>
    procedure Clear;

    /// <summary>
    /// Removes the value with reference to a given column
    /// </summary>
    /// <param name="ColumnId">The column Id</param>
    /// <returns>TRUE, if removed</returns>
    procedure RemoveValue(const ColumnId: string); overload;

    /// <summary>
    /// Removes the value with reference to a given column
    /// </summary>
    /// <param name="Column">The column</param>
    /// <returns>TRUE, if removed</returns>
    procedure RemoveValue(Column: TColumn); overload;

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

    /// <summary>
    /// Creates and adds a value object to the row.
    /// </summary>
    /// <param name="ColumnId">A column id</param>
    /// <returns>The new value object</returns>
    function CreateAndAddValue<T: TValue, constructor>(const ColumnId: string): T; overload;

  public

    /// <summary>
    /// Access values by column ID.
    /// </summary>
    property Values[const ColumnId: string]: TValue read GetValue write SetValue; default;

  end;

implementation

uses
  OpenCodeList.CodeListParserException,
  OpenCodeList.CodeListDocument,
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.DateTimeUtils,
  OpenCodeList.JsonHelper;

{ TRow }

constructor TRow.Create(Document: TObject);
begin
  FDocument := Document;
  FValues := TDictionary<string, TValue>.Create;
  Clear;
end;

destructor TRow.Destroy;
begin
  FValues.Free;
  inherited;
end;

procedure TRow.Clear;
begin
  FValues.Clear;
end;

procedure TRow.RemoveValue(const ColumnId: string);
begin
  FValues.Remove(ColumnId);
end;

procedure TRow.RemoveValue(Column: TColumn);
begin
  RemoveValue(Column.Id);
end;

class function TRow.Parse(Document: TObject; JsonObjectToBeParsed: TJSONObject): TRow;
var
  Column: TColumn;
begin
  Result := TRow.Create(Document);
  try
    for var JsonPair in JsonObjectToBeParsed do
    begin
      if TCodeListDocument(Document).Columns.TryGet(JsonPair.JsonString.Value, Column) then
      begin
        if not (JsonPair.JsonValue is TJSONNull) then
        begin
          if Column is TStringColumn then
          begin
            if JsonPair.JsonValue is TJSONString then
            begin
              Result.Values[Column.Id] := TStringValue.Create((JsonPair.JsonValue as TJSONString).Value);
            end else
              raise ECodeListParserException.Create('Value is not a string.');
          end else
          if Column is TBooleanColumn then
          begin
            if JsonPair.JsonValue is TJSONBool then
            begin
              Result.Values[Column.Id] := TBooleanValue.Create((JsonPair.JsonValue as TJSONBool).AsBoolean);
            end else
              raise ECodeListParserException.Create('Value is not a boolean.');
          end else
          if Column is TIntegerColumn then
          begin
            if JsonPair.JsonValue is TJSONNumber then
            begin
              Result.Values[Column.Id] := TIntegerValue.Create((JsonPair.JsonValue as TJSONNumber).AsInt);
            end else
              raise ECodeListParserException.Create('Value is not an integer.');
          end else
          if Column is TNumberColumn then
          begin
            if JsonPair.JsonValue is TJSONNumber then
            begin
              Result.Values[Column.Id] := TNumberValue.Create((JsonPair.JsonValue as TJSONNumber).AsDouble);
            end else
              raise ECodeListParserException.Create('Value is not a number.');
          end else
          if Column is TDateTimeColumn then
          begin
            if JsonPair.JsonValue is TJSONString then
            begin
              Result.Values[Column.Id] := TDateTimeValue.Create(ISO8601StrToDateTime((JsonPair.JsonValue as TJSONString).Value));
            end else
              raise ECodeListParserException.Create('Value is not a date-time.');
          end else
          if Column is TDateOnlyColumn then
          begin
            if JsonPair.JsonValue is TJSONString then
            begin
              Result.Values[Column.Id] := TDateOnlyValue.Create(ISO8601StrToDateTime((JsonPair.JsonValue as TJSONString).Value));
            end else
              raise ECodeListParserException.Create('Value is not a date.');
          end else
          if Column is TTimeOnlyColumn then
          begin
            if JsonPair.JsonValue is TJSONString then
            begin
              Result.Values[Column.Id] := TTimeOnlyValue.Create(ISO8601StrToDateTime((JsonPair.JsonValue as TJSONString).Value));
            end else
              raise ECodeListParserException.Create('Value is not a time.');
          end else
          if Column is TEnumColumn then
          begin
            if JsonPair.JsonValue is TJSONString then
            begin
              Result.Values[Column.Id] := TStringValue.Create((JsonPair.JsonValue as TJSONString).Value);
            end else
              raise ECodeListParserException.Create('Value is not a enum.');
          end else
          if Column is TEnumSetColumn then
          begin
            if JsonPair.JsonValue is TJSONArray then
            begin
              var SL := TStringList.Create;
              try
                for var ArrayElement in (JsonPair.JsonValue as TJSONArray) do
                begin
                  if ArrayElement is TJSONString then
                  begin
                    SL.Add((ArrayElement as TJSONString).Value);
                  end else
                    raise ECodeListParserException.Create('Value is not an array.');
                end;
                Result.Values[Column.Id] := TStringListValue.Create(SL);
              except
                SL.Free; raise;
              end;
            end else
              raise ECodeListParserException.Create('Value is not a enum-set.');
          end else
          if Column is TJsonColumn then
          begin
            if JsonPair.JsonValue is TJSONObject then
            begin
              Result.Values[Column.Id] := TJSONObjectValue.Create(JsonPair.JsonValue.Clone as TJSONObject);
            end else
            if JsonPair.JsonValue is TJSONArray then
            begin
              Result.Values[Column.Id] := TJSONArrayValue.Create(JsonPair.JsonValue.Clone as TJSONArray);
            end else
              raise ECodeListParserException.Create('Value is not an object or an array.');
          end;
        end;
      end else
        raise ECodeListParserException.CreateFmt('Column with ID "%s" not found.', [JsonPair.JsonString.Value]);
    end;
  except
    Result.Free; raise;
  end;
end;

procedure TRow.WriteTo(JsonObject: TJSONObject);
var
  CellValue: TValue;
begin
  for var Column in (FDocument as TCodeListDocument).Columns do
  begin
    if FValues.TryGetValue(Column.Id, CellValue) then
    begin
      if Column is TStringColumn then
      begin
        if CellValue is TStringValue then
        begin
          JsonObject.AddString(Column.Id, (CellValue as TStringValue).Value);
        end else
          raise ECodeListParserException.Create('Value is not a string.');
      end else
      if Column is TBooleanColumn then
      begin
        if CellValue is TBooleanValue then
        begin
          JsonObject.AddBoolean(Column.Id, (CellValue as TBooleanValue).Value);
        end else
          raise ECodeListParserException.Create('Value is not a boolean.');
      end else
      if Column is TDateTimeColumn then
      begin
        if CellValue is TDateTimeValue then
        begin
          JsonObject.AddDateTime(Column.Id, (CellValue as TDateTimeValue).Value);
        end else
          raise ECodeListParserException.Create('Value is not a string.');
      end else
      if Column is TDateOnlyColumn then
      begin
        if CellValue is TDateOnlyValue then
        begin
          JsonObject.AddDateOnly(Column.Id, (CellValue as TDateOnlyValue).Value);
        end else
          raise ECodeListParserException.Create('Value is not a string.');
      end else
      if Column is TTimeOnlyColumn then
      begin
        if CellValue is TTimeOnlyValue then
        begin
          JsonObject.AddTimeOnly(Column.Id, (CellValue as TTimeOnlyValue).Value);
        end else
          raise ECodeListParserException.Create('Value is not a string.');
      end else
      if Column is TIntegerColumn then
      begin
        if CellValue is TIntegerValue then
        begin
          JsonObject.AddInteger(Column.Id, (CellValue as TIntegerValue).Value);
        end else
          raise ECodeListParserException.Create('Value is not an integer.');
      end else
      if Column is TNumberColumn then
      begin
        if CellValue is TNumberValue then
        begin
          JsonObject.AddDouble(Column.Id, (CellValue as TNumberValue).Value);
        end else
          raise ECodeListParserException.Create('Value is not a number.');
      end else
      if Column is TEnumColumn then
      begin
        if CellValue is TStringValue then
        begin
          JsonObject.AddString(Column.Id, (CellValue as TStringValue).Value);
        end else
          raise ECodeListParserException.Create('Value is not a string.');
      end else
      if Column is TEnumSetColumn then
      begin
        if CellValue is TStringListValue then
          JsonObject.AddStringList(Column.Id, (CellValue as TStringListValue).List)
        else
          raise ECodeListParserException.Create('Value is not a TStringListValue.');
      end else
      if Column is TJsonColumn then
      begin
        if CellValue is TJSONObjectValue then
          JsonObject.AddObject(Column.Id, (CellValue as TJSONObjectValue).&Object.Clone as TJSONObject)
        else
        if CellValue is TJSONArrayValue then
          JsonObject.AddObjectArray(Column.Id, (CellValue as TJSONArrayValue).&Array.Clone as TJSONArray)
        else
          raise ECodeListParserException.Create('Value is neither an TJSONObjectValue nor an TJSONArrayValue.');
      end;
    end;

  end;
end;

function TRow.CreateAndAddValue<T>(const ColumnId: string): T;
begin
  Result := T.Create;
  SetValue(ColumnId, Result);
end;

function TRow.GetValue(const ColumnId: string): TValue;
var
  Value: TValue;
begin
  if FValues.TryGetValue(ColumnId, Value) then
  begin
    Result := Value
  end else
  begin
    if (FDocument as TCodeListDocument).Columns.Contains(ColumnId) then
      Result := nil
    else
      raise ECodeListParserException.CreateFmt('Column with ID "%s" not found', [ColumnId]);
  end;
end;

procedure TRow.SetValue(const ColumnId: string; Value: TValue);
var
  Column: TColumn;
begin
  if (FDocument as TCodeListDocument).Columns.TryGet(ColumnId, Column) then
  begin
    if FValues.ContainsKey(Column.Id) then
    begin
      FValues[Column.Id].Free;
      FValues[Column.Id] := Value;
    end else
      FValues.Add(Column.Id, Value);
  end else
    raise ECodeListParserException.CreateFmt('Column with ID "%s" not found', [ColumnId]);
end;

end.

