{***************************************************************************}
{                                                                           }
{           OpenCodeList                                                    }
{                                                                           }
{           Copyright (c) STÜBER SYSTEMS GmbH                               }
{                                                                           }
{           Licensed under the MIT License, Version 2.0.                    }
{                                                                           }
{***************************************************************************}

unit OpenCodeList.BaseObjects;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Net.URLClient;

type

  /// <summary>
  /// Base class for OpenCodeList model classes
  /// </summary>
  TBaseObject = class abstract
  public

    /// <summary>
    /// Serializes the content to a given <see cref="TJSONObject"/> instance.
    /// </summary>
    /// <param name="JsonObject">The JSON object</param>
    procedure WriteTo(JsonObject: TJSONObject); virtual; abstract;

  end;

  /// <summary>
  /// Base class for identifiable model classes
  /// </summary>
  TIdentifiableObject = class abstract(TBaseObject)
  private
    FId: string;
  public

    /// <summary>
    /// The ID of the object.
    /// </summary>
    property Id: string read FId write FId;

  end;

implementation

end.

