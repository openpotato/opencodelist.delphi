{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.JsonReaderHelper;

interface

uses
  System.JSON, System.SysUtils;

type
  ECodeListParserException = class(Exception);

  TJsonReaderHelper = class helper for TJSONObject
  public

    function GetRequiredArrayProperty(const PropertyName: string; out JsonArray: TJSONArray): Boolean;
    function GetRequiredObjectProperty(const PropertyName: string; out JsonObjectValue: TJSONObject): Boolean;
    function GetRequiredStringProperty(const PropertyName: string; out StringValue: string): Boolean;

    function TryGetArrayProperty(const PropertyName: string; out JsonArray: TJSONArray): Boolean;
    function TryGetBooleanProperty(const PropertyName: string; out BoolValue: Boolean): Boolean;
    function TryGetObjectProperty(const PropertyName: string; out JsonObjectValue: TJSONObject): Boolean;
    function TryGetStringProperty(const PropertyName: string; out StringValue: string): Boolean;

  end;

implementation

{ TJsonReaderHelper }

function TJsonReaderHelper.GetRequiredArrayProperty(const PropertyName: string; out JsonArray: TJSONArray): Boolean;
begin
  if TryGetArrayProperty(PropertyName, JsonArray) then
    Result := True
  else
    raise ECodeListParserException.CreateFmt('Required property "%s" not found.', [PropertyName]);
end;

function TJsonReaderHelper.GetRequiredObjectProperty(const PropertyName: string; out JsonObjectValue: TJSONObject): Boolean;
begin
  if TryGetObjectProperty(PropertyName, JsonObjectValue) then
    Result := True
  else
    raise ECodeListParserException.CreateFmt('Required property "%s" not found.', [PropertyName]);
end;

function TJsonReaderHelper.GetRequiredStringProperty(const PropertyName: string; out StringValue: string): Boolean;
begin
  if TryGetStringProperty(PropertyName, StringValue) then
    Result := True
  else
    raise ECodeListParserException.CreateFmt('Required property "%s" not found.', [PropertyName]);
end;

function TJsonReaderHelper.TryGetArrayProperty(const PropertyName: string; out JsonArray: TJSONArray): Boolean;
var
  JsonValue: TJSONValue;
begin
  JsonArray := nil;
  if TryGetValue(PropertyName, JsonValue) then
  begin
    if (JsonValue is TJSONArray) then
    begin
      JsonArray := TJSONArray(JsonValue);
      Result := True;
    end else
      raise ECodeListParserException.CreateFmt('Property "%s" must be a JSON array.', [PropertyName]);
  end else
    Result := False;
end;

function TJsonReaderHelper.TryGetBooleanProperty(const PropertyName: string; out BoolValue: Boolean): Boolean;
var
  JsonValue: TJSONValue;
begin
  BoolValue := False;
  if TryGetValue(PropertyName, JsonValue) then
  begin
    if (JsonValue is TJSONBool) then
    begin
      BoolValue := TJSONBool(JsonValue).AsBoolean;
      Result := True;
    end else
      raise ECodeListParserException.CreateFmt('Property "%s" must be a JSON Boolean.', [PropertyName]);
  end else
    Result := False;
end;

function TJsonReaderHelper.TryGetObjectProperty(const PropertyName: string; out JsonObjectValue: TJSONObject): Boolean;
var
  JsonValue: TJSONValue;
begin
  JsonObjectValue := nil;
  if TryGetValue(PropertyName, JsonValue) then
  begin
    if (JsonValue is TJSONObject) then
    begin
      JsonObjectValue := TJSONObject(JsonValue);
      Result := True;
    end else
      raise ECodeListParserException.CreateFmt('Property "%s" must be a JSON object.', [PropertyName]);
  end else
    Result := False;
end;

function TJsonReaderHelper.TryGetStringProperty(const PropertyName: string; out StringValue: string): Boolean;
var
  JsonValue: TJSONValue;
begin
  StringValue := '';
  if TryGetValue(PropertyName, JsonValue) then
  begin
    if (JsonValue is TJSONString) then
    begin
      StringValue := TJSONString(JsonValue).Value;
      Result := True;
    end else
    raise ECodeListParserException.CreateFmt('Property "%s" must be a JSON string.', [PropertyName]);
  end else
    Result := False;
end;

end.

