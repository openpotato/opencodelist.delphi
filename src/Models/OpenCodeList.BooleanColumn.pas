{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.BooleanColumn;

interface

uses
  System.JSON,
  System.SysUtils,
  OpenCodeList.Column;

type

  /// <summary>
  /// This is a boolean type column.
  /// </summary>
  TBooleanColumn = class(TColumn)
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TBooleanColumn"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TBooleanColumn"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TBooleanColumn;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TBooleanColumn }

class function TBooleanColumn.Parse(JsonObjectToBeParsed: TJSONObject): TBooleanColumn;
var
  JsonString: TJSONString;
  JsonBool: TJSONBool;
begin
  Result := TBooleanColumn.Create;
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

  except
    Result.Free; raise;
  end;
end;

procedure TBooleanColumn.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Type, TTypeConsts.Boolean);
  JsonObject.AddString(TPropertyNames.Id, Id);
  JsonObject.AddString(TPropertyNames.Name, Name);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, Description);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Nullable, Nullable);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Optional, Optional);
end;

end.

