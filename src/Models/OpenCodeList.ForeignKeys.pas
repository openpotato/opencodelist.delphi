{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.ForeignKeys;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.ObjectList,
  OpenCodeList.Column,
  OpenCodeList.ForeignKey;

type

  /// <summary>
  /// The foreign key definitions of a code list.
  /// </summary>
  TForeignKeys = class(TExtendedObjectList<TForeignKey>)
  private
    FDocument: TObject;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="TForeignKeys" />
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    constructor Create(Document: TObject; AOwnsObjects: Boolean = true);

    /// <summary>
    /// Parses a <see cref="TJSONArray"/> array into a new <see cref="TForeignKey"/> instances
    /// and adds them to the internal collection.
    /// </summary>
    /// <param name="JsonArrayToBeParsed">The json array</param>
    procedure ParseAndAdd(JsonArrayToBeParsed: TJSONArray);

    /// <summary>
    /// Removes all foreign keys with reference to a given column
    /// </summary>
    /// <param name="column">The column</param>
    procedure RemoveAll(Column: TColumn);

    /// <summary>
    /// Does a certain foreign key exist?
    /// </summary>
    /// <param name="ID">The ID of the foreign key</param>
    /// <returns>True, if found</returns>
    function Contains(const ID: string): Boolean; overload;

    /// <summary>
    /// Tries to find a <see cref="TForeignKey"/> instance by its ID.
    /// </summary>
    /// <param name="ID">The ID of the foreign key</param>
    /// <param name="ForeignKey">The found foreign key</param>
    /// <returns>True, if successfull</returns>
    function TryGet(const ID: string; out ForeignKey: TForeignKey): Boolean; overload;

  end;

implementation

uses
  OpenCodeList.CodeListDocument,
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TForeignKeys }

constructor TForeignKeys.Create(Document: TObject; AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
  FDocument := Document;
end;

procedure TForeignKeys.ParseAndAdd(JsonArrayToBeParsed: TJSONArray);
begin
  for var JsonValue in JsonArrayToBeParsed do
  begin
    if JsonValue is TJSONObject then
    begin
      Add(TForeignKey.Parse(FDocument, JsonValue as TJSONObject))
    end
  end;
end;

procedure TForeignKeys.RemoveAll(Column: TColumn);
begin
  if Count > 0 then
  begin
    for var I := Count - 1 to 0 do
    begin
      if Contains(function(ForeignKey: TForeignKey): Boolean
        begin
          Result := ForeignKey.Columns.Contains(Column);
        end)
      then
      begin
        Delete(I);
      end;
    end;
  end;
end;

function TForeignKeys.Contains(const ID: string): Boolean;
begin
  Result := Contains(
    function(ForeignKey: TForeignKey): Boolean
    begin
      Result := ForeignKey.ID = ID;
    end
  );
end;

function TForeignKeys.TryGet(const ID: string; out ForeignKey: TForeignKey): Boolean;
begin
  ForeignKey := Get(
    function(ForeignKey: TForeignKey): Boolean
    begin
      Result := ForeignKey.ID = ID;
    end
  );
  Result := ForeignKey <> nil;
end;

end.

