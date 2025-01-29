{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.CodeListSetDocument;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.JSON,
  System.SysUtils,
  OpenCodeList.Annotation,
  OpenCodeList.Document,
  OpenCodeList.DocumentRef,
  OpenCodeList.DocumentRefs,
  OpenCodeList.Identification;

type

  /// <summary>
  /// A code list set document according to the OpenCodeList specification.
  /// </summary>
  TCodeListSetDocument = class(TDocument)
  private
    FDocumentRefs: TDocumentRefs;
  public

    /// <summary>
    /// Parses a JSON document into a TCodeListDocument instance.
    /// </summary>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TCodeListSetDocument;

    /// <summary>
    /// Parses a JSON document into a TCodeListDocument instance.
    /// </summary>
    class function ParseContent(JsonRootToBeParsed, JsonObjectToBeParsed: TJSONObject): TCodeListSetDocument;

    /// <summary>
    /// Loads a new code list from a stream.
    /// </summary>
    class function LoadFromStream(Stream: TStream): TCodeListSetDocument;

    /// <summary>
    /// Loads a new code list from a file.
    /// </summary>
    class function LoadFromFile(const FilePath: string): TCodeListSetDocument;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TCodeListSetDocument" />
    /// </summary>
    constructor Create;

    /// <summary>
    /// Clean up resources
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Clears the metadata and content of this document instance.
    /// </summary>
    procedure Clear; override;

    /// <summary>
    /// Clears only the content of this document instance.
    /// </summary>
    procedure ClearContent(ConvertToMetaOnly: Boolean); override;

    /// <summary>
    /// Saves this document to a stream according to the OpenCodeList JSON schema
    /// specification.
    /// </summary>
    /// <param name="Stream">The output stream</param>
    /// <param name="Indented">Should the JSON serialisation be indented?</param>
    procedure SaveToStream(Stream: TStream; Indented: Boolean); override;

  public

    /// <summary>
    /// The refrences set of the code list set.
    /// </summary>
    property DocumentRefs: TDocumentRefs read FDocumentRefs;

  end;

implementation

uses
  OpenCodeList.CodeListParserException,
  OpenCodeList.SemanticVersion,
  OpenCodeList.PropertyNames,
  OpenCodeList.JsonHelper;

{ TCodeListSetDocument }

constructor TCodeListSetDocument.Create;
begin
  inherited Create;
  FDocumentRefs := TDocumentRefs.Create(Self);
end;

destructor TCodeListSetDocument.Destroy;
begin
  FDocumentRefs.Free;
  inherited;
end;

procedure TCodeListSetDocument.Clear;
begin
  inherited Clear;
end;

procedure TCodeListSetDocument.ClearContent(ConvertToMetaOnly: Boolean);
begin
  FDocumentRefs.Clear();
  inherited ClearContent(ConvertToMetaOnly);
end;

procedure TCodeListSetDocument.SaveToStream(Stream: TStream; Indented: Boolean);

  function CreateCodeListSetJson: TJSONObject;
  begin
    Result := TJSONObject.Create;
    try
      Result.AddObject(TPropertyNames.Annotation, Annotation);
      Result.AddObject(TPropertyNames.Identification, Identification);
      if not MetaOnly then
      begin
        Result.AddObjectArray<TDocumentRef>(TPropertyNames.ReferenceSet, FDocumentRefs);
      end;
    except
      Result.Free; raise;
    end;
  end;

var
  JsonObject: TJSONObject;
  Writer: TStreamWriter;
begin
  Writer := TStreamWriter.Create(Stream);
  try
    JsonObject := TJSONObject.Create;
    try

      JsonObject.AddString(TPropertyNames.OpenCodeList, GetVersion.ToString);
      JsonObject.AddStringArray(TPropertyNames.Comments, Comments);
      JsonObject.AddObject(TPropertyNames.CodeListSet, CreateCodeListSetJson);

      if Indented then
        Writer.Write(JsonObject.Format(2))
      else
        Writer.Write(JsonObject.ToString);

    finally
      JsonObject.Free;
    end;
  finally
    Writer.Free;
  end;
end;

class function TCodeListSetDocument.LoadFromStream(Stream: TStream): TCodeListSetDocument;
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

class function TCodeListSetDocument.LoadFromFile(const FilePath: string): TCodeListSetDocument;
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FilePath, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadFromStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

class function TCodeListSetDocument.Parse(JsonObjectToBeParsed: TJSONObject): TCodeListSetDocument;
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

  if JsonObjectToBeParsed.GetRequiredJsonObject(TPropertyNames.CodeListSet, JsonObject) then
  begin
    Result := ParseContent(JsonObjectToBeParsed, JsonObject);
  end else
    raise ECodeListParserException.CreateFmt('JSON Property "%s" missing.', [TPropertyNames.CodeListSet]);

end;

class function TCodeListSetDocument.ParseContent(JsonRootToBeParsed, JsonObjectToBeParsed: TJSONObject): TCodeListSetDocument;
var
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
begin
  Result := TCodeListSetDocument.Create;
  try

    if JsonRootToBeParsed.GetRequiredJsonArray(TPropertyNames.Comments, JsonArray) then
    begin
      for var ArrayElement in JsonArray do
      begin
        if ArrayElement is TJSONString then
          Result.Comments.Add((ArrayElement as TJSONString).Value);
      end;
    end;

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.Annotation, JsonObject) then
      Result.Annotation := TAnnotation.Parse(JsonObject);

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.Identification, JsonObject) then
      Result.Identification := TIdentification.Parse(JsonObject);

    if JsonObjectToBeParsed.TryGetJsonArray(TPropertyNames.ReferenceSet, JsonArray) then
    begin
      Result.DocumentRefs.ParseAndAdd(JsonArray);
    end else
      Result.ClearContent(true);

  except
    Result.Free; raise;
  end;
end;

end.

