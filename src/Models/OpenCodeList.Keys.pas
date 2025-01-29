{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Keys;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.ObjectList,
  OpenCodeList.Column,
  OpenCodeList.Key;

type

  /// <summary>
  /// The key definitions of a code list.
  /// </summary>
  TKeys = class(TExtendedObjectList<TKey>)
  private
    FDocument: TObject;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="TKeys" />
    /// </summary>
    /// <param name="Document">Reference to a <see cref="TCodeListDocument"/> instance</param>
    constructor Create(Document: TObject; AOwnsObjects: Boolean = true);

    /// <summary>
    /// Parses a <see cref="TJSONArray"/> array into a new <see cref="TKey"/> instances
    /// and adds them to the internal collection.
    /// </summary>
    /// <param name="JsonArrayToBeParsed">The json array</param>
    procedure ParseAndAdd(JsonArrayToBeParsed: TJSONArray);

    /// <summary>
    /// Removes all keys with reference to a given column
    /// </summary>
    /// <param name="column">The column</param>
    procedure RemoveAll(Column: TColumn);

    /// <summary>
    /// Does a certain key exist?
    /// </summary>
    /// <param name="ID">The ID of the foreign key</param>
    /// <returns>True, if found</returns>
    function Contains(const ID: string): Boolean; overload;

    /// <summary>
    /// Tries to find a <see cref="TKey"/> instance by its ID.
    /// </summary>
    /// <param name="ID">The ID of the key</param>
    /// <param name="Key">The found key</param>
    /// <returns>True, if successfull</returns>
    function TryGet(const ID: string; out Key: TKey): Boolean; overload;

  end;

implementation

uses
  OpenCodeList.CodeListDocument,
  OpenCodeList.PropertyNames,
  OpenCodeList.TypeConsts,
  OpenCodeList.JsonHelper;

{ TKeys }

constructor TKeys.Create(Document: TObject; AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
  FDocument := Document;
end;

procedure TKeys.ParseAndAdd(JsonArrayToBeParsed: TJSONArray);
begin
  for var JsonValue in JsonArrayToBeParsed do
  begin
    if JsonValue is TJSONObject then
    begin
      Add(TKey.Parse(FDocument, JsonValue as TJSONObject))
    end
  end;
end;

procedure TKeys.RemoveAll(Column: TColumn);
begin
  if Count > 0 then
  begin
    for var I := Count - 1 to 0 do
    begin
      if Contains(function(Key: TKey): Boolean
        begin
          Result := Key.Columns.Contains(Column);
        end)
      then
      begin
        Delete(I);
      end;
    end;
  end;
end;

function TKeys.Contains(const ID: string): Boolean;
begin
  Result := Contains(
    function(Key: TKey): Boolean
    begin
      Result := Key.ID = ID;
    end
  );
end;

function TKeys.TryGet(const ID: string; out Key: TKey): Boolean;
begin
  Key := Get(
    function(Key: TKey): Boolean
    begin
      Result := Key.ID = ID;
    end
  );
  Result := Key <> nil;
end;

end.

