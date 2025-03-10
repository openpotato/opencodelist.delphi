{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit CodeListSetDocumentTests;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  OpenCodeList.CodeListSetDocument;

type
  {$M+}
  [TestFixture]
  TCodeListSetDocumentTests = class
  private
    FAssetsFolder: string;
    FOutputFolder: string;
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure TestRead;
    [Test]
    procedure TestWrite;
  end;
  {$M-}

implementation

uses
  System.IOUtils,
  System.JSON,
  System.Net.URLClient;

{ TCodeListSetDocumentTests }

procedure TCodeListSetDocumentTests.Setup;
begin
  FOutputFolder := ExtractFilePath(ParamStr(0));
  FAssetsFolder := TPath.Combine(FOutputFolder, 'Assets');
end;

procedure TCodeListSetDocumentTests.TestRead;
var
  Document: TCodeListSetDocument;
begin
  Document := TCodeListSetDocument.LoadFromFile(TPath.Combine(FAssetsFolder, 'codelistset.json'));
  try
    Assert.IsNotNull(Document);
    Assert.IsFalse(Document.MetaOnly);
    Assert.AreEqual<string>('This is a comment.', Document.Comments[0]);
    Assert.AreEqual<string>('markdown', Document.Annotation.Descriptions[0].Format);
    Assert.AreEqual<string>('de', document.Annotation.Descriptions[0].Language.Value);
    Assert.AreEqual<string>('Das ist eine **Anmerkung**.', document.Annotation.Descriptions[0].Content);
    Assert.AreEqual<string>('TestCodeListSet', document.Identification.ShortName);
    Assert.AreEqual<string>('A test code list set', document.Identification.LongName.Value);
    Assert.AreEqual<string>('OpenPotato', document.Identification.Publisher.ShortName);
    Assert.AreEqual<string>('The OpenPotato Project', document.Identification.Publisher.LongName.Value);
    Assert.AreEqual<string>('TrustMe', document.Identification.Publisher.Identifier.Source.ShortName);
    Assert.AreEqual<string>('42', document.Identification.Publisher.Identifier.Value);
    Assert.AreEqual<string>('de', document.Identification.AlternateLanguageLocations[0].Language);
    Assert.AreEqual<string>(TUri.Create('https://example.com/codelistset-2025-01-01.de.json').Encode, document.Identification.AlternateLanguageLocations[0].Url.Encode);
    Assert.AreEqual<string>('text/csv', document.Identification.AlternateFormatLocations[0].MimeType);
    Assert.AreEqual<string>(TUri.Create('https://example.com/codelistset-2025-01-01.csv').Encode, document.Identification.AlternateFormatLocations[0].Url.Encode);
    Assert.AreEqual<string>(TUri.Create('urn:test:codelist').Encode, document.DocumentRefs[0].CanonicalUri.Encode);
  finally
    Document.Free;
  end;
end;

procedure TCodeListSetDocumentTests.TestWrite;
var
  OriginalDocument, CopiedDocument: TCodeListSetDocument;
  CopyPath: string;
begin
  OriginalDocument := TCodeListSetDocument.LoadFromFile(TPath.Combine(FAssetsFolder, 'codelistset.json'));
  try

    CopyPath := TPath.Combine(FAssetsFolder, 'codelistset.copy.json');
    OriginalDocument.SaveToFile(CopyPath);

    CopiedDocument := TCodeListSetDocument.LoadFromFile(CopyPath);
    try
      Assert.AreEqual<Integer>(OriginalDocument.Comments.Count, CopiedDocument.Comments.Count);
    finally
      CopiedDocument.Free;
    end;

  finally
    OriginalDocument.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TCodeListSetDocumentTests);

end.

