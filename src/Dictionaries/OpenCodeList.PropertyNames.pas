{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.PropertyNames;

interface

type

  /// <summary>
  /// JSON property names for OpenCodeList documents
  /// </summary>
  TPropertyNames = class
  public
    const AlternateFormatLocations = 'alternateFormatLocations';
    const AlternateLanguageLocations = 'alternateLanguageLocations';
    const Annotation = 'annotation';
    const AppInfo = 'appInfo';
    const CanonicalUri = 'canonicalUri';
    const CanonicalVersionUri = 'canonicalVersionUri';
    const ChangeLog = 'changeLog';
    const CodeList = 'codeList';
    const CodeListRef = 'codeListRef';
    const CodeListSet = 'codeListSet';
    const CodeListSetMember = 'codeListSetMember';
    const Column = 'column';
    const ColumnIds = 'columnIds';
    const ColumnSet = 'columnSet';
    const Columns = 'columns';
    const Comments = '$comments';
    const Content = 'content';
    const DataSet = 'dataSet';
    const DefaultKey = 'defaultKey';
    const Description = 'description';
    const Descriptions = 'descriptions';
    const EnumMember = 'enumMember';
    const ExclusiveMaxValue = 'exclusiveMaxValue';
    const ExclusiveMinValue = 'exclusiveMinValue';
    const ForeignKey = 'foreignKey';
    const ForeignKeys = 'foreignKeys';
    const Format = 'format';
    const Id = 'id';
    const Identification = 'identification';
    const Identifier = 'identifier';
    const KeyId = 'keyId';
    const KeyRef = 'keyRef';
    const Keys = 'keys';
    const Language = 'language';
    const LocationUrls = 'locationUrls';
    const LongName = 'longName';
    const MaxLength = 'maxLength';
    const MaxValue = 'maxValue';
    const Members = 'members';
    const MimeType = 'mimeType';
    const MinLength = 'minLength';
    const MinValue = 'minValue';
    const Name = 'name';
    const Nullable = 'nullable';
    const OpenCodeList = '$opencodelist';
    const Optional = 'optional';
    const Pattern = 'pattern';
    const PublishedAt = 'publishedAt';
    const Publisher = 'publisher';
    const ReferenceSet = 'referenceSet';
    const Rows = 'rows';
    const Schema = 'schema';
    const ShortName = 'shortName';
    const Source = 'source';
    const Tags = 'tags';
    const &Type = 'type';
    const Uri = 'uri';
    const Url = 'url';
    const ValidFrom = 'validFrom';
    const ValidTo = 'validTo';
    const Value = 'value';
    const Version = 'version';
  end;

implementation

end.

