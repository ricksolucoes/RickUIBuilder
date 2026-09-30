(******************************************************************************}
  Unit: RickUIBuilder.Samples.App.Bootstrap

  FINALIDADE
  Composition Root do executável Samples.

  FUNCIONALIDADE
  Inicializa a composição da aplicação e mantém o ciclo de vida do Coordinator, Presenter e Home durante a execução.

  DEPENDÊNCIAS DO PROJETO
  - RickUIBuilder.Samples.App.Coordinator — fornece o coordenador de fluxo criado e possuído pelo bootstrap.
  - RickUIBuilder.Samples.Home.Presenter — cria a implementação de IHomePresenter ligada ao Coordinator.
  - RickUIBuilder.Samples.Home — fornece a View principal executada pelo Samples.
  - RickUIBuilder.Samples.Home.Presenter.Intf — define o contrato mantido pela Home.

  FLUXO / COLABORAÇÃO
  - Cria o Coordinator, cria o Presenter, injeta-o na Home e executa Application.Run.
  - A Home é destruída antes do Coordinator; o Presenter referencia o Coordinator de forma não-owning.

  RESTRIÇÕES E RESPONSABILIDADES
  - Não contém regras visuais da Home nem regras de negócio dos componentes.
  - É o ponto de composição das dependências do executável Samples.

  Manutenção: este cabeçalho deve ser atualizado quando responsabilidade,
  dependências, fluxo, ownership/lifetime ou restrições desta unit mudarem.
******************************************************************************)
unit RickUIBuilder.Samples.App.Bootstrap;

interface

uses
  RickUIBuilder.Samples.App.Coordinator;

type
  /// <summary>Composition Root do executavel Samples.</summary>
  TSampleApplication = class
  strict private
    /// <summary>Executa o ciclo da Home usando o Coordinator informado.</summary>
    class function Execute(const ACoordinator: TSampleApplicationCoordinator): Integer; static;
  public
    /// <summary>Inicializa a composição e executa o loop principal do Samples.</summary>
    class function Run: Integer; static;
  end;

implementation

uses
  FMX.Forms,
  RickUIBuilder.Samples.Home,
  RickUIBuilder.Samples.Home.Presenter,
  RickUIBuilder.Samples.Home.Presenter.Intf;

class function TSampleApplication.Run: Integer;
var
  LCoordinator: TSampleApplicationCoordinator;
begin
  LCoordinator := TSampleApplicationCoordinator.Create;
  try
    Result := Execute(LCoordinator);
  finally
    LCoordinator.Free;
  end;
end;

class function TSampleApplication.Execute(
  const ACoordinator: TSampleApplicationCoordinator): Integer;
var
  LHome: TPageSamplesHome;
  LPresenter: IHomePresenter;
begin
  LPresenter := THomePresenter.New(ACoordinator);
  LHome := TPageSamplesHome.Create(nil, LPresenter);
  try
    LHome.Show;
    Application.Run;
  finally
    LHome.Free;
  end;
  Result := 0;
end;

end.
