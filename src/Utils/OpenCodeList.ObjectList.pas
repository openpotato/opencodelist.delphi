{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.ObjectList;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type

  /// <summary>
  /// An extended version of the generic <see cref="TObjectList<T>" /> class
  /// </summary>
  TExtendedObjectList<T: class> = class(TObjectList<T>)
  public
    function CreateAndAdd<SpecificType: T, constructor>: T;
    function Contains(Predicate: TFunc<T, Boolean>): Boolean; overload;
    function IndexOf(Predicate: TFunc<T, Boolean>): Integer; overload;
    function Get(Predicate: TFunc<T, Boolean>): T; overload;
    function TryGet(Predicate: TFunc<T, Boolean>; out Found: T): Boolean; overload;
  end;

implementation

{ TExtendedObjectList<T> }

function TExtendedObjectList<T>.CreateAndAdd<SpecificType>: T;
begin
  Result := SpecificType.Create;
  Add(Result);
end;

function TExtendedObjectList<T>.Contains(Predicate: TFunc<T, Boolean>): Boolean;
begin
  Result := Get(Predicate) <> nil;
end;

function TExtendedObjectList<T>.IndexOf(Predicate: TFunc<T, Boolean>): Integer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Predicate(Items[I]) then Exit(I);
  end;
  Result := -1;
end;

function TExtendedObjectList<T>.Get(Predicate: TFunc<T, Boolean>): T;
var
  I: Integer;
begin
  I := IndexOf(Predicate);
  if I <> -1 then Exit(Items[I] as T);
  Result := nil;
end;

function TExtendedObjectList<T>.TryGet(Predicate: TFunc<T, Boolean>; out Found: T): Boolean;
begin
  Found := Get(Predicate);
  Result := Found <> nil;
end;

end.

