unit Rick.UIBuilder.Edit.Types;

interface

{$SCOPEDENUMS ON}

uses
  System.UITypes;

type
  TRickUIBuilderEditPreset = (AllCharacters, CPF, CNPJ, CEP, Email, URL, Phone,
    Mobile, IntegerNumber, FloatNumber, TextNoAccents, TextPunctuationNoAccents,
    TextWithAccents, TextPunctuationWithAccents);

  TRickUIBuilderEditNumberFormatMode = (Locale, Custom);

  TRickUIBuilderEditCaseMode = (Preserve, Uppercase, Lowercase);

  TRickUIBuilderEditUrlCaseMode = (SchemeAndHost, EntireValue);

  TRickUIBuilderEditInvalidFeedback = (AlertOnly, IconOnly, AlertAndIcon);

  TRickUIBuilderEditAppearance = (Outlined, Underline);


implementation


end.
