{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Identification;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  System.Net.URLClient,
  OpenCodeList.Nullable,
  OpenCodeList.BaseObjects,
  OpenCodeList.Publisher,
  OpenCodeList.MimeTypedUri,
  OpenCodeList.LocalizedUri;

type

  /// <summary>
  /// Meta information about a code list or a code list set.
  /// </summary>
  TIdentification = class(TBaseObject)
  private
    FShortName: string;
    FLongName: Nullable<string>;
    FTags: TList<string>;
    FPublisher: TPublisher;
    FVersion: Nullable<string>;
    FChangeLog: TList<string>;
    FPublishedAt: Nullable<TDateTime>;
    FValidFrom: Nullable<TDateTime>;
    FValidTo: Nullable<TDateTime>;
    FCanonicalUri: Nullable<TUri>;
    FCanonicalVersionUri: TUri;
    FLocationUrls: TList<TUri>;
    FAlternateLanguageLocations: TObjectList<TLocalizedUri>;
    FAlternateFormatLocations: TObjectList<TMimeTypedUri>;
    FLanguage: Nullable<string>;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TIdentification"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TIdentification"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TIdentification;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TIdentification" />
    /// </summary>
    constructor Create;

    /// <summary>
    /// Clean up resources
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// An short identifier of the document.
    /// </summary>
    property ShortName: string read FShortName write FShortName;

    /// <summary>
    /// A human-readable name of the document.
    /// </summary>
    property LongName: Nullable<string> read FLongName write FLongName;

    /// <summary>
    /// A list of tags or keywords that define what the document is about.
    /// </summary>
    property Tags: TList<string> read FTags;

    /// <summary>
    /// The version of the document.
    /// </summary>
    property Version: Nullable<string> read FVersion write FVersion;

    /// <summary>
    /// A curated list of notable changes for the current version of the document.
    /// </summary>
    property ChangeLog: TList<string> read FChangeLog;

    /// <summary>
    /// Information about the publisher that is responsible for publication and/or
    /// maintenance of the document.
    /// </summary>
    property Publisher: TPublisher read FPublisher write FPublisher;

    /// <summary>
    /// The timepoint of the publication of the document.
    /// </summary>
    property PublishedAt: Nullable<TDateTime> read FPublishedAt write FPublishedAt;

    /// <summary>
    /// The timepoint from which this document is valid.
    /// </summary>
    property ValidFrom: Nullable<TDateTime> read FValidFrom write FValidFrom;

    /// <summary>
    /// The timepoint until which this document is valid.
    /// </summary>
    property ValidTo: Nullable<TDateTime> read FValidTo write FValidTo;

    /// <summary>
    /// Canonical URI which uniquely identifies all versions (collectively).
    /// </summary>
    property CanonicalUri: Nullable<TUri> read FCanonicalUri write FCanonicalUri;

    /// <summary>
    /// Canonical URI which uniquely identifies this version.
    /// </summary>
    property CanonicalVersionUri: TUri read FCanonicalVersionUri write FCanonicalVersionUri;

    /// <summary>
    /// Suggested retrieval location for this version, in OpenCodeList format.
    /// </summary>
    property LocationUrls: TList<TUri> read FLocationUrls;

    /// <summary>
    /// Suggested retrieval locations for this document, in OpenCodeList format, but in a different language.
    /// </summary>
    property AlternateLanguageLocations: TObjectList<TLocalizedUri> read FAlternateLanguageLocations;

    /// <summary>
    /// Suggested retrieval locations for this document, in a format other than OpenCodeList.
    /// </summary>
    property AlternateFormatLocations: TObjectList<TMimeTypedUri> read FAlternateFormatLocations;

    /// <summary>
    /// A language tag according to https://www.rfc-editor.org/rfc/bcp/bcp47.txt to specify the
    /// language of the content. Can be overriden by the language tag of a column.
    /// </summary>
    property Language: Nullable<string> read FLanguage write FLanguage;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.DateTimeUtils,
  OpenCodeList.JsonHelper;

{ TIdentification }

constructor TIdentification.Create;
begin
  inherited;
  FTags := TList<string>.Create;
  FChangeLog := TList<string>.Create;
  FLocationUrls := TList<TUri>.Create;
  FAlternateLanguageLocations := TObjectList<TLocalizedUri>.Create(True);
  FAlternateFormatLocations := TObjectList<TMimeTypedUri>.Create(True);
end;

destructor TIdentification.Destroy;
begin
  FTags.Free;
  FChangeLog.Free;
  FLocationUrls.Free;
  FAlternateLanguageLocations.Free;
  FAlternateFormatLocations.Free;
  inherited;
end;

class function TIdentification.Parse(JsonObjectToBeParsed: TJSONObject): TIdentification;
var
  JsonString: TJSONString;
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
begin
  Result := TIdentification.Create;
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.ShortName, JsonString) then
      Result.ShortName := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.LongName, JsonString) then
      Result.LongName := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.Tags, JsonArray) then
    begin
      for var ArrayElement in JsonArray do
      begin
        if ArrayElement is TJSONString then
          Result.Tags.Add(TJSONString(ArrayElement).Value);
      end;
    end;

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.Publisher, JsonObject) then
      Result.Publisher := TPublisher.Parse(JsonObject);

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Version, JsonString) then
      Result.Version := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.ChangeLog, JsonArray) then
    begin
      for var ArrayElement in JsonArray do
      begin
        if ArrayElement is TJSONString then
          Result.ChangeLog.Add(TJSONString(ArrayElement).Value);
      end;
    end;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.PublishedAt, JsonString) then
      Result.PublishedAt := ISO8601StrToDateTime(JsonString.Value);

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.ValidFrom, JsonString) then
      Result.ValidFrom := ISO8601StrToDateTime(JsonString.Value);

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.ValidTo, JsonString) then
      Result.ValidTo := ISO8601StrToDateTime(JsonString.Value);

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

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.AlternateLanguageLocations, JsonArray) then
    begin
      for var ArrayElement in JsonArray do
      begin
        if ArrayElement is TJSONObject then
          Result.AlternateLanguageLocations.Add(TLocalizedUri.Parse(TJSONObject(ArrayElement)));
      end;
    end;

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.AlternateFormatLocations, JsonArray) then
    begin
      for var ArrayElement in JsonArray do
      begin
        if ArrayElement is TJSONObject then
          Result.AlternateFormatLocations.Add(TMimeTypedUri.Parse(TJSONObject(ArrayElement)));
      end;
    end;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Language, JsonString) then
      Result.Language := JsonString.Value;

  except
    Result.Free; raise;
  end;
end;

procedure TIdentification.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.ShortName, FShortName);
  JsonObject.AddStringOrNothing(TPropertyNames.LongName, FLongName);
  JsonObject.AddStringArray(TPropertyNames.Tags, FTags);
  JsonObject.AddObject(TPropertyNames.Publisher, FPublisher);
  JsonObject.AddStringOrNothing(TPropertyNames.Version, FVersion);
  JsonObject.AddStringArray(TPropertyNames.ChangeLog, FChangeLog);
  JsonObject.AddDateTimeOrNothing(TPropertyNames.PublishedAt, FPublishedAt);
  JsonObject.AddDateTimeOrNothing(TPropertyNames.ValidFrom, FValidFrom);
  JsonObject.AddDateTimeOrNothing(TPropertyNames.ValidTo, FValidTo);
  JsonObject.AddUriOrNothing(TPropertyNames.CanonicalUri, FCanonicalUri);
  JsonObject.AddUri(TPropertyNames.CanonicalVersionUri, FCanonicalVersionUri);
  JsonObject.AddUriArray(TPropertyNames.LocationUrls, FLocationUrls);
  JsonObject.AddObjectArray<TLocalizedUri>(TPropertyNames.AlternateLanguageLocations, FAlternateLanguageLocations);
  JsonObject.AddObjectArray<TMimeTypedUri>(TPropertyNames.AlternateFormatLocations, FAlternateFormatLocations);
  JsonObject.AddStringOrNothing(TPropertyNames.Language, FLanguage);
end;

end.

