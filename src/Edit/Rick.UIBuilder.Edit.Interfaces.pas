unit Rick.UIBuilder.Edit.Interfaces;

interface

uses
  Rick.UIBuilder.Edit.Types,

  FMX.Edit,
  FMX.Types,
  FMX.Objects,

  System.UITypes;

type
  IRickUIBuilderEdit = interface;

  IRickUIBuilderEditRetangle = interface;
  IRickUIBuilderEditRetanglePosition = interface;
  IRickUIBuilderEditRetangleSize = interface;
  IRickUIBuilderEditRetangleBackground = interface;
  IRickUIBuilderEditRetangleBorder = interface;

  IRickUIBuilderEditLabel = interface;
  IRickUIBuilderEditLabelMain = interface;
  IRickUIBuilderEditLabelMainText = interface;
  IRickUIBuilderEditLabelMainTextColor = interface;
  IRickUIBuilderEditLabelCounter = interface;

  IRickUIBuilderEditLabelError = interface;
  IRickUIBuilderEditLabelErrorText = interface;
  IRickUIBuilderEditLabelErrorTextFont = interface;

  IRickUIBuilderEditDesigner = interface;
  IRickUIBuilderEditDesignerValidation = interface;
  IRickUIBuilderEditDesignerConfig = interface;
  IRickUIBuilderEditDesignerInput = interface;
  IRickUIBuilderEditDesignerInputText = interface;
  IRickUIBuilderEditDesignerInputTextColor = interface;
  IRickUIBuilderEditDesignerInputNumber = interface;
  IRickUIBuilderEditDesignerInputConfig = interface;

  IRickUIBuilderEditLine = interface;
  IRickUIBuilderEditLineColor = interface;

  IRickUIBuilderEditConfig = interface;
  IRickUIBuilderEditConfigIcons = interface;
  IRickUIBuilderEditConfigIconColors = interface;
  IRickUIBuilderEditConfigIconPaths = interface;


  { -------------------------------------------------------------------------- }
  { Rectangle                                                                 }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditRetangle = interface
    function Position: IRickUIBuilderEditRetanglePosition;
    function Size: IRickUIBuilderEditRetangleSize;
    function Background: IRickUIBuilderEditRetangleBackground;
    function Border: IRickUIBuilderEditRetangleBorder;

    function CornerRadius(AValue: Single): IRickUIBuilderEditRetangle;

    function Control: TRectangle;

    function ToBack: IRickUIBuilderEdit;
  end;


  { -------------------------------------------------------------------------- }
  { Rectangle.Position                                                        }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditRetanglePosition = interface
    function Left(AValue: Single): IRickUIBuilderEditRetanglePosition;
    function Top(AValue: Single): IRickUIBuilderEditRetanglePosition;

    function ToBack: IRickUIBuilderEditRetangle;
  end;


  { -------------------------------------------------------------------------- }
  { Rectangle.Size                                                            }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditRetangleSize = interface
    function Width(AValue: Single): IRickUIBuilderEditRetangleSize;
    function Height(AValue: Single): IRickUIBuilderEditRetangleSize;

    function ToBack: IRickUIBuilderEditRetangle;
  end;


  { -------------------------------------------------------------------------- }
  { Rectangle.Background                                                      }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditRetangleBackground = interface
    function Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBackground;

    function ToBack: IRickUIBuilderEditRetangle;
  end;


  { -------------------------------------------------------------------------- }
  { Rectangle.Border                                                          }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditRetangleBorder = interface
    function Thickness(AValue: Single): IRickUIBuilderEditRetangleBorder;

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditRetangleBorder;

    function ToBack: IRickUIBuilderEditRetangle;
  end;


  { -------------------------------------------------------------------------- }
  { Labels                                                                     }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLabel = interface
    function Main: IRickUIBuilderEditLabelMain;
    function Counter: IRickUIBuilderEditLabelCounter;
    function Error: IRickUIBuilderEditLabelError;

    function ToBack: IRickUIBuilderEdit;
  end;


  { -------------------------------------------------------------------------- }
  { Labels.Main                                                                }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLabelMain = interface
    function Text: IRickUIBuilderEditLabelMainText;

    function ToBack: IRickUIBuilderEditLabel;
  end;

  { -------------------------------------------------------------------------- }
  { Labels.Main.Text                                                                }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLabelMainText = interface
    function Value(const AValue: string): IRickUIBuilderEditLabelMainText;
    function Size(AValue: Single): IRickUIBuilderEditLabelMainText;
    function Color: IRickUIBuilderEditLabelMainTextColor;

    function ToBack: IRickUIBuilderEditLabelMain;
  end;

  { -------------------------------------------------------------------------- }
  { Labels.Main.Text.Color                                                                }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLabelMainTextColor = interface

    function Text(AValue: TAlphaColor): IRickUIBuilderEditLabelMainTextColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLabelMainText;

    function ToBack: IRickUIBuilderEditLabelMainText;
  end;


  { -------------------------------------------------------------------------- }
  { Labels.Counter                                                             }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLabelCounter = interface
    function Enabled(AValue: Boolean): IRickUIBuilderEditLabelCounter; overload;
    function Enabled: IRickUIBuilderEditLabelCounter; overload;

    function ToBack: IRickUIBuilderEditLabel;
  end;


  { -------------------------------------------------------------------------- }
  { Labels.Error                                                               }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLabelError = interface
    function Text: IRickUIBuilderEditLabelErrorText;

    function ToBack: IRickUIBuilderEditLabel;
  end;

  { -------------------------------------------------------------------------- }
  { Labels.Error.Text                                                          }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLabelErrorText = interface
    function Value(AValue: string): IRickUIBuilderEditLabelErrorText;
    function Color(AValue: TAlphaColor): IRickUIBuilderEditLabelErrorText;
    function Spacing(AValue: Single): IRickUIBuilderEditLabelErrorText;

    function Font: IRickUIBuilderEditLabelErrorTextFont;

    function ToBack: IRickUIBuilderEditLabelError;
  end;

  { -------------------------------------------------------------------------- }
  { Labels.Error.Text.Font                                                     }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLabelErrorTextFont = interface
    function Family(const AValue: string): IRickUIBuilderEditLabelErrorTextFont;
    function Size(AValue: Single): IRickUIBuilderEditLabelErrorTextFont;
    function Styles(AValue: TFontStyles): IRickUIBuilderEditLabelErrorTextFont;

    function ToBack: IRickUIBuilderEditLabelErrorText;
  end;

  { -------------------------------------------------------------------------- }
  { Edit                                                                      }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditDesigner = interface
    function Input: IRickUIBuilderEditDesignerInput;
    function Validation: IRickUIBuilderEditDesignerValidation;
    function Config: IRickUIBuilderEditDesignerConfig;

    function Clear: IRickUIBuilderEditDesigner;
    function Control: TEdit;

    function ToBack: IRickUIBuilderEdit;
  end;

  { -------------------------------------------------------------------------- }
  { Edit.Input                                                                }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditDesignerInput = interface
    function Text : IRickUIBuilderEditDesignerInputText;
    function Number: IRickUIBuilderEditDesignerInputNumber;
    function Config: IRickUIBuilderEditDesignerInputConfig;


    function ToBack: IRickUIBuilderEditDesigner;
  end;

  { -------------------------------------------------------------------------- }
  { Edit.Input.Text                                                           }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditDesignerInputText = interface
    function Value(const AValue: string): IRickUIBuilderEditDesignerInputText; overload;
    function Value: string; overload;

    function Color : IRickUIBuilderEditDesignerInputTextColor;

    function Size(AValue: Single): IRickUIBuilderEditDesigner;

    function ToBack: IRickUIBuilderEditDesigner;
  end;

  { -------------------------------------------------------------------------- }
  { Edit.Input.Text.Color                                                     }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditDesignerInputTextColor = interface
    function Background(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function Text(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditDesignerInputTextColor;

    function ToBack: IRickUIBuilderEditDesignerInputText;
  end;

  { -------------------------------------------------------------------------- }
  { Edit.Input.Number                                                         }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditDesignerInputNumber = interface
    function AllowNegative(AValue: Boolean): IRickUIBuilderEditDesignerInputNumber; overload;
    function AllowNegative: IRickUIBuilderEditDesignerInputNumber; overload;

    function DecimalPlaces(AValue: Integer): IRickUIBuilderEditDesignerInputNumber;
    function FormatMode(AValue: TRickUIBuilderEditNumberFormatMode): IRickUIBuilderEditDesignerInputNumber;
    function DecimalSeparator(AValue: Char): IRickUIBuilderEditDesignerInputNumber;
    function ThousandSeparator(AValue: Char): IRickUIBuilderEditDesignerInputNumber;

    function UseThousandSeparator(AValue: Boolean): IRickUIBuilderEditDesignerInputNumber; overload;
    function UseThousandSeparator: IRickUIBuilderEditDesignerInputNumber; overload;

    function ToBack: IRickUIBuilderEditDesignerInput;
  end;

  { -------------------------------------------------------------------------- }
  { Edit.Input.Config                                                         }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditDesignerInputConfig = interface

    function Preset(AValue: TRickUIBuilderEditPreset): IRickUIBuilderEditDesignerInputConfig;
    function CaseMode(AValue: TRickUIBuilderEditCaseMode): IRickUIBuilderEditDesignerInputConfig;
    function UrlCaseMode(AValue: TRickUIBuilderEditUrlCaseMode): IRickUIBuilderEditDesignerInputConfig;
    function MaxLength(AValue: Integer): IRickUIBuilderEditDesignerInputConfig;

    function ToBack: IRickUIBuilderEditDesignerInput;
  end;


  { -------------------------------------------------------------------------- }
  { Edit.Validation                                                           }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditDesignerValidation = interface
    function Required(AValue: Boolean): IRickUIBuilderEditDesignerValidation; overload;
    function Required: IRickUIBuilderEditDesignerValidation; overload;

    function RequirementIndicator(AValue: Boolean): IRickUIBuilderEditDesignerValidation; overload;
    function RequirementIndicator: IRickUIBuilderEditDesignerValidation; overload;

    function Feedback(AValue: TRickUIBuilderEditInvalidFeedback): IRickUIBuilderEditDesignerValidation;
    function DefaultMessage(const AValue: string): IRickUIBuilderEditDesignerValidation;

    function Invalid(AValue: Boolean): IRickUIBuilderEditDesignerValidation; overload;
    function Invalid(const AMessage: string): IRickUIBuilderEditDesignerValidation; overload;
    function Invalid(AValue: Boolean; const AMessage: string): IRickUIBuilderEditDesignerValidation; overload;

    function HasInvalid: Boolean;
    function InvalidValue: Boolean;
    function InvalidMessage: string;

    function RequirementMet(AValue: Boolean): IRickUIBuilderEditDesignerValidation; overload;
    function RequirementMet: IRickUIBuilderEditDesignerValidation; overload;

    function HasRequirementMet: Boolean;
    function RequirementMetValue: Boolean;

    function ToBack: IRickUIBuilderEditDesigner;
  end;

  { -------------------------------------------------------------------------- }
  { Edit.Config                                                                      }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditDesignerConfig = interface
    function ClearButton(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function ClearButton: IRickUIBuilderEditDesignerConfig; overload;

    function Password(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function Password: IRickUIBuilderEditDesignerConfig; overload;

    function ReadOnly(AValue: Boolean): IRickUIBuilderEditDesignerConfig; overload;
    function ReadOnly: IRickUIBuilderEditDesignerConfig; overload;

    function ToBack: IRickUIBuilderEditDesigner;
  end;

  { -------------------------------------------------------------------------- }
  { Line                                                                      }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLine = interface
    function Thickness(AValue: Single): IRickUIBuilderEditLine;

    function Color: IRickUIBuilderEditLineColor;

    function ToBack: IRickUIBuilderEdit;
  end;

  { -------------------------------------------------------------------------- }
  { Line.Color                                                                      }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditLineColor = interface

    function Normal(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Focus(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function Invalid(AValue: TAlphaColor): IRickUIBuilderEditLineColor;
    function ReadOnly(AValue: TAlphaColor): IRickUIBuilderEditLineColor;

    function ToBack: IRickUIBuilderEditLine;
  end;

  { -------------------------------------------------------------------------- }
  { Config                                                                     }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditConfig = interface
    function Appearance(AValue: TRickUIBuilderEditAppearance): IRickUIBuilderEditConfig;

    function Icons: IRickUIBuilderEditConfigIcons;

    function ToBack: IRickUIBuilderEdit;
  end;


  { -------------------------------------------------------------------------- }
  { Config.Icons                                                               }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditConfigIcons = interface
    function Size(AValue: Single): IRickUIBuilderEditConfigIcons;

    function Colors: IRickUIBuilderEditConfigIconColors;
    function Paths: IRickUIBuilderEditConfigIconPaths;

    function ToBack: IRickUIBuilderEditConfig;
  end;


  { -------------------------------------------------------------------------- }
  { Config.Icons.Colors                                                        }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditConfigIconColors = interface
    function Default(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function Alert(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function Clear(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function Password(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;
    function Requirement(AValue: TAlphaColor): IRickUIBuilderEditConfigIconColors;

    function ToBack: IRickUIBuilderEditConfigIcons;
  end;


  { -------------------------------------------------------------------------- }
  { Config.Icons.Paths                                                         }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEditConfigIconPaths = interface
    function Alert(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function Clear(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function Visibility(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function VisibilityOff(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function RequirementMet(const AValue: string): IRickUIBuilderEditConfigIconPaths;
    function RequirementNotMet(const AValue: string): IRickUIBuilderEditConfigIconPaths;

    function ToBack: IRickUIBuilderEditConfigIcons;
  end;


  { -------------------------------------------------------------------------- }
  { Edit                                                                       }
  { -------------------------------------------------------------------------- }

  IRickUIBuilderEdit = interface

    function Rectangle: IRickUIBuilderEditRetangle;
    function Labels: IRickUIBuilderEditLabel;
    function Edit: IRickUIBuilderEditDesigner;
    function Line: IRickUIBuilderEditLine;
    function Config: IRickUIBuilderEditConfig;

    function Parent(AParentConstructor: TFmxObject): IRickUIBuilderEdit;
    function Build: IRickUIBuilderEdit;
  end;

implementation

end.
