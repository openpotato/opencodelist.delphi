{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit TestDocumentLoader;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  OpenCodeList.CodeListDocument,
  OpenCodeList.CodeListSetDocument,
  OpenCodeList.Document,
  OpenCodeList.DocumentLoader;

type
  {$M+}
  [TestFixture]
  TDocumentLoaderTests = class
  private
    FAssetsFolder: string;
    FOutputFolder: string;
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure TestReadCodeList;
    [Test]
    procedure TestReadCodeListSet;
  end;
  {$M-}

implementation

uses
  System.IOUtils,
  System.JSON;

{ TDocumentLoaderTests }

procedure TDocumentLoaderTests.Setup;
begin
  FOutputFolder := ExtractFilePath(ParamStr(0));
  FAssetsFolder := TPath.Combine(FOutputFolder, 'Assets');
end;

procedure TDocumentLoaderTests.TestReadCodeList;
var
  Document: TDocument;
begin
  Document := TDocumentLoader.LoadFromFile(TPath.Combine(FAssetsFolder, 'codelist.json'));
  try
    Assert.IsNotNull(Document);
    Assert.IsTrue(Document is TCodeListDocument);
  finally
    Document.Free;
  end;
end;

procedure TDocumentLoaderTests.TestReadCodeListSet;
var
  Document: TDocument;
begin
  Document := TDocumentLoader.LoadFromFile(TPath.Combine(FAssetsFolder, 'codelistset.json'));
  try
    Assert.IsNotNull(Document);
    Assert.IsTrue(Document is TCodeListSetDocument);
  finally
    Document.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TDocumentLoaderTests);

end.

