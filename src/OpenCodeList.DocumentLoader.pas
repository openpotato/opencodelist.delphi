{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.DocumentLoader;

interface

uses
  System.Classes,
  System.JSON,
  System.SysUtils,
  OpenCodeList.Document;

type

  /// <summary>
  /// A generic OpenCodeList document loader
  /// </summary>
  TDocumentLoader = class
  private

    /// <summary>
    /// Parses a <see cref="TJSONObject"/> object into a document.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>Either a new <see cref="TCodeListDocument"/> or a new <see cref="TCodeListSetDocument"/> instance</returns>
    /// <exception cref="ECodeListParserException">Syntax error</exception>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TDocument;

  public

    /// <summary>
    /// Loads a new document from a stream. The stream data must be formtted according to the
    /// OpenCodeList JSON schema specification.
    /// </summary>
    /// <param name="Stream">The input stream</param>
    /// <returns>Either a new <see cref="TCodeListDocument"/> or a new <see cref="TCodeListSetDocument"/> instance</returns>
    class function LoadFromStream(Stream: TStream): TDocument;

    /// <summary>
    /// Loads a new document from a file. The stream data must be formtted according to the
    /// OpenCodeList JSON schema specification.
    /// </summary>
    /// <param name="FileName">The file path</param>
    /// <returns>Either a new <see cref="TCodeListDocument"/> or a new <see cref="TCodeListSetDocument"/> instance</returns>
    class function LoadFromFile(const FileName: string): TDocument;

  end;

implementation

uses
  OpenCodeList.CodeListDocument,
  OpenCodeList.CodeListSetDocument,
  OpenCodeList.CodeListParserException,
  OpenCodeList.SemanticVersion,
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TDocumentLoader }

class function TDocumentLoader.LoadFromStream(Stream: TStream): TDocument;
var
  JsonObject: TJSONObject;
  Reader: TStreamReader;
begin
  Reader := TStreamReader.Create(Stream, TEncoding.UTF8);
  try
    JsonObject := TJSONObject.ParseJSONValue(Reader.ReadToEnd) as TJSONObject;
    if JsonObject <> nil then
    begin
      try
        Result := Parse(JsonObject);
      finally
        JsonObject.Free;
      end
    end else
      raise ECodeListParserException.Create('Invalid JSON document.');
  finally
    Reader.Free;
  end;
end;

class function TDocumentLoader.LoadFromFile(const FileName: string): TDocument;
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

class function TDocumentLoader.Parse(JsonObjectToBeParsed: TJSONObject): TDocument;
var
  JsonString: TJSONString;
  JsonObject: TJSONObject;
begin

  if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.OpenCodeList, JsonString) then
  begin
    if TDocument.GetVersion.CompareTo(JsonString.Value) <> 0 then
      raise ECodeListParserException.CreateFmt('Version %s of OpenCodeList not supported.', [JsonString.Value]);
  end else
    raise ECodeListParserException.CreateFmt('JSON Property "%s" missing.', [TPropertyNames.OpenCodeList]);

  if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.CodeList, JsonObject) then
  begin
    Result := TCodeListDocument.ParseContent(JsonObjectToBeParsed, JsonObject);
  end else
  if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.CodeListSet, JsonObject) then
  begin
    Result := TCodeListSetDocument.ParseContent(JsonObjectToBeParsed, JsonObject);
  end else
    raise ECodeListParserException.CreateFmt('JSON Property "%s" or "%s" missing.', [TPropertyNames.CodeList, TPropertyNames.CodeListSet]);

end;

end.

