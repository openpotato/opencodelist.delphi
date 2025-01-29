{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.KeyRef;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  OpenCodeList.BaseObjects,
  OpenCodeList.CodeListDocumentRef;

type

  /// <summary>
  /// Reference to a key in an external code list.
  /// </summary>
  TKeyRef = class(TBaseObject)
  private
    FCodeListRef: TCodeListDocumentRef;
    FKeyId: string;
  public

    /// <summary>
    /// Parses a JSON object into a new <see cref="TKeyRef"/> instance.
    /// </summary>
    /// <param name="JsonObjectToBeParsed">The JSON object</param>
    /// <returns>A new <see cref="TKeyRef"/> instance</returns>
    class function Parse(JsonObjectToBeParsed: TJSONObject): TKeyRef;

  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); override;

  public

    /// <summary>
    /// Reference to an external code list.
    /// </summary>
    property CodeListRef: TCodeListDocumentRef read FCodeListRef write FCodeListRef;

    /// <summary>
    /// Reference to a key ID in the external code list.
    /// </summary>
    property KeyId: string read FKeyId write FKeyId;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.JsonHelper;

{ TKeyRef }

class function TKeyRef.Parse(JsonObjectToBeParsed: TJSONObject): TKeyRef;
var
  JsonString: TJSONString;
  JsonObject: TJSONObject;
begin
  Result := TKeyRef.Create;
  try

    if JsonObjectToBeParsed.TryGetJsonObject(TPropertyNames.CodeListRef, JsonObject) then
      Result.CodeListRef := TCodeListDocumentRef.Parse(JsonObject);

    if JsonObjectToBeParsed.TryGetJsonString(TPropertyNames.KeyId, JsonString) then
      Result.KeyId := JsonString.Value;

  except
    Result.Free; raise;
  end;
end;

procedure TKeyRef.WriteTo(JsonObject: TJSONObject);
begin
  JsonObject.AddObject(TPropertyNames.CodeListRef, FCodeListRef);
  JsonObject.AddStringOrNothing(TPropertyNames.KeyId, FKeyId);
end;

end.

