{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) ST�BER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.TimeOnlyColumn;

interface

uses
  System.JSON,
  System.SysUtils,
  OpenCodeList.Nullable,
  OpenCodeList.Column;

type

  /// <summary>
  /// This is a time only type column. The serialized format must match the native
  /// JSON string with the JSON Schema format `time`.
  /// See: https://json-schema.org/understanding-json-schema/reference/string.
  /// </summary>
  TTimeOnlyColumn = class(TColumn)
  private
    FMinValue: Nullable<TTime>;
    FMaxValue: Nullable<TTime>;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TTimeOnlyColumn"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TTimeOnlyColumn"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TTimeOnlyColumn;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// A value that specifies the minimum allowed value.
    /// </summary>
    property MinValue: Nullable<TTime> read FMinValue write FMinValue;

    /// <summary>
    /// A value that specifies the maximum allowed value.
    /// </summary>
    property MaxValue: Nullable<TTime> read FMaxValue write FMaxValue;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.DateTimeUtils,
  OpenCodeList.JsonHelper;

{ TTimeOnlyColumn }

class function TTimeOnlyColumn.Parse(JsonObjectToBeParsed: TJSONObject): TTimeOnlyColumn;
var
  JsonString: TJSONString;
  JsonBool: TJSONBool;
begin
  Result := TTimeOnlyColumn.Create;
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

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.MinValue, JsonString) then
      Result.MinValue := ISO8601StrToDateTime(JsonString.Value);

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.MaxValue, JsonString) then
      Result.MaxValue := ISO8601StrToDateTime(JsonString.Value);

  except
    Result.Free; raise;
  end;
end;

procedure TTimeOnlyColumn.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Type, TTypeConsts.TimeOnly);
  JsonObject.AddString(TPropertyNames.Id, Id);
  JsonObject.AddString(TPropertyNames.Name, Name);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, Description);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Nullable, Nullable);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Optional, Optional);
  JsonObject.AddTimeOnlyOrNothing(TPropertyNames.MinValue, FMinValue);
  JsonObject.AddTimeOnlyOrNothing(TPropertyNames.MaxValue, FMaxValue);
end;

end.
