{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Publisher;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Net.URLClient,
  OpenCodeList.Nullable,
  OpenCodeList.BaseObjects,
  OpenCodeList.Identifier;

type

  /// <summary>
  /// Publisher that is responsible for publication and/or maintenance of the
  /// document.
  /// </summary>
  TPublisher = class(TBaseObject)
  private
    FIdentifier: TIdentifier;
    FLongName: Nullable<string>;
    FShortName: string;
    FUrl: Nullable<TURI>;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TPublisher"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TPublisher"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TPublisher;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// Identifier for the publisher.
    /// </summary>
    property Identifier: TIdentifier read FIdentifier write FIdentifier;

    /// <summary>
    /// Human-readable name for the publisher.
    /// </summary>
    property LongName: Nullable<string> read FLongName write FLongName;

    /// <summary>
    /// Short name for the publisher.
    /// </summary>
    property ShortName: string read FShortName write FShortName;

    /// <summary>
    /// More information about the publisher.
    /// </summary>
    property Url: Nullable<TURI> read FUrl write FUrl;

  end;

implementation

uses
  OpenCodeList.PropertyNames, OpenCodeList.JsonHelper;

{ TPublisher }

class function TPublisher.Parse(JsonObjectToBeParsed: TJSONObject): TPublisher;
var
  JsonString: TJSONString;
  JsonObject: TJSONObject;
begin
  Result := TPublisher.Create;
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.ShortName, JsonString) then
      Result.ShortName := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.LongName, JsonString) then
      Result.LongName := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.Identifier, JsonObject) then
      Result.Identifier := TIdentifier.Parse(JsonObject);

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Url, JsonString) then
      Result.Url := TURI.Create(JsonString.Value);

  except
    Result.Free; raise;
  end;
end;

procedure TPublisher.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.ShortName, FShortName);
  JsonObject.AddStringOrNothing(TPropertyNames.LongName, FLongName);
  JsonObject.AddObject<TIdentifier>(TPropertyNames.Identifier, FIdentifier);
  JsonObject.AddUriOrNothing(TPropertyNames.Url, FUrl);
end;

end.

