{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Description;

interface

uses
  System.JSON,
  System.SysUtils,
  OpenCodeList.Nullable,
  OpenCodeList.BaseObjects;

type

  /// <summary>
  /// Human-readable description
  /// </summary>
  TDescription = class(TBaseObject)
  private
    FContent: string;
    FFormat: string;
    FLanguage: Nullable<string>;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TDescription"/>  instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    /// <returns>A new <see cref="TDescription"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TDescription;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// The description itself
    /// </summary>
    property Content: string read FContent write FContent;

    /// <summary>
    /// Format of the description.
    /// </summary>
    property Format: string read FFormat write FFormat;

    /// <summary>
    /// A language tag according to https://www.rfc-editor.org/rfc/bcp/bcp47.txt to specify the language of the comment.
    /// </summary>
    property Language: Nullable<string> read FLanguage write FLanguage;

  end;

implementation

uses
  OpenCodeList.PropertyNames, OpenCodeList.JsonHelper;

{ TDescription }

class function TDescription.Parse(JsonObjectToBeParsed: TJSONObject): TDescription;
var
  JsonString: TJSONString;
begin
  Result := TDescription.Create;
  try

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Language, JsonString) then
      Result.Language := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Format, JsonString) then
      Result.Format := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Content, JsonString) then
      Result.Content := JsonString.Value;

  except
    Result.Free; raise;
  end;
end;

procedure TDescription.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddStringOrNothing(TPropertyNames.Language, FLanguage);
  JsonObject.AddString(TPropertyNames.Format, FFormat);
  JsonObject.AddString(TPropertyNames.Content, FContent);
end;

end.

