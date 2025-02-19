{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.CodeListDocumentRef;

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
  /// An external code list reference.
  /// </summary>
  TCodeListDocumentRef = class(TDocumentRef)
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TCodeListDocumentRef"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    /// <returns>A new <see cref="TCodeListDocumentRef"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TCodeListDocumentRef;

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

{ TCodeListDocumentRef }

class function TCodeListDocumentRef.Parse(JsonObjectToBeParsed: TJSONObject): TCodeListDocumentRef;
var
  JsonString: TJSONString;
  JsonArray: TJSONArray;
begin
  Result := TCodeListDocumentRef.Create;
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.CanonicalUri, JsonString) then
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

procedure TCodeListDocumentRef.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Type, TTypeConsts.CodeListRef);
  JsonObject.AddUriOrNothing(TPropertyNames.CanonicalUri, CanonicalUri);
  JsonObject.AddUri(TPropertyNames.CanonicalVersionUri, CanonicalVersionUri);
  JsonObject.AddUriArray(TPropertyNames.LocationUrls, LocationUrls);
end;

end.

