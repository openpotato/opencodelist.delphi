{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.LocalizedUri;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Net.URLClient,
  OpenCodeList.BaseObjects;

type

  /// <summary>
  /// An URl with an additional language declaration.
  /// </summary>
  TLocalizedUri = class(TBaseObject)
  private
    FUrl: TUri;
    FLanguage: string;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TLocalizedUri"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TLocalizedUri"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TLocalizedUri;

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
    /// Gets or sets the language tag.
    /// </summary>
    property Language: string read FLanguage write FLanguage;

  end;

implementation

uses
  OpenCodeList.PropertyNames, OpenCodeList.JsonHelper;

{ TLocalizedUri }

class function TLocalizedUri.Parse(JsonObjectToBeParsed: TJSONObject): TLocalizedUri;
var
  JsonString: TJSONString;
begin
  Result := TLocalizedUri.Create();
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Language, JsonString) then
      Result.Language := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Url, JsonString) then
      Result.Url := TUri.Create(JsonString.Value);

  except
    Result.Free; raise;
  end;
end;

procedure TLocalizedUri.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Language, FLanguage);
  JsonObject.AddUri(TPropertyNames.Url, FUrl);
end;

end.

