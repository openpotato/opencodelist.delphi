{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.EnumMember;

interface

uses
  System.JSON,
  System.SysUtils,
  OpenCodeList.BaseObjects;

type

  /// <summary>
  /// An enumeration member.
  /// </summary>
  TEnumMember = class(TBaseObject)
  private
    FValue: string;
    FDescription: string;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TEnumMember"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TEnumMember"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TEnumMember;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// The value.
    /// </summary>
    property Value: string read FValue write FValue;

    /// <summary>
    /// A short description of the value.
    /// </summary>
    property Description: string read FDescription write FDescription;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.DateTimeUtils,
  OpenCodeList.JsonHelper;

{ TEnumMember }

class function TEnumMember.Parse(JsonObjectToBeParsed: TJSONObject): TEnumMember;
var
  JsonString: TJSONString;
begin
  Result := TEnumMember.Create;
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Value, JsonString) then
      Result.Value := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Description, JsonString) then
      Result.Description := JsonString.Value;

  except
    Result.Free; raise;
  end;
end;

procedure TEnumMember.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Value, FValue);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, FDescription);
end;

end.


