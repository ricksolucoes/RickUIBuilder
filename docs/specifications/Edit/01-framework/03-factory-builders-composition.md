# Owner FRM-CREATION — Factory, Builders e Composition

## Factory

`TRickUIBuilderFactory` cria controles FMX diretamente a partir de records de configuração e recebe `AOwner` e `AParent`.

**Evidência:** `src/Rick.UIBuilder.Factory.pas`, cabeçalho da unit e declarações públicas.

## Fluent Builder

Builders acumulam configuração e materializam o controle em `Build`.

Exemplos comprovados:

- Label delega criação fundamental para `TRickUIBuilderFactory.CreateText`;
- Divider delega para `CreateDivider`;
- Button usa `BuildCore`, que delega para `CreateButton`;
- ComboBox usa `BuildCore`, cria estado/dados necessários e delega o controle fechado para `CreateComboBox`.

**Evidências:**
- `src/Rick.UIBuilder._Label.pas`, linhas 272–304;
- `src/Rick.UIBuilder.Divider.pas`, linhas 165–202;
- `src/Rick.UIBuilder.Button.pas`, linhas 390–420;
- `src/Rick.UIBuilder.ComboBox.pas`, linhas 394–439.

## Composition

Composition é diferente dos builders: `Add*` cria imediatamente o controle no Parent associado, delegando para Factory.

**Evidência:** `src/Rick.UIBuilder.Composition.pas`, cabeçalho e métodos `Add*`.

## Cinco alternativas para integrar Edit

1. **Factory apenas** — coerente somente se o recurso for criação direta simples e não precisar de API fluent/runtime.
2. **Builder apenas** — divergiria do padrão atual de delegar materialização fundamental para Factory nos builders existentes.
3. **Factory + Builder** — compatível com componentes configuráveis atuais, mas não prova necessidade de Handle.
4. **Factory + Builder + Handle** — compatível com componentes que precisam de acesso runtime, mas Handle não deve existir por simetria.
5. **Arquitetura proporcional após fechar o contrato funcional** — preserva o padrão brownfield e evita copiar o ComboBox.

**Decisão documental:** opção 5.

Motivo: o repositório determina arquitetura proporcional à responsabilidade real; sem contrato funcional confirmado do Edit, selecionar antecipadamente Handle, State, Presentation ou outras camadas seria invenção.
