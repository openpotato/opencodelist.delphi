{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.DateTimeUtils;

interface

uses
  System.SysUtils,
  System.DateUtils;

function ISO8601DateTimeToStr(const DateTime: TDateTime): string; overload;
function ISO8601DateTimeToStr(const DateTime: TDateTime; TimeZoneBias: Integer): string; overload;
function ISO8601DateToStr(const Date: TDateTime): string;
function ISO8601TimeToStr(const Time: TDateTime): string; overload;
function ISO8601TimeToStr(const Date: TDateTime; TimeZoneBias: Integer): string; overload;
function ISO8601StrToDateTime(const S: string): TDateTime;
function ISO8601StrToDate(const S: string): TDate;
function ISO8601StrToTime(const S: string): TTime;

implementation

function ISO8601Timezone(TimeZoneBias: Integer): string;
var
  Sign: Char;
begin
  if TimeZoneBias = 0 then
    Result := 'Z'
  else begin
    if TimeZoneBias < 0 then
    begin
      TimeZoneBias := -TimeZoneBias;
      Sign := '-';
    end else
    begin
      Sign := '+';
    end;
    Result := Result + Format('%s%2.2d:%2.2d',[Sign, TimeZoneBias div 60, TimeZoneBias mod 60]);
  end;
end;

function ISO8601DateTimeToStr(const DateTime: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd"T"hh":"nn":"ss', DateTime);
end;

function ISO8601DateTimeToStr(const DateTime: TDateTime; TimeZoneBias: Integer): string;
begin
  Result := ISO8601DateTimeToStr(DateTime) + ISO8601Timezone(TimeZoneBias);
end;

function ISO8601DateToStr(const Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', Date);
end;

function ISO8601TimeToStr(const Time: TDateTime): string;
begin
  Result := FormatDateTime('hh":"nn":"ss', Time);
end;

function ISO8601TimeToStr(const Date: TDateTime; TimeZoneBias: Integer): string;
begin
  Result := ISO8601TimeToStr(Date) + ISO8601Timezone(TimeZoneBias);
end;

function ISO8601StrToDateTime(const S: string): TDateTime;

  function ExtractNum(Value, Length: Integer): Integer;
  begin
    Result := StrToIntDef(Copy(S, Value, Length), 0);
  end;

var
  Year, Month, Day: Integer;
begin
  if (Length(S) >= 10) and (S[5] = '-') and (S[8] = '-') then
  begin

    Year  := ExtractNum(1, 4);
    Month := ExtractNum(6, 2);
    Day   := ExtractNum(9, 2);

    if (Year = 0) and (Month = 0) and (Day = 0) then
      Result := 0.0
    else
      Result := EncodeDate(Year, Month, Day);

    if (Length(S) > 10) and (S[11] = 'T') then
      Result := Result + ISO8601StrToTime(Copy(S, 12, 999));

  end else
    Result := ISO8601StrToTime(S);
end;

function ISO8601StrToDate(const S: string): TDate;
begin
  Result := DateOf(ISO8601StrToDateTime(S));
end;

function ISO8601StrToTime(const S: string): TTime;

  function ExtractNum(Value, Length: Integer): Integer;
  begin
    Result := StrToIntDef(Copy(S, Value, Length), 0);
  end;

begin
  if (Length(S) >= 8) and (S[3] = ':') then
    Result := EncodeTime(ExtractNum(1, 2), ExtractNum(4, 2), ExtractNum(7, 2), 0)
  else
    Result := 0.0;
end;

end.
