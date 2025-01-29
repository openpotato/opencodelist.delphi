{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Values;

interface

uses
  System.Classes,
  System.JSON,
  System.SysUtils,
  OpenCodeList.BaseObjects,
  OpenCodeList.Nullable,
  OpenCodeList.DateTimeUtils;

type

  /// <summary>
  /// An abstract row value
  /// </summary>
  TValue = class abstract
  end;

  /// <summary>
  /// A string row value
  /// </summary>
  TStringValue = class(TValue)
  private
    FValue: string;
    function GetValue: string;
  public
    constructor Create(const AValue: string);
    function ToString: string; override;
  public
    property Value: string read GetValue;
  end;

  /// <summary>
  /// A boolean row value
  /// </summary>
  TBooleanValue = class(TValue)
  private
    FValue: Boolean;
    function GetValue: Boolean;
  public
    constructor Create(AValue: Boolean);
    function ToString: string; override;
  public
    property Value: Boolean read GetValue;
  end;

  /// <summary>
  /// An integer row value
  /// </summary>
  TIntegerValue = class(TValue)
  private
    FValue: Integer;
    function GetValue: Integer;
  public
    constructor Create(AValue: Integer);
    function ToString: string; override;
  public
    property Value: Integer read GetValue;
  end;

  /// <summary>
  /// A double row value
  /// </summary>
  TNumberValue = class(TValue)
  private
    FValue: Double;
    function GetValue: Double;
  public
    constructor Create(const AValue: Double);
    function ToString: string; override;
  public
    property Value: Double read GetValue;
  end;

  /// <summary>
  /// A date time row value
  /// </summary>
  TDateTimeValue = class(TValue)
  private
    FValue: TDateTime;
    function GetValue: TDateTime;
  public
    constructor Create(const AValue: TDateTime);
    function ToString: string; override;
  public
    property Value: TDateTime read GetValue;
  end;

  /// <summary>
  /// A date only row value
  /// </summary>
  TDateOnlyValue = class(TValue)
  private
    FValue: TDate;
    function GetValue: TDate;
  public
    constructor Create(const AValue: TDate);
    function ToString: string; override;
  public
    property Value: TDate read GetValue;
  end;

  /// <summary>
  /// A time only row value
  /// </summary>
  TTimeOnlyValue = class(TValue)
  private
    FValue: TTime;
    function GetValue: TTime;
  public
    constructor Create(const AValue: TTime);
    function ToString: string; override;
  public
    property Value: TTime read GetValue;
  end;

  /// <summary>
  /// A string list row value
  /// </summary>
  TStringListValue = class(TValue)
  private
    FList: TStrings;
    function GetList: TStrings;
  public
    constructor Create(AList: TStrings);
    destructor Destroy; override;
    function ToString: string; override;
  public
    property List: TStrings read GetList;
  end;

  /// <summary>
  /// A JSON object row value
  /// </summary>
  TJSONObjectValue = class(TValue)
  private
    FObject: TJSONObject;
    function GetObject: TJSONObject;
  public
    constructor Create(AObject: TJSONObject);
    destructor Destroy; override;
    function ToString: string; override;
  public
    property &Object: TJSONObject read GetObject;
  end;

  /// <summary>
  /// A JSON array row value
  /// </summary>
  TJSONArrayValue = class(TValue)
  private
    FArray: TJSONArray;
    function GetArray: TJSONArray;
  public
    constructor Create(AnArray: TJSONArray);
    destructor Destroy; override;
    function ToString: string; override;
  public
    property &Array: TJSONArray read GetArray;
  end;

implementation

{ TStringValue }

constructor TStringValue.Create(const AValue: string);
begin
  inherited Create;
  FValue := AValue;
end;

function TStringValue.ToString: string;
begin
  Result := FValue;
end;

function TStringValue.GetValue: string;
begin
  Result := FValue;
end;

{ TBooleanValue }

constructor TBooleanValue.Create(AValue: Boolean);
begin
  inherited Create;
  FValue := AValue;
end;

function TBooleanValue.ToString: string;
begin
  Result := BoolToStr(FValue);
end;

function TBooleanValue.GetValue: Boolean;
begin
  Result := FValue;
end;

{ TIntegerValue }

constructor TIntegerValue.Create(AValue: Integer);
begin
  inherited Create;
  FValue := AValue;
end;

function TIntegerValue.ToString: string;
begin
  Result := IntToStr(FValue);
end;

function TIntegerValue.GetValue: Integer;
begin
  Result := FValue;
end;

{ TNumberValue }

constructor TNumberValue.Create(const AValue: Double);
begin
  inherited Create;
  FValue := AValue;
end;

function TNumberValue.ToString: string;
begin
  Result := FloatToJson(FValue);
end;

function TNumberValue.GetValue: Double;
begin
  Result := FValue;
end;

{ TDateTimeValue }

constructor TDateTimeValue.Create(const AValue: TDateTime);
begin
  inherited Create;
  FValue := AValue;
end;

function TDateTimeValue.ToString: string;
begin
  Result := ISO8601DateTimeToStr(FValue);
end;

function TDateTimeValue.GetValue: TDateTime;
begin
  Result := FValue;
end;

{ TDateOnlyValue }

constructor TDateOnlyValue.Create(const AValue: TDate);
begin
  inherited Create;
  FValue := AValue;
end;

function TDateOnlyValue.ToString: string;
begin
  Result := ISO8601DateToStr(FValue);
end;

function TDateOnlyValue.GetValue: TDate;
begin
  Result := FValue;
end;

{ TBooleanValue }

constructor TTimeOnlyValue.Create(const AValue: TTime);
begin
  inherited Create;
  FValue := AValue;
end;

function TTimeOnlyValue.ToString: string;
begin
  Result := ISO8601TimeToStr(FValue);
end;

function TTimeOnlyValue.GetValue: TTime;
begin
  Result := FValue;
end;

{ TStringListValue }

constructor TStringListValue.Create(AList: TStrings);
begin
  inherited Create;
  FList := AList;
end;

destructor TStringListValue.Destroy;
begin
  FList.Free;
  inherited;
end;

function TStringListValue.ToString: string;
begin
  Result := FList.DelimitedText;
end;

function TStringListValue.GetList: TStrings;
begin
  Result := FList;
end;

{ TJSONObjectValue }

constructor TJSONObjectValue.Create(AObject: TJSONObject);
begin
  inherited Create;
  FObject := AObject;
end;

destructor TJSONObjectValue.Destroy;
begin
  FObject.Free;
  inherited;
end;

function TJSONObjectValue.ToString: string;
begin
  Result := FObject.ToString;
end;

function TJSONObjectValue.GetObject: TJSONObject;
begin
  Result := FObject;
end;

{ TJSONArrayValue }

constructor TJSONArrayValue.Create(AnArray: TJSONArray);
begin
  inherited Create;
  FArray := AnArray;
end;

destructor TJSONArrayValue.Destroy;
begin
  FArray.Free;
  inherited;
end;

function TJSONArrayValue.ToString: string;
begin
  Result := FArray.ToString;
end;

function TJSONArrayValue.GetArray: TJSONArray;
begin
  Result := FArray;
end;

end.

