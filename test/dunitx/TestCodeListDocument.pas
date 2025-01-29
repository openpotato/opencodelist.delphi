{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit TestCodeListDocument;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  OpenCodeList.CodeListDocument,
  OpenCodeList.Values;

type
  {$M+}
  [TestFixture]
  TCodeListDocumentTests = class
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
    [Test]
    procedure TestMeta;
  end;
  {$M-}

implementation

uses
  System.IOUtils,
  System.JSON,
  System.Net.URLClient;

{ TCodeListDocumentTests }

procedure TCodeListDocumentTests.Setup;
begin
  FOutputFolder := ExtractFilePath(ParamStr(0));
  FAssetsFolder := TPath.Combine(FOutputFolder, 'Assets');
end;

procedure TCodeListDocumentTests.TestRead;
var
  Document: TCodeListDocument;
begin
  Document := TCodeListDocument.LoadFromFile(TPath.Combine(FAssetsFolder, 'codelist.json'));
  try
    Assert.IsNotNull(Document);
    Assert.IsFalse(Document.MetaOnly);
    Assert.AreEqual<string>('This is a comment.', Document.Comments[0]);
    Assert.AreEqual<string>('markdown', Document.Annotation.Descriptions[0].Format);
    Assert.AreEqual<string>('de', document.Annotation.Descriptions[0].Language.Value);
    Assert.AreEqual<string>('Das ist eine **Anmerkung**.', document.Annotation.Descriptions[0].Content);
    Assert.AreEqual<string>('TestCodeList', document.Identification.ShortName);
    Assert.AreEqual<string>('A test code list', document.Identification.LongName.Value);
    Assert.AreEqual<string>('OpenPotato', document.Identification.Publisher.ShortName);
    Assert.AreEqual<string>('The OpenPotato Project', document.Identification.Publisher.LongName.Value);
    Assert.AreEqual<string>('TrustMe', document.Identification.Publisher.Identifier.Source.ShortName);
    Assert.AreEqual<string>('42', document.Identification.Publisher.Identifier.Value);
    Assert.AreEqual<string>('de', document.Identification.AlternateLanguageLocations[0].Language);
    Assert.AreEqual<string>(TUri.Create('https://example.com/codelist-2025-01-01.de.json').Encode, document.Identification.AlternateLanguageLocations[0].Url.Encode);
    Assert.AreEqual<string>('text/csv', document.Identification.AlternateFormatLocations[0].MimeType);
    Assert.AreEqual<string>(TUri.Create('https://example.com/codelist-2025-01-01.csv').Encode, document.Identification.AlternateFormatLocations[0].Url.Encode);
    Assert.AreEqual<Integer>(11, document.Columns.Count);
    Assert.AreEqual<string>('code', document.Columns[0].Id);
    Assert.AreEqual<Integer>(3, document.Rows.Count);

    Assert.AreEqual<string>('c-1', (document.Rows[0]['code'] as TStringValue).Value);
    Assert.AreEqual<string>('BW', (document.Rows[0]['federalState'] as TStringValue).Value);
    Assert.AreEqual<Integer>(42, (document.Rows[0]['integer'] as TIntegerValue).Value);
    Assert.AreEqual<Double>(41.99, (document.Rows[0]['number'] as TNumberValue).Value);
    Assert.IsTrue((document.Rows[0]['bool'] as TBooleanValue).Value);
    Assert.AreEqual<string>('e1', (document.Rows[0]['enumSet'] as TStringListValue).List[0]);
    Assert.AreEqual<string>('e3', (document.Rows[0]['enumSet'] as TStringListValue).List[1]);

    Assert.AreEqual<string>('c-2', (document.Rows[1]['code'] as TStringValue).Value);
    Assert.AreEqual<string>('BE', (document.Rows[1]['federalState'] as TStringValue).Value);
    Assert.IsFalse((document.Rows[1]['bool'] as TBooleanValue).Value);
    Assert.AreEqual<Integer>(0, (document.Rows[1]['enumSet'] as TStringListValue).List.Count);

  finally
    Document.Free;
  end;
end;

procedure TCodeListDocumentTests.TestWrite;
var
  OriginalDocument, CopiedDocument: TCodeListDocument;
  CopyPath: string;
begin
  OriginalDocument := TCodeListDocument.LoadFromFile(TPath.Combine(FAssetsFolder, 'codelist.json'));
  try

    CopyPath := TPath.Combine(FAssetsFolder, 'codelist.copy.json');
    OriginalDocument.SaveToFile(CopyPath);

    CopiedDocument := TCodeListDocument.LoadFromFile(CopyPath);
    try
      Assert.AreEqual<Integer>(OriginalDocument.Comments.Count, CopiedDocument.Comments.Count);
    finally
      CopiedDocument.Free;
    end;

  finally
    OriginalDocument.Free;
  end;
end;

procedure TCodeListDocumentTests.TestMeta;
var
  OriginalDocument, CopiedDocument: TCodeListDocument;
  CopyPath: string;
begin
  OriginalDocument := TCodeListDocument.LoadFromFile(TPath.Combine(FAssetsFolder, 'codelist.meta.json'));
  try

    Assert.IsTrue(OriginalDocument.MetaOnly);

    CopyPath := TPath.Combine(FAssetsFolder, 'codelist.meta.copy.json');
    OriginalDocument.SaveAsMetaOnlyToFile(CopyPath);

    CopiedDocument := TCodeListDocument.LoadFromFile(CopyPath);
    try
      Assert.IsTrue(CopiedDocument.MetaOnly);
      Assert.AreEqual<Integer>(OriginalDocument.Comments.Count, CopiedDocument.Comments.Count);
    finally
      CopiedDocument.Free;
    end;

  finally
    OriginalDocument.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TCodeListDocumentTests);

end.

