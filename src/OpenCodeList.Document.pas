{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.Document;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.JSON,
  System.SysUtils,
  OpenCodeList.Annotation,
  OpenCodeList.Identification,
  OpenCodeList.SemanticVersion;

type

  /// <summary>
  /// Abstract OpenCodeList document for specific document types.
  /// </summary>
  TDocument = class abstract
  private
    FAnnotation: TAnnotation;
    FComments: TList<string>;
    FIdentification: TIdentification;
    FMetaOnly: Boolean;
  public

    /// <summary>
    /// Returns the supported OpenCodeList version.
    /// </summary>
    /// <returns>A OpenCodeList version</returns>
    class function GetVersion: TSemanticVersion;

  public

    /// <summary>
    /// Initializes a new instance of <see cref="TDocument" />
    /// </summary>
    constructor Create;

    /// <summary>
    /// Cleans up resources
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Clears metadata and content of the document.
    /// </summary>
    procedure Clear; virtual;

    /// <summary>
    /// Clears content of the document only.
    /// </summary>
    /// <param name="convertToMetaOnly">If TRUE, marks document as meta document</param>
    procedure ClearContent(ConvertToMetaOnly: Boolean); virtual;

    /// <summary>
    /// Saves this document to a stream according to the OpenCodeList JSON schema
    /// specification.
    /// </summary>
    /// <param name="Stream">The output stream</param>
    /// <param name="Indented">Should the JSON serialisation be indented?</param>
    procedure SaveToStream(Stream: TStream; Indented: Boolean = true); virtual; abstract;

    /// <summary>
    /// Saves this document to a file according to the OpenCodeList JSON schema
    /// specification.
    /// </summary>
    /// <param name="FileName">The file path</param>
    /// <param name="Indented">Should the JSON serialisation be indented?</param>
    procedure SaveToFile(const FileName: string; Indented: Boolean = true);

    /// <summary>
    /// Saves this document as meta document to a stream according to the
    /// OpenCodeList JSON schema specification.
    /// </summary>
    /// <param name="Stream">The output stream</param>
    /// <param name="Indented">Should the JSON serialisation be indented?</param>
    procedure SaveAsMetaOnlyToStream(Stream: TStream; Indented: Boolean = true);

    /// <summary>
    /// Saves this document as meta document to a file according to the
    /// OpenCodeList JSON schema specification.
    /// </summary>
    /// <param name="FileName">The file path</param>
    /// <param name="Indented">Should the JSON serialisation be indented?</param>
    procedure SaveAsMetaOnlyToFile(const FileName: string; Indented: Boolean = true);

  public

    /// <summary>
    /// Annotations for the document.
    /// </summary>
    property Annotation: TAnnotation read FAnnotation write FAnnotation;

    /// <summary>
    /// Comments for the document.
    /// </summary>
    property Comments: TList<string> read FComments;

    /// <summary>
    /// Meta information about the document.
    /// </summary>
    property Identification: TIdentification read FIdentification write FIdentification;

    /// <summary>
    /// Indicates whether the document is meta-only.
    /// </summary>
    property MetaOnly: Boolean read FMetaOnly;

  end;

implementation

uses
  OpenCodeList.PropertyNames,
  OpenCodeList.JsonHelper;

{ TDocument }

constructor TDocument.Create;
begin
  inherited Create;
  FIdentification := TIdentification.Create;
  FComments := TList<string>.Create;
  FAnnotation := nil;
  FMetaOnly := false;
end;

destructor TDocument.Destroy;
begin
  FComments.Free;
  FIdentification.Free;
  FAnnotation.Free;
  inherited;
end;

procedure TDocument.Clear;
begin
  FreeAndNil(FAnnotation);
  FComments.Clear;
  FreeAndNil(FIdentification);
  FIdentification := TIdentification.Create;
  ClearContent(False);
end;

procedure TDocument.ClearContent(ConvertToMetaOnly: Boolean);
begin
  if ConvertToMetaOnly then FMetaOnly := True;
end;

procedure TDocument.SaveToFile(const FileName: string; Indented: Boolean);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(FileStream, Indented);
  finally
    FileStream.Free;
  end;
end;

procedure TDocument.SaveAsMetaOnlyToStream(Stream: TStream; Indented: Boolean);
begin
  FMetaOnly := True;
  SaveToStream(Stream, Indented);
end;

procedure TDocument.SaveAsMetaOnlyToFile(const FileName: string; Indented: Boolean);
begin
  FMetaOnly := True;
  SaveToFile(FileName, Indented);
end;

class function TDocument.GetVersion: TSemanticVersion;
begin
  Result := TSemanticVersion.Create(0, 3, 0);
end;

end.

