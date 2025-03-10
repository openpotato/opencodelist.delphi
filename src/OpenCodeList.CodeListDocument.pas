{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.CodeListDocument;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.JSON,
  System.SysUtils,
  OpenCodeList.ObjectList,
  OpenCodeList.Document,
  OpenCodeList.Annotation,
  OpenCodeList.Identification,
  OpenCodeList.Column,
  OpenCodeList.Columns,
  OpenCodeList.BooleanColumn,
  OpenCodeList.StringColumn,
  OpenCodeList.Key,
  OpenCodeList.Keys,
  OpenCodeList.ForeignKey,
  OpenCodeList.ForeignKeys,
  OpenCodeList.Row,
  OpenCodeList.Rows;

type

  /// <summary>
  /// A code list document according to the OpenCodeList specification.
  /// </summary>
  TCodeListDocument = class(TDocument)
  private
    FColumns: TColumns;
    FKeys: TKeys;
    FForeignKeys: TForeignKeys;
    FRows: TRows;
    FDefaultKey: TKey;
  public

    /// <summary>
    /// Parses a JSON document into a TCodeListDocument instance.
    /// </summary>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TCodeListDocument;

    /// <summary>
    /// Parses a JSON document into a TCodeListDocument instance.
    /// </summary>
    class function ParseContent(JsonRootToBeParsed, JsonObjectToBeParsed: TJSONObject): TCodeListDocument;

    /// <summary>
    /// Loads a new code list from a stream.
    /// </summary>
    class function LoadFromStream(Stream: TStream): TCodeListDocument;

    /// <summary>
    /// Loads a new code list from a file.
    /// </summary>
    class function LoadFromFile(const FilePath: string): TCodeListDocument;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TCodeListDocument" />
    /// </summary>
    constructor Create;

    /// <summary>
    /// Cleans up resources
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Clears the metadata and content of this document instance.
    /// </summary>
    procedure Clear; override;

    /// <summary>
    /// Clears content of the document only.
    /// </summary>
    /// <param name="convertToMetaOnly">If TRUE, marks document as meta document</param>
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
    /// The column set of the code list.
    /// </summary>
    property Columns: TColumns read FColumns;

    /// <summary>
    /// The default key of the code list.
    /// </summary>
    property DefaultKey: TKey read FDefaultKey write FDefaultKey;

    /// <summary>
    /// List of keys.
    /// </summary>
    property Keys: TKeys read FKeys;

    /// <summary>
    /// List of foreign keys.
    /// </summary>
    property ForeignKeys: TForeignKeys read FForeignKeys;

    /// <summary>
    /// The data rows of the code list.
    /// </summary>
    property Rows: TRows read FRows;

  end;

implementation

uses
  OpenCodeList.CodeListParserException,
  OpenCodeList.SemanticVersion,
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TCodeListDocument }

constructor TCodeListDocument.Create;
begin
  inherited Create;
  FColumns := TColumns.Create(Self);
  FKeys := TKeys.Create(Self);
  FForeignKeys := TForeignKeys.Create(Self);
  FRows := TRows.Create(Self);
  FDefaultKey := nil;
end;

destructor TCodeListDocument.Destroy;
begin
  FColumns.Free;
  FKeys.Free;
  FForeignKeys.Free;
  FRows.Free;
  inherited;
end;

procedure TCodeListDocument.Clear;
begin
  inherited Clear;
  FDefaultKey := nil;
  FColumns.Clear;
  FKeys.Clear;
  FForeignKeys.Clear;
end;

procedure TCodeListDocument.ClearContent(ConvertToMetaOnly: Boolean);
begin
  FRows.Clear;
  inherited ClearContent(ConvertToMetaOnly);
end;

procedure TCodeListDocument.SaveToStream(Stream: TStream; Indented: Boolean);

  function CreateDataSetJson: TJSONObject;
  begin
    Result := TJSONObject.Create;
    try
      Result.AddObjectArray<TRow>(TPropertyNames.Rows, Rows);
    except
      Result.Free; raise;
    end;
  end;

  function CreateColumnSetJson: TJSONObject;
  begin
    Result := TJSONObject.Create;
    try
      Result.AddObjectArray<TColumn>(TPropertyNames.Columns, Columns);
      Result.AddObjectArray<TKey>(TPropertyNames.Keys, Keys);
      Result.AddObject(TPropertyNames.DefaultKey, Defaultkey);
      Result.AddObjectArray<TForeignKey>(TPropertyNames.ForeignKeys, ForeignKeys);
    except
      Result.Free; raise;
    end;
  end;

  function CreateCodeListJson: TJSONObject;
  begin
    Result := TJSONObject.Create;
    try
      Result.AddObject(TPropertyNames.Annotation, Annotation);
      Result.AddObject(TPropertyNames.Identification, Identification);
      Result.AddObject(TPropertyNames.ColumnSet, CreateColumnSetJson);
      if not MetaOnly then
      begin
        Result.AddObject(TPropertyNames.DataSet, CreateDataSetJson);
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
      JsonObject.AddObject(TPropertyNames.CodeList, CreateCodeListJson);

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

class function TCodeListDocument.LoadFromStream(Stream: TStream): TCodeListDocument;
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

class function TCodeListDocument.LoadFromFile(const FilePath: string): TCodeListDocument;
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

class function TCodeListDocument.Parse(JsonObjectToBeParsed: TJSONObject): TCodeListDocument;
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

  if JsonObjectToBeParsed.GetRequiredJsonObject(TPropertyNames.CodeList, JsonObject) then
  begin
    Result := ParseContent(JsonObjectToBeParsed, JsonObject);
  end else
    raise ECodeListParserException.CreateFmt('JSON Property "%s" missing.', [TPropertyNames.CodeList]);

end;

class function TCodeListDocument.ParseContent(JsonRootToBeParsed, JsonObjectToBeParsed: TJSONObject): TCodeListDocument;
var
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
  JsonString: TJSONString;
  Key: TKey;
begin
  Result := TCodeListDocument.Create;
  try

    if JsonRootToBeParsed.TryGetJsonArray(TPropertyNames.Comments, JsonArray) then
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

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.ColumnSet, JsonObject) then
    begin
      if JsonObject.TryGetJsonArray(TPropertyNames.Columns, JsonArray) then
      begin
        Result.Columns.ParseAndAdd(JsonArray);
      end;
      if JsonObject.TryGetJsonArray(TPropertyNames.Keys, JsonArray) then
      begin
        Result.Keys.ParseAndAdd(JsonArray);
      end;
      if JsonObject.TryGetJsonArray(TPropertyNames.ForeignKeys, JsonArray) then
      begin
        Result.ForeignKeys.ParseAndAdd(JsonArray);
      end;
      if JsonObject.TryGetJsonObject(TPropertyNames.DefaultKey, JsonObject) then
      begin
        if JsonObject.TryGetJsonString(TPropertyNames.KeyId, JsonString) then
        begin
          if Result.Keys.TryGet(JsonString.Value, Key) then
            Result.DefaultKey := Key
          else
            raise ECodeListParserException.CreateFmt('Key Id "%s" not found.', [JsonString.Value]);
        end;
      end;
    end;

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.DataSet, JsonObject) then
    begin
      if JsonObject.TryGetJsonArray(TPropertyNames.Rows, JsonArray) then
      begin
        Result.Rows.ParseAndAdd(JsonArray);
      end;
    end else
      Result.ClearContent(true);

  except
    Result.Free; raise;
  end;
end;

end.

