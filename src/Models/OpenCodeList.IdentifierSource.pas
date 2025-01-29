{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.IdentifierSource;

interface

uses
  System.SysUtils,
  System.JSON,
  System.JSON.Types,
  System.Net.URLClient,
  OpenCodeList.Nullable,
  OpenCodeList.BaseObjects;

type

  /// <summary>
  /// Source information for a general identifier
  /// </summary>
  TIdentifierSource = class(TBaseObject)
  private
    FLongName: Nullable<string>;
    FShortName: string;
    FUrl: Nullable<TURI>;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TIdentifierSource"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TIdentifierSource"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TIdentifierSource;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// Human-readable name of the source.
    /// </summary>
    property LongName: Nullable<string> read FLongName write FLongName;

    /// <summary>
    /// Short name of the source.
    /// </summary>
    property ShortName: string read FShortName write FShortName;

    /// <summary>
    /// More information about the source.
    /// </summary>
    property Url: Nullable<TURI> read FUrl write FUrl;

  end;

implementation

uses
  OpenCodeList.PropertyNames, OpenCodeList.JsonHelper;

{ TIdentifierSource }

class function TIdentifierSource.Parse(JsonObjectToBeParsed: TJSONObject): TIdentifierSource;
var
  JsonString: TJSONString;
begin
  Result := TIdentifierSource.Create;
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.ShortName, JsonString) then
      Result.ShortName := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.LongName, JsonString) then
      Result.LongName := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Url, JsonString) then
      Result.Url := TURI.Create(JsonString.Value);

  except
    Result.Free; raise;
  end;
end;

procedure TIdentifierSource.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.ShortName, FShortName);
  JsonObject.AddStringOrNothing(TPropertyNames.LongName, FLongName);
  JsonObject.AddUriOrNothing(TPropertyNames.Url, FUrl);
end;

end.

