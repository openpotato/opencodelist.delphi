{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.ForeignKey;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.Columns,
  OpenCodeList.KeyRef;

type

  /// <summary>
  /// A foreign key definition.
  /// </summary>
  TForeignKey = class(TIdentifiableObject)
  private
    FDocument: TObject;
    FColumns: TColumns;
    FDescription: string;
    FName: string;
    FKeyRef: TKeyRef;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TForeignKey"/> instance.
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TForeignKey"/> instance</returns>
    class function Parse(Document: TObject; JsonObjectToBeParsed: TJSONObject): TForeignKey;

  public

    /// <summary>
    /// Initializes a new instance of the <see cref="TForeignKey"/> class.
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
    /// A list of column IDs in the current code list.
    /// </summary>
    property Columns: TColumns read FColumns;

    /// <summary>
    /// A short description of the foreign key.
    /// </summary>
    property Description: string read FDescription write FDescription;

    /// <summary>
    /// The name of the foreign key.
    /// </summary>
    property Name: string read FName write FName;

    /// <summary>
    /// Reference to the key in the external code list.
    /// </summary>
    property KeyRef: TKeyRef read FKeyRef write FKeyRef;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.JsonHelper;

{ TForeignKey }

constructor TForeignKey.Create(Document: TObject);
begin
  FDocument := Document;
  FColumns := TColumns.Create(Document, false);
end;

class function TForeignKey.Parse(Document: TObject; JsonObjectToBeParsed: TJSONObject): TForeignKey;
var
  JsonString: TJSONString;
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
begin
  Result := TForeignKey.Create(Document);
  try

    if JsonObjectToBeParsed.GetRequiredJsonString(TPropertyNames.Id, JsonString) then
      Result.Id := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Name, JsonString) then
      Result.Name := JsonString.Value;

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.Description, JsonString) then
      Result.Description := JsonString.Value;

    if JsonObjectToBeParsed.GetRequiredJsonArray(TPropertyNames.ColumnIds, JsonArray) then
      Result.Columns.ParseAndAdd(JsonArray);

    if JsonObjectToBeParsed.GetRequiredJsonObject(TPropertyNames.KeyRef, JsonObject) then
      Result.KeyRef := TKeyRef.Parse(JsonObject);

  except
    Result.Free; raise;
  end;
end;

procedure TForeignKey.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddString(TPropertyNames.Id, Id);
  JsonObject.AddStringOrNothing(TPropertyNames.Name, Name);
  JsonObject.AddStringOrNothing(TPropertyNames.Description, Description);
  JsonObject.AddColumnIdArray(TPropertyNames.ColumnIds, Columns);
  JsonObject.AddObject(TPropertyNames.KeyRef, FKeyRef);
end;

end.

