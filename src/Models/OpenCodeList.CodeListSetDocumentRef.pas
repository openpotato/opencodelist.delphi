{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.CodeListSetDocumentRef;

interface

uses
  System.SysUtils,
  System.JSON,
  System.JSON.Types,
  System.Net.URLClient,
  OpenCodeList.BaseObjects,
  OpenCodeList.DocumentRef;

type

  /// <summary>
  /// An external code list set reference.
  /// </summary>
  TCodeListSetDocumentRef = class(TDocumentRef)
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TCodeListSetDocumentRef"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    /// <returns>A new <see cref="TCodeListDocumentRef"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TCodeListSetDocumentRef;

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

{ TCodeListSetDocumentRef }

class function TCodeListSetDocumentRef.Parse(JsonObjectToBeParsed: TJSONObject): TCodeListSetDocumentRef;
var
  JsonString: TJSONString;
  JsonArray: TJSONArray;
begin
  Result := TCodeListSetDocumentRef.Create;
  try

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.CanonicalUri, JsonString) then
      Result.CanonicalUri := TURI.Create(JsonString.Value);

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.CanonicalVersionUri, JsonString) then
      Result.CanonicalVersionUri := TURI.Create(JsonString.Value);

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.LocationUrls, JsonArray) then
    begin
      for var ArrayElement in JsonArray do
      begin
        if ArrayElement is TJSONString then
          Result.LocationUrls.Add(TURI.Create(TJSONString(ArrayElement).Value));
      end;
    end;

  except
    Result.Free; raise;
  end;
end;

procedure TCodeListSetDocumentRef.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Type, TTypeConsts.CodeListSetRef);
  JsonObject.AddUriOrNothing(TPropertyNames.CanonicalUri, CanonicalUri);
  JsonObject.AddUri(TPropertyNames.CanonicalVersionUri, CanonicalVersionUri);
  JsonObject.AddUriArray(TPropertyNames.LocationUrls, LocationUrls);
end;

end.

