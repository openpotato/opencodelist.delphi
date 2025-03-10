{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.JsonHelper;

interface

uses
  System.Classes,
  System.DateUtils,
  System.Generics.Collections,
  System.Net.URLClient,
  System.JSON,
  System.SysUtils,
  OpenCodeList.Nullable,
  OpenCodeList.BaseObjects,
  OpenCodeList.Columns,
  OpenCodeList.EnumMember;

type

  /// <summary>
  /// Helper methods for <see cref="TJSONObject"/>
  /// </summary>
  TJsonObjectHelper = class helper for TJSONObject
  public

    procedure AddString(const PropertyName, Value: string);
    procedure AddStringOrNothing(const PropertyName: string; const NullableValue: Nullable<string>);
    procedure AddBoolean(const PropertyName: string; Value: Boolean);
    procedure AddBooleanOrNothing(const PropertyName: string; const NullableValue: Nullable<Boolean>);
    procedure AddInteger(const PropertyName: string; Value: Integer);
    procedure AddIntegerOrNothing(const PropertyName: string; const NullableValue: Nullable<Integer>);
    procedure AddDouble(const PropertyName: string; const Value: Double);
    procedure AddDoubleOrNothing(const PropertyName: string; const NullableValue: Nullable<Double>);
    procedure AddDateTime(const PropertyName: string; const Value: TDateTime); overload;
    procedure AddDateTimeOrNothing(const PropertyName: string; const NullableValue: Nullable<TDateTime>); overload;
    procedure AddDateOnly(const PropertyName: string; const Value: TDate); overload;
    procedure AddDateOnlyOrNothing(const PropertyName: string; const NullableValue: Nullable<TDate>); overload;
    procedure AddTimeOnly(const PropertyName: string; const Value: TTime); overload;
    procedure AddTimeOnlyOrNothing(const PropertyName: string; const NullableValue: Nullable<TTime>); overload;
    procedure AddUri(const PropertyName: string; Value: TUri);
    procedure AddUriOrNothing(const PropertyName: string; const NullableValue: Nullable<TUri>);
    procedure AddUriArray(const PropertyName: string; List: TList<TUri>);
    procedure AddUriArrayOrNothing(const PropertyName: string; List: TList<TUri>);
    procedure AddStringList(const PropertyName: string; List: TStrings);
    procedure AddStringListOrNothing(const PropertyName: string; List: TStrings);
    procedure AddStringArray(const PropertyName: string; List: TList<string>);
    procedure AddStringArrayOrNothing(const PropertyName: string; List: TList<string>);
    procedure AddObject(const PropertyName: string; const AnObject: TJSONObject); overload;
    procedure AddObject<T: TBaseObject>(const PropertyName: string; Value: T); overload;
    procedure AddObjectArray(const PropertyName: string; List: TJSONArray); overload;
    procedure AddObjectArray<T: TBaseObject>(const PropertyName: string; List: TList<T>); overload;
    procedure AddColumnIdArray(const PropertyName: string; Columns: TColumns);
    procedure AddEnumMemberArray(const PropertyName: string; List: TList<TEnumMember>);

    function GetRequiredJsonString(const PropertyName: string; out StringValue: TJSONString): Boolean;
    function GetRequiredJsonObject(const PropertyName: string; out JsonObjectValue: TJSONObject): Boolean;
    function GetRequiredJsonArray(const PropertyName: string; out JsonArray: TJSONArray): Boolean;

    function TryGetJsonString(const PropertyName: string; out StringValue: TJSONString): Boolean;
    function TryGetJsonBool(const PropertyName: string; out BoolValue: TJSONBool): Boolean;
    function TryGetJsonNumber(const PropertyName: string; out NumberValue: TJSONNumber): Boolean;
    function TryGetJsonObject(const PropertyName: string; out JsonObjectValue: TJSONObject): Boolean;
    function TryGetJsonArray(const PropertyName: string; out JsonArray: TJSONArray): Boolean;

  end;

implementation

uses
  OpenCodeList.CodeListParserException;

{ TJsonHelper }

procedure TJsonObjectHelper.AddString(const PropertyName, Value: string);
begin
  AddPair(PropertyName, Value);
end;

procedure TJsonObjectHelper.AddStringOrNothing(const PropertyName: string; const NullableValue: Nullable<string>);
begin
  if NullableValue.HasValue then AddString(PropertyName, NullableValue.Value);
end;

procedure TJsonObjectHelper.AddBoolean(const PropertyName: string; Value: Boolean);
begin
  AddPair(PropertyName, Value);
end;

procedure TJsonObjectHelper.AddBooleanOrNothing(const PropertyName: string; const NullableValue: Nullable<Boolean>);
begin
  if NullableValue.HasValue then AddBoolean(PropertyName, NullableValue.Value);
end;

procedure TJsonObjectHelper.AddInteger(const PropertyName: string; Value: Integer);
begin
  AddPair(PropertyName, Value);
end;

procedure TJsonObjectHelper.AddIntegerOrNothing(const PropertyName: string; const NullableValue: Nullable<Integer>);
begin
  if NullableValue.HasValue then AddInteger(PropertyName, NullableValue.Value);
end;

procedure TJsonObjectHelper.AddDouble(const PropertyName: string; const Value: Double);
begin
  AddPair(PropertyName, Value);
end;

procedure TJsonObjectHelper.AddDoubleOrNothing(const PropertyName: string; const NullableValue: Nullable<Double>);
begin
  if NullableValue.HasValue then AddDouble(PropertyName, NullableValue.Value);
end;

procedure TJsonObjectHelper.AddDateTime(const PropertyName: string; const Value: TDateTime);
begin
  AddPair(PropertyName, DateToISO8601(Value));
end;

procedure TJsonObjectHelper.AddDateTimeOrNothing(const PropertyName: string; const NullableValue: Nullable<TDateTime>);
begin
  if NullableValue.HasValue then AddDateTime(PropertyName, NullableValue.Value);
end;

procedure TJsonObjectHelper.AddDateOnly(const PropertyName: string; const Value: TDate);
begin
  AddPair(PropertyName, DateToISO8601(Value));
end;

procedure TJsonObjectHelper.AddDateOnlyOrNothing(const PropertyName: string; const NullableValue: Nullable<TDate>);
begin
  if NullableValue.HasValue then AddDateOnly(PropertyName, NullableValue.Value);
end;

procedure TJsonObjectHelper.AddTimeOnly(const PropertyName: string; const Value: TTime);
begin
  AddPair(PropertyName, DateToISO8601(Value));
end;

procedure TJsonObjectHelper.AddTimeOnlyOrNothing(const PropertyName: string; const NullableValue: Nullable<TTime>);
begin
  if NullableValue.HasValue then AddTimeOnly(PropertyName, NullableValue.Value);
end;

procedure TJsonObjectHelper.AddUri(const PropertyName: string; Value: TUri);
begin
  AddPair(PropertyName, Value.ToString);
end;

procedure TJsonObjectHelper.AddUriOrNothing(const PropertyName: string; const NullableValue: Nullable<TUri>);
begin
  if NullableValue.HasValue then AddUri(PropertyName, NullableValue.Value);
end;

procedure TJsonObjectHelper.AddUriArray(const PropertyName: string; List: TList<TUri>);
begin
  if List.Count > 0 then
    AddUriArrayOrNothing(PropertyName, List)
  else
    AddPair(PropertyName, TJSONNull.Create);
end;

procedure TJsonObjectHelper.AddUriArrayOrNothing(const PropertyName: string; List: TList<TUri>);
begin
  if List.Count > 0 then
  begin
    var JsonArray := TJSONArray.Create;
    try
      for var UriItem in List do
      begin
        var JsonString := TJSONString.Create(UriItem.ToString);
        try
          JsonArray.AddElement(JsonString);
        except
          JsonString.Free; raise;
        end;
      end;
      AddPair(PropertyName, JsonArray);
    except
      JsonArray.Free; raise;
    end;
  end;
end;

procedure TJsonObjectHelper.AddStringArray(const PropertyName: string; List: TList<string>);
begin
  if List.Count > 0 then
    AddStringArrayOrNothing(PropertyName, List)
  else
    AddPair(PropertyName, TJSONNull.Create);
end;

procedure TJsonObjectHelper.AddStringArrayOrNothing(const PropertyName: string; List: TList<string>);
begin
  if List.Count > 0 then
  begin
    var JsonArray := TJSONArray.Create;
    try
      for var StringItem in List do
      begin
        var JsonString := TJSONString.Create(StringItem);
        try
          JsonArray.AddElement(JsonString);
        except
          JsonString.Free; raise;
        end;
      end;
      AddPair(PropertyName, JsonArray);
    except
      JsonArray.Free; raise;
    end;
  end;
end;

procedure TJsonObjectHelper.AddStringList(const PropertyName: string; List: TStrings);
begin
  if List.Count > 0 then
    AddStringListOrNothing(PropertyName, List)
  else
    AddPair(PropertyName, TJSONNull.Create);
end;

procedure TJsonObjectHelper.AddStringListOrNothing(const PropertyName: string; List: TStrings);
begin
  if List.Count > 0 then
  begin
    var JsonArray := TJSONArray.Create;
    try
      for var S in List do
      begin
        var JsonString := TJSONString.Create(S);
        try
          JsonArray.AddElement(JsonString);
        except
          JsonString.Free; raise;
        end;
      end;
      AddPair(PropertyName, JsonArray);
    except
      JsonArray.Free; raise;
    end;
  end;
end;

procedure TJsonObjectHelper.AddObject(const PropertyName: string; const AnObject: TJSONObject);
begin
  if AnObject <> nil then AddPair(PropertyName, AnObject);
end;

procedure TJsonObjectHelper.AddObject<T>(const PropertyName: string; Value: T);
begin
  if Value <> nil then
  begin
    var JsonObject := TJSONObject.Create;
    try
      Value.WriteTo(JsonObject);
      AddPair(PropertyName, JsonObject);
    except
      JsonObject.Free; raise;
    end;
  end;
end;

procedure TJsonObjectHelper.AddObjectArray(const PropertyName: string; List: TJSONArray);
begin
  if List <> nil then AddPair(PropertyName, List);
end;

procedure TJsonObjectHelper.AddObjectArray<T>(const PropertyName: string; List: TList<T>);
begin
  if List.Count > 0 then
  begin
    var JsonArray := TJSONArray.Create;
    try
      for var ListItem in List do
      begin
        var JsonObject := TJSONObject.Create;
        try
          ListItem.WriteTo(JsonObject);
          JsonArray.AddElement(JsonObject);
        except
          JsonObject.Free; raise;
        end;
      end;
      AddPair(PropertyName, JsonArray);
    except
      JsonArray.Free; raise;
    end;
  end else
    AddPair(PropertyName, TJSONNull.Create);
end;

procedure TJsonObjectHelper.AddColumnIdArray(const PropertyName: string; Columns: TColumns);
begin
  if Columns.Count > 0 then
  begin
    var JsonArray := TJSONArray.Create;
    try
      for var ListItem in Columns do
      begin
        var JsonString := TJSONString.Create(ListItem.Id);
        try
          JsonArray.AddElement(JsonString);
        except
          JsonString.Free; raise;
        end;
      end;
      AddPair(PropertyName, JsonArray);
    except
      JsonArray.Free; raise;
    end;
  end else
    AddPair(PropertyName, TJSONNull.Create);
end;

procedure TJsonObjectHelper.AddEnumMemberArray(const PropertyName: string; List: TList<TEnumMember>);
begin
  if List.Count > 0 then
  begin
    var JsonArray := TJSONArray.Create;
    try
      for var MemberItem in List do
      begin
        var JsonObject := TJSONObject.Create();
        try
          MemberItem.WriteTo(JsonObject);
          JsonArray.AddElement(JsonObject);
        except
          JsonObject.Free; raise;
        end;
      end;
      AddPair(PropertyName, JsonArray);
    except
      JsonArray.Free; raise;
    end;
  end else
    AddPair(PropertyName, TJSONNull.Create);
end;

function TJsonObjectHelper.GetRequiredJsonString(const PropertyName: string; out StringValue: TJSONString): Boolean;
begin
  if TryGetJsonString(PropertyName, StringValue) then
    Result := True
  else
    raise ECodeListParserException.CreateFmt('Required property "%s" not found.', [PropertyName]);
end;

function TJsonObjectHelper.GetRequiredJsonObject(const PropertyName: string; out JsonObjectValue: TJSONObject): Boolean;
begin
  if TryGetJsonObject(PropertyName, JsonObjectValue) then
    Result := True
  else
    raise ECodeListParserException.CreateFmt('Required property "%s" not found.', [PropertyName]);
end;

function TJsonObjectHelper.GetRequiredJsonArray(const PropertyName: string; out JsonArray: TJSONArray): Boolean;
begin
  if TryGetJsonArray(PropertyName, JsonArray) then
    Result := True
  else
    raise ECodeListParserException.CreateFmt('Required property "%s" not found.', [PropertyName]);
end;

function TJsonObjectHelper.TryGetJsonString(const PropertyName: string; out StringValue: TJSONString): Boolean;
var
  JsonValue: TJSONValue;
begin
  StringValue := nil;
  if TryGetValue(PropertyName, JsonValue) then
  begin
    if (JsonValue is TJSONString) then
    begin
      StringValue := TJSONString(JsonValue);
      Result := True;
    end else
      raise ECodeListParserException.CreateFmt('Property "%s" must be a JSON string.', [PropertyName]);
  end else
    Result := False;
end;

function TJsonObjectHelper.TryGetJsonBool(const PropertyName: string; out BoolValue: TJSONBool): Boolean;
var
  JsonValue: TJSONValue;
begin
  BoolValue := nil;
  if TryGetValue(PropertyName, JsonValue) then
  begin
    if (JsonValue is TJSONBool) then
    begin
      BoolValue := TJSONBool(JsonValue);
      Result := True;
    end else
      raise ECodeListParserException.CreateFmt('Property "%s" must be a JSON Boolean.', [PropertyName]);
  end else
    Result := False;
end;

function TJsonObjectHelper.TryGetJsonNumber(const PropertyName: string; out NumberValue: TJSONNumber): Boolean;
var
  JsonValue: TJSONValue;
begin
  NumberValue := nil;
  if TryGetValue(PropertyName, JsonValue) then
  begin
    if (JsonValue is TJSONNumber) then
    begin
      NumberValue := TJSONNumber(JsonValue);
      Result := True;
    end else
      raise ECodeListParserException.CreateFmt('Property "%s" must be a JSON Number.', [PropertyName]);
  end else
    Result := False;
end;

function TJsonObjectHelper.TryGetJsonObject(const PropertyName: string; out JsonObjectValue: TJSONObject): Boolean;
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

function TJsonObjectHelper.TryGetJsonArray(const PropertyName: string; out JsonArray: TJSONArray): Boolean;
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

end.

