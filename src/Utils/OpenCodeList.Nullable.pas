{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Nullable;

interface

uses
  System.SysUtils;

type

  /// <summary>
  /// Exception for <see cref="Nullable<T>"/>
  /// </summary>
  ENullableException = class(Exception);

  /// <summary>
  /// Nullable type, allowing properties to have nullable behavior.
  /// </summary>
  Nullable<T> = record
  private
    FHasValue: Boolean;
    FValue: T;
    function GetValue: T;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="Nullable<T>"/>.
    /// </summary>
    /// <param name="AValue">The initial value</param>
    constructor Create(const AValue: T); overload;

    /// <summary>
    /// Sets the value
    /// </summary>
    /// <param name="AValue">The new value</param>
    procedure SetValue(const AValue: T);

    /// <summary>
    /// Removes the value
    /// </summary>
    procedure Clear;

  public

    /// <summary>
    /// Implicit typecast
    /// </summary>
    class operator Implicit(const AValue: T): Nullable<T>;

    /// <summary>
    /// Explicit typecast
    /// </summary>
    class operator Explicit(const ANullableValue: Nullable<T>): T;

  public

    /// <summary>
    /// True if has a defined value
    /// </summary>
    property HasValue: Boolean read FHasValue;

    /// <summary>
    /// The value
    /// </summary>
    property Value: T read GetValue;

  end;

implementation

{ Nullable<T> }

constructor Nullable<T>.Create(const AValue: T);
begin
  FValue := AValue;
  FHasValue := True;
end;

procedure Nullable<T>.SetValue(const AValue: T);
begin
  FValue := AValue;
  FHasValue := True;
end;

procedure Nullable<T>.Clear;
begin
  FHasValue := False;
end;

function Nullable<T>.GetValue: T;
begin
  if HasValue then
    Result := FValue
  else
    raise ENullableException.Create('Nullable type has no value');
end;

class operator Nullable<T>.Implicit(const AValue: T): Nullable<T>;
begin
  Result.SetValue(AValue);
end;

class operator Nullable<T>.Explicit(const ANullableValue: Nullable<T>): T;
begin
  if ANullableValue.HasValue then
    Result := ANullableValue.Value
  else
    raise ENullableException.Create('Nullable type has no value');
end;

end.

