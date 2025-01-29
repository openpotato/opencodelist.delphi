{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.EnumSetColumn;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Generics.Collections,
  OpenCodeList.Column,
  OpenCodeList.EnumMember;

type

  /// <summary>
  /// This is an enumeration set type column.
  /// </summary>
  TEnumSetColumn = class(TColumn)
  private
    FLanguage: string;
    FMembers: TObjectList<TEnumMember>;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TEnumSetColumn"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TEnumSetColumn"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TEnumSetColumn;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TEnumSetColumn" />
    /// </summary>
    constructor Create;

    /// <summary>
    /// Cleans up resources
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// A language tag according to https://www.rfc-editor.org/rfc/bcp/bcp47.txt
    /// to specify the language of the content.
    /// </summary>
    property Language: string read FLanguage write FLanguage;

    /// <summary>
    /// The list of allowed values for the enumeration set.
    /// </summary>
    property Members: TObjectList<TEnumMember> read FMembers;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TEnumSetColumn }

constructor TEnumSetColumn.Create;
begin
  inherited;
  FMembers := TObjectList<TEnumMember>.Create;
end;

destructor TEnumSetColumn.Destroy;
begin
  FMembers.Free;
  inherited;
end;

class function TEnumSetColumn.Parse(JsonObjectToBeParsed: TJSONObject): TEnumSetColumn;
var
  JsonString: TJSONString;
  JsonBool: TJSONBool;
  JsonArray: TJSONArray;
begin
  Result := TEnumSetColumn.Create;
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

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Language, JsonString) then
      Result.Language := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.Members, JsonArray) then
    begin
      for var ArrayElement in JsonArray do
      begin
        if ArrayElement is TJSONObject then
          Result.Members.Add(TEnumMember.Parse(TJSONObject(ArrayElement)));
      end;
    end;

  except
    Result.Free; raise;
  end;
end;

procedure TEnumSetColumn.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Type, TTypeConsts.EnumSet);
  JsonObject.AddString(TPropertyNames.Id, Id);
  JsonObject.AddString(TPropertyNames.Name, Name);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, Description);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Nullable, Nullable);
  JsonObject.AddBooleanOrNothing(TPropertyNames.Optional, Optional);
  JsonObject.AddStringOrNothing(TPropertyNames.Language, FLanguage);
  JsonObject.AddEnumMemberArray(TPropertyNames.Members, FMembers);
end;

end.

