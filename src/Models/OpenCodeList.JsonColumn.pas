{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.JsonColumn;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Net.URLClient,
  OpenCodeList.Nullable,
  OpenCodeList.Column;

type

  /// <summary>
  /// Schema location
  /// </summary>
  TJsonColumnSchemaLocation = (&External, Embedded);

  /// <summary>
  /// This is a column representing an embedded json object or array.
  /// </summary>
  TJsonColumn = class(TColumn)
  private
    FSchemaLocation: TJsonColumnSchemaLocation;
    FEmbeddedSchema: TJSONObject;
    FExternalSchema: TURI;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TJsonColumn"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TJsonColumn"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TJsonColumn;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// Schema location
    /// </summary>
    property SchemaLocation: TJsonColumnSchemaLocation read FSchemaLocation write FSchemaLocation;

    /// <summary>
    /// Emebdded JSON schema as string.
    /// </summary>
    property EmbeddedSchema: TJSONObject read FEmbeddedSchema write FEmbeddedSchema;

    /// <summary>
    /// Uri to the JSON schema file.
    /// </summary>
    property ExternalSchema: TURI read FExternalSchema write FExternalSchema;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TJsonColumn }

class function TJsonColumn.Parse(JsonObjectToBeParsed: TJSONObject): TJsonColumn;
var
  JsonString: TJSONString;
  JsonBool: TJSONBool;
begin
  Result := TJsonColumn.Create;
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

procedure TJsonColumn.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Type, TTypeConsts.Document);
  JsonObject.AddString(TPropertyNames.Id, Id);
  JsonObject.AddString(TPropertyNames.Name, Name);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, Description);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Nullable, Nullable);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Optional, Optional);
end;

end.

