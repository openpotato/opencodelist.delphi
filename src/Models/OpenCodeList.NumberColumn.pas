{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.NumberColumn;

interface

uses
  System.JSON,
  System.SysUtils,
  OpenCodeList.Nullable,
  OpenCodeList.Column;

type

  /// <summary>
  /// This is a float type column.
  /// </summary>
  TNumberColumn = class(TColumn)
  private
    FMinValue: Nullable<Double>;
    FMaxValue: Nullable<Double>;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TNumberColumn"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TNumberColumn"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TNumberColumn;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// An integer value that specifies the minimum allowed value.
    /// </summary>
    property MinValue: Nullable<Double> read FMinValue write FMinValue;

    /// <summary>
    /// An integer value that specifies the maximum allowed value.
    /// </summary>
    property MaxValue: Nullable<Double> read FMaxValue write FMaxValue;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.DateTimeUtils,
  OpenCodeList.JsonHelper;

{ TNumberColumn }

class function TNumberColumn.Parse(JsonObjectToBeParsed: TJSONObject): TNumberColumn;
var
  JsonString: TJSONString;
  JsonBool: TJSONBool;
  JsonNumber: TJSONNumber;
begin
  Result := TNumberColumn.Create;
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Id, JsonString) then
      Result.Id := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Name, JsonString) then
      Result.Name := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Description, JsonString) then
      Result.Description := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonBool(TPropertyNames.Nullable, JsonBool) then
      Result.Nullable := JsonBool.AsBoolean;

    if JsonObjectToBeParsed.TryGetJsonBool(TPropertyNames.Optional, JsonBool) then
      Result.Optional := JsonBool.AsBoolean;

    if JsonObjectToBeParsed.TryGetJsonNumber(TPropertyNames.MinValue, JsonNumber) then
      Result.MinValue := JsonNumber.AsDouble;

    if JsonObjectToBeParsed.TryGetJsonNumber(TPropertyNames.MaxValue, JsonNumber) then
      Result.MaxValue := JsonNumber.AsDouble;

  except
    Result.Free; raise;
  end;
end;

procedure TNumberColumn.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Type, TTypeConsts.Number);
  JsonObject.AddString(TPropertyNames.Id, Id);
  JsonObject.AddString(TPropertyNames.Name, Name);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, Description);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Nullable, Nullable);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Optional, Optional);
  JsonObject.AddDoubleOrNothing(TPropertyNames.MinValue, FMinValue);
  JsonObject.AddDoubleOrNothing(TPropertyNames.MaxValue, FMaxValue);
end;

end.

