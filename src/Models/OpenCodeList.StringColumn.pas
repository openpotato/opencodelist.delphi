{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.StringColumn;

interface

uses
  System.JSON,
  System.SysUtils,
  OpenCodeList.Nullable,
  OpenCodeList.Column;

type

  /// <summary>
  /// This is a string type column.
  /// </summary>
  TStringColumn = class(TColumn)
  private
    FLanguage: Nullable<string>;
    FMaxLength: Nullable<Integer>;
    FMinLength: Nullable<Integer>;
    FPattern: Nullable<string>;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TStringColumn"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TStringColumn"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TStringColumn;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TStringColumn" />
    /// </summary>
    constructor Create;

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// A language tag to specify the language of the content.
    /// </summary>
    property Language: Nullable<string> read FLanguage write FLanguage;

    /// <summary>
    /// Specifies the maximum character length of the value.
    /// </summary>
    property MaxLength: Nullable<Integer> read FMaxLength write FMaxLength;

    /// <summary>
    /// Specifies the minimum character length of the value.
    /// </summary>
    property MinLength: Nullable<Integer> read FMinLength write FMinLength;

    /// <summary>
    /// Specifies a regular expression that must match each value.
    /// </summary>
    property Pattern: Nullable<string> read FPattern write FPattern;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TStringColumn }

constructor TStringColumn.Create;
begin
  inherited;
end;

class function TStringColumn.Parse(JsonObjectToBeParsed: TJSONObject): TStringColumn;
var
  JsonString: TJSONString;
  JsonBool: TJSONBool;
  JsonNumber: TJSONNumber;
begin
  Result := TStringColumn.Create;
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

    if JsonObjectToBeParsed.TryGetJsonNumber(TPropertyNames.MinLength, JsonNumber) then
      Result.MinLength := JsonNumber.AsInt;

    if JsonObjectToBeParsed.TryGetJsonNumber(TPropertyNames.MaxLength, JsonNumber) then
      Result.MaxLength := JsonNumber.AsInt;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Pattern, JsonString) then
      Result.Pattern := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Language, JsonString) then
      Result.Language := JsonString.Value;

  except
    Result.Free; raise;
  end;
end;

procedure TStringColumn.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Type, TTypeConsts.String);
  JsonObject.AddString(TPropertyNames.Id, Id);
  JsonObject.AddString(TPropertyNames.Name, Name);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, Description);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Nullable, Nullable);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Optional, Optional);
  JsonObject.AddIntegerOrNothing(TPropertyNames.MinLength, FMinLength);
  JsonObject.AddIntegerOrNothing(TPropertyNames.MaxLength, FMaxLength);
  JsonObject.AddStringOrNothing(TPropertyNames.Pattern, FPattern);
  JsonObject.AddStringOrNothing(TPropertyNames.Language, FLanguage);
end;

end.

