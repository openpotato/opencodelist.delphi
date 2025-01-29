{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Key;

interface

uses
  System.SysUtils,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.Nullable,
  OpenCodeList.Columns;

type

  /// <summary>
  /// A key definition.
  /// </summary>
  TKey = class(TIdentifiableObject)
  private
    FDocument: TObject;
    FName: Nullable<string>;
    FDescription: Nullable<string>;
    FColumns: TColumns;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TKey"/> instance.
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TKey"/> instance</returns>
    class function Parse(Document: TObject; JsonObjectToBeParsed: TJSONObject): TKey;

  public

    /// <summary>
    /// Initializes a new instance of the <see cref="TKey"/> class.
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    constructor Create(Document: TObject);

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// The name of the key.
    /// </summary>
    property Name: Nullable<string> read FName write FName;

    /// <summary>
    /// A brief description of the key.
    /// </summary>
    property Description: Nullable<string> read FDescription write FDescription;

    /// <summary>
    /// A list of referenced columns.
    /// </summary>
    property Columns: TColumns read FColumns;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.JsonHelper;

{ TKey }

constructor TKey.Create(Document: TObject);
begin
  FDocument := Document;
  FColumns := TColumns.Create(FDocument, false);
end;

class function TKey.Parse(Document: TObject; JsonObjectToBeParsed: TJSONObject): TKey;
var
  JsonString: TJSONString;
  JsonArray: TJSONArray;
begin
  Result := TKey.Create(Document);
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Id, JsonString) then
      Result.Id := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Name, JsonString) then
      Result.Name := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Description, JsonString) then
      Result.Description := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.ColumnIds, JsonArray) then
      Result.Columns.ParseAndAdd(JsonArray);

  except
    Result.Free; raise;
  end;
end;

procedure TKey.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Id, Id);
  JsonObject.AddStringOrNothing(TPropertyNames.Name, Name);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, Description);
  JsonObject.AddColumnIdArray(TPropertyNames.ColumnIds, Columns);
end;

end.

