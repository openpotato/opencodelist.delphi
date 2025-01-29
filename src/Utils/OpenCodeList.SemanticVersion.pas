{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.SemanticVersion;

interface

uses
  System.SysUtils,
  System.StrUtils;

type

  /// <summary>
  /// Semantic version type, following closely https://semver.org
  /// </summary>
  TSemanticVersion = record
    FMajor: Integer;
    FMinor: Integer;
    FPatch: Integer;
    FPreRelease: string;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="SemanticVersion"/>.
    /// </summary>
    /// <param name="AMajor">Major version part</param>
    /// <param name="AMinor">Minor version part</param>
    /// <param name="APatch">Patch version part</param>
    /// <param name="APreRelease">Additional label for pre-release</param>
    constructor Create(AMajor, AMinor, APatch: Integer; const APreRelease: string = ''); overload;

    /// <summary>
    /// Initializes a new instance of <see cref="SemanticVersion"/>.
    /// </summary>
    /// <param name="AVersion">String formatted version</param>
    constructor Create(const AVersion: string); overload;

    /// <summary>
    /// Compares the current version instance with another version and returns
    /// an integer that indicates whether the current instance precedes, follows,
    /// or occurs in the same position in the sort order as the other version.
    /// </summary>
    /// <param name="Another">A version to compare with this instance.</param>
    /// <returns>A value that indicates the relative order of the versions being
    /// compared</returns>
    function CompareTo(const Another: TSemanticVersion): Integer;

    /// <summary>
    /// Returns the string representation of the version.
    /// </summary>
    /// <returns>String formatted version</returns>
    function ToString: string;

  public

    /// <summary>
    /// Implicit typecast
    /// </summary>
    class operator Implicit(const AVersion: string): TSemanticVersion;

    /// <summary>
    /// Explicit typecast
    /// </summary>
    class operator Explicit(const AVersion: TSemanticVersion): string;

  public

    /// <summary>
    /// Major version part
    /// </summary>
    property Major: Integer read FMajor write FMajor;

    /// <summary>
    /// Minor version part
    /// </summary>
    property Minor: Integer read FMinor write FMinor;

    /// <summary>
    /// Patch version part
    /// </summary>
    property Patch: Integer read FPatch write FPatch;

    /// <summary>
    /// Major version part
    /// </summary>
    property PreRelease: string read FPreRelease write FPreRelease;

  end;

implementation

{ TSemanticVersion }

constructor TSemanticVersion.Create(AMajor, AMinor, APatch: Integer; const APreRelease: string);
begin
  FMajor := AMajor;
  FMinor := AMinor;
  FPatch := APatch;
  FPreRelease := APreRelease;
end;

constructor TSemanticVersion.Create(const AVersion: string);
var
  Parts, VersionNumbers: TArray<string>;
begin

  Parts := SplitString(AVersion, '-');
  VersionNumbers := SplitString(Parts[0], '.');

  if Length(VersionNumbers) >= 1 then
    FMajor := StrToIntDef(VersionNumbers[0], 0)
  else
    FMajor := 0;

  if Length(VersionNumbers) >= 2 then
    FMinor := StrToIntDef(VersionNumbers[1], 0)
  else
    FMinor := 0;

  if Length(VersionNumbers) >= 3 then
    FPatch := StrToIntDef(VersionNumbers[2], 0)
  else
    FPatch := 0;

  if Length(Parts) > 1 then
    FPreRelease := Parts[1]
  else
    FPreRelease := '';

end;

function TSemanticVersion.CompareTo(const Another: TSemanticVersion): Integer;
begin

  if FMajor <> Another.Major then Exit(FMajor - Another.Major);
  if FMinor <> Another.Minor then Exit(FMinor - Another.Minor);
  if FPatch <> Another.Patch then Exit(FPatch - Another.Patch);

  if (FPreRelease = '') and (Another.PreRelease <> '') then
    Exit(1)
  else if (FPreRelease <> '') and (Another.PreRelease = '') then
    Exit(-1)
  else
    Exit(CompareStr(FPreRelease, Another.PreRelease));

end;

function TSemanticVersion.ToString: string;
begin
  if FPreRelease <> '' then
    Result := Format('%d.%d.%d-%s', [FMajor, FMinor, FPatch, FPreRelease])
  else
    Result := Format('%d.%d.%d', [FMajor, FMinor, FPatch]);
end;

class operator TSemanticVersion.Implicit(const AVersion: string): TSemanticVersion;
begin
  Result := TSemanticVersion.Create(AVersion);
end;

class operator TSemanticVersion.Explicit(const AVersion: TSemanticVersion): string;
begin
  Result := AVersion.ToString;
end;

end.

