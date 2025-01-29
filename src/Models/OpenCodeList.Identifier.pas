{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Identifier;

interface

uses
  System.SysUtils,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.IdentifierSource;

type

  /// <summary>
  /// A general identifier
  /// </summary>
  TIdentifier = class(TBaseObject)
  private
    FValue: string;
    FSource: TIdentifierSource;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TIdentifier"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TIdentifier"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TIdentifier;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// The identifier value.
    /// </summary>
    property Value: string read FValue write FValue;

    /// <summary>
    /// The source of the identifier.
    /// </summary>
    property Source: TIdentifierSource read FSource write FSource;

  end;

implementation

uses
  OpenCodeList.PropertyNames, OpenCodeList.JsonHelper;

{ TIdentifier }

class function TIdentifier.Parse(JsonObjectToBeParsed: TJSONObject): TIdentifier;
var
  JsonString: TJSONString;
  JsonObject: TJSONObject;
begin
  Result := TIdentifier.Create;
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.value, JsonString) then
      Result.Value := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.Source, JsonObject) then
      Result.Source := TIdentifierSource.Parse(JsonObject);

  except
    Result.Free; raise;
  end;
end;

procedure TIdentifier.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Value, FValue);
  JsonObject.AddObject<TIdentifierSource>(TPropertyNames.Source, FSource);
end;

end.

