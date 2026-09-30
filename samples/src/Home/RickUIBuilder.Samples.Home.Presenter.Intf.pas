(******************************************************************************
  Unit: RickUIBuilder.Samples.Home.Presenter.Intf

  FINALIDADE
  Contrato de apresentação da Home.

  FUNCIONALIDADE
  Define as operações pelas quais a Home comunica intenção de fechar o Samples ou abrir um componente.

  DEPENDÊNCIAS DO PROJETO
  - RickUIBuilder.Samples.App.Types — fornece TSampleComponent usado por OpenComponent.

  FLUXO / COLABORAÇÃO
  - TPageSamplesHome depende deste contrato; THomePresenter o implementa e delega as operações ao Coordinator.

  RESTRIÇÕES E RESPONSABILIDADES
  - Contratos do Samples usam function, não procedure.
  - O contrato não expõe tipos visuais FMX nem conhece a View concreta.

  Manutenção: este cabeçalho deve ser atualizado quando responsabilidade,
  dependências, fluxo, ownership/lifetime ou restrições desta unit mudarem.
******************************************************************************)
unit RickUIBuilder.Samples.Home.Presenter.Intf;

interface

uses
  RickUIBuilder.Samples.App.Types;

type
  /// <summary>Contrato das intencoes emitidas pela Home.</summary>
  IHomePresenter = interface
    ['{8C0C0A2B-E31C-4D48-8A63-29DAB91C61C5}']
    /// <summary>Solicita o encerramento do Samples.</summary>
    function Close: IHomePresenter;
    /// <summary>Solicita a abertura do componente informado.</summary>
    function OpenComponent(const AComponent: TSampleComponent): IHomePresenter;
  end;

implementation

end.
