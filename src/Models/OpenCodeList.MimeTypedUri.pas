{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.MimeTypedUri;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Net.URLClient,
  OpenCodeList.BaseObjects;

type

  /// <summary>
  /// An URL with an additional mime type declaration.
  /// </summary>
  TMimeTypedUri = class(TBaseObject)
  private
    FUrl: TURI;
    FMimeType: string;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TMimeTypedUri"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TMimeTypedUri"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TMimeTypedUri;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// Gets or sets the URL.
    /// </summary>
    property Url: TURI read FUrl write FUrl;

    /// <summary>
    /// Gets or sets the mime type.
    /// </summary>
    property MimeType: string read FMimeType write FMimeType;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.JsonHelper;

{ TMimeTypedUri }

class function TMimeTypedUri.Parse(JsonObjectToBeParsed: TJSONObject): TMimeTypedUri;
var
  JsonString: TJSONString;
begin
  Result := TMimeTypedUri.Create();
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.MimeType, JsonString) then
      Result.MimeType := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Url, JsonString) then
      Result.Url := TUri.Create(JsonString.Value);

  except
    Result.Free; raise;
  end;
end;

procedure TMimeTypedUri.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.MimeType, FMimeType);
  JsonObject.AddUri(TPropertyNames.Url, FUrl);
end;

end.

