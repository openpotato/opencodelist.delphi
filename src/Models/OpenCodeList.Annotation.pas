{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Annotation;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  OpenCodeList.BaseObjects,
  OpenCodeList.Description;

type

  /// <summary>
  /// Custom user annotation information.
  /// </summary>
  TAnnotation = class(TBaseObject)
  private
    FDescriptions: TObjectList<TDescription>;
    FAppInfo: TJSONObject;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TAnnotation"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TAnnotation"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TAnnotation;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TAnnotation" />
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
    /// Human-readable descriptions.
    /// </summary>
    property Descriptions: TObjectList<TDescription> read FDescriptions;

    /// <summary>
    /// Machine-readable information.
    /// </summary>
    property AppInfo: TJSONObject read FAppInfo write FAppInfo;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.JsonHelper;

{ TAnnotation }

constructor TAnnotation.Create;
begin
  FDescriptions := TObjectList<TDescription>.Create(true);
end;

destructor TAnnotation.Destroy;
begin
  FDescriptions.Free;
  FAppInfo.Free;
  inherited;
end;

class function TAnnotation.Parse(JsonObjectToBeParsed: TJSONObject): TAnnotation;
var
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
begin
  Result := TAnnotation.Create;
  try

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.Descriptions, JsonArray) then
    begin
      for var ArrayElement in JsonArray do
      begin
        if ArrayElement is TJSONObject then
          Result.Descriptions.Add(TDescription.Parse(ArrayElement as TJSONObject));
      end;
    end;

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.AppInfo, JsonObject) then
      Result.AppInfo := JsonObject.Clone as TJSONObject;

  except
    Result.Free; raise;
  end;
end;

procedure TAnnotation.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddObjectArray<TDescription>(TPropertyNames.Descriptions, FDescriptions);
  JsonObject.AddObject(TPropertyNames.AppInfo, FAppInfo.Clone as TJSONObject);
end;

end.

