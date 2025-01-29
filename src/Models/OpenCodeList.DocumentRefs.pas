{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.DocumentRefs;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.ObjectList,
  OpenCodeList.DocumentRef,
  OpenCodeList.CodeListDocumentRef,
  OpenCodeList.CodeListSetDocumentRef;

type

  /// <summary>
  /// List of code list or code list set references.
  /// </summary>
  TDocumentRefs = class(TExtendedObjectList<TDocumentRef>)
  private
    FDocument: TObject;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="TDocumentRefs" />
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    constructor Create(Document: TObject; AOwnsObjects: Boolean = true);

    /// <summary>
    /// Parses a <see cref="TJSONArray"/> array into a new <see cref="TKey"/> instances
    /// and adds them to the internal collection.
    /// </summary>
    /// <param name="JsonArrayToBeParsed">The json array</param>
    procedure ParseAndAdd(JsonArrayToBeParsed: TJSONArray);

  end;

implementation

uses
  OpenCodeList.CodeListParserException,
  OpenCodeList.CodeListDocument,
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TDocumentRefs }

constructor TDocumentRefs.Create(Document: TObject; AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
  FDocument := Document;
end;

procedure TDocumentRefs.ParseAndAdd(JsonArrayToBeParsed: TJSONArray);
var
  JsonValue: TJSONValue;
  JsonString: TJSONString;
  JsonObject: TJSONObject;
begin
  for JsonValue in JsonArrayToBeParsed do
  begin
    if JsonValue is TJSONObject then
    begin
      JsonObject := JsonValue as TJSONObject;
      if JsonObject.GetRequiredJsonString(TPropertyNames.Type, JsonString) then
      begin
        if JsonString.Value = TTypeConsts.CodeListRef then
          Add(TCodeListDocumentRef.Parse(JsonObject))
        else if JsonString.Value = TTypeConsts.CodeListSetRef then
          Add(TCodeListSetDocumentRef.Parse(JsonObject))
        else
          raise ECodeListParserException.CreateFmt('Unknown column type "%s".', [JsonString.Value]);
      end else
        raise ECodeListParserException.Create('Type property is missing.');
    end
  end;
end;

end.

