{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.DocumentRef;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  System.JSON.Types,
  System.Net.URLClient,
  OpenCodeList.BaseObjects;

type

  /// <summary>
  /// An external code list or code list set reference.
  /// </summary>
  TDocumentRef = class abstract(TBaseObject)
  private
    FCanonicalUri: TUri;
    FCanonicalVersionUri: TUri;
    FLocationUrls: TList<TUri>;
  public

    /// <summary>
    /// Initializes a new instance of <see cref="TDocumentRef" />
    /// </summary>
    constructor Create;

    /// <summary>
    /// Cleans up resources
    /// </summary>
    destructor Destroy; override;

  public

    /// <summary>
    /// Canonical URI which uniquely identifies all versions (collectively).
    /// </summary>
    property CanonicalUri: TUri read FCanonicalUri write FCanonicalUri;

    /// <summary>
    /// Canonical URI which uniquely identifies this version.
    /// </summary>
    property CanonicalVersionUri: TUri read FCanonicalVersionUri write FCanonicalVersionUri;

    /// <summary>
    /// Suggested retrieval locations for this version, in OpenCodeList format.
    /// </summary>
    property LocationUrls: TList<TUri> read FLocationUrls;

  end;

implementation

{ TDocumentRef }

constructor TDocumentRef.Create;
begin
  inherited Create;
  FLocationUrls := TList<TUri>.Create;
end;

destructor TDocumentRef.Destroy;
begin
  FLocationUrls.Free;
  inherited Destroy;
end;

end.

