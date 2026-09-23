# Manutenção e Armadilhas

> [English](manutencao-e-armadilhas.md) | [Português do Brasil](manutencao-e-armadilhas.pt-BR.md)

## Finalidade

Leia este documento antes de alterar internamente o ComboBox. Ele registra restrições fáceis de violar porque várias camadas compartilham índices, objetos FMX e eventos runtime.

## Não repetir erros já resolvidos

- Não tratar `ViewIndex` filtrado como `ItemIndex` de origem confirmado.
- Não implementar filtro removendo/reordenando `FItems`.
- Não criar renderer de lista Mobile separado.
- Não transformar Overlay em FullWindow.
- Não assumir que o parent do anchor é o host FullWindow.
- Não colocar o contrato de interação na geometria exata do `TPath` de Back/Clear.
- Não usar `Trim` para visibilidade do Clear; o contrato é `Length(Text) > 0`.
- Não adicionar guard clauses que apenas escondem um objeto obrigatório ausente; corrija criação/lifetime quando o objeto é obrigatório.
- Não liberar duas vezes filhos FMX já gerenciados por owner/parent.

## Disciplina de índices

```text
Source Items
    ↓
FilterText
    ↓
FilteredIndexes
    ↓
ViewIndex
    ↓
SourceIndex
```

`ViewIndex` é índice da view atual filtrada/não filtrada. `SourceIndex` identifica o item lógico em `FItems`. Rows armazenam source index em `Tag`; a posição Y da row é baseada em view index. APIs de seleção expõem source index.

## Seleção versus target

A seleção confirmada vive em `Data.FItemIndex`. Navegação por teclado/hover com o controle aberto usa `State.TargetIndex`. Mover o target não deve disparar `OnChange`. `ConfirmTarget` seleciona o target e depois fecha; Back/Escape podem fechar sem confirmar o target.

## TPathData não é identidade textual

Atribuir texto SVG/path a `TPathData.Data` faz parsing. Ler `Data` pode retornar uma serialização canônica diferente da string de entrada original. Em testes, normalize esperado e real via `TPathData`, ou use outro identificador semântico. Não compare texto de entrada bruto com `Data` serializado presumindo igualdade.

## Hit targets dos paths

Paths de Back/Clear usam `HitTest = False`. Seus parents `TLayout` possuem o comportamento de clique. Isso é necessário para tornar toda a área touch/click reservada interativa, e não apenas a geometria visível do glyph.

## Estilo do SearchEdit

O edit fica embutido no retângulo arredondado de pesquisa. `transparentedit`, focus effect desabilitado e `SearchField.ClipChildren = True` fazem parte da integração visual atual. Alterar o style do edit pode reintroduzir underline/background nativo ou desenho fora dos limites do campo arredondado.

## Lifecycle e FreeNotification

Referências raw FMX precisam ser invalidadas na remoção de componentes. Behavior, Presentation e Virtualizer observam objetos diferentes. Antes de alterar ordem de destruição, mapeie owner, parent, origem de FreeNotification e responsabilidade de free manual de cada objeto afetado.

## Build versus BuildHandle

Não remova a referência de lifetime mantida pelo behavior apenas porque `BuildHandle` existe. `Build` funciona intencionalmente sem o caller preservar um handle. Da mesma forma, não faça o handle possuir a árvore visual; handles preservados podem se tornar detached.

## Style versus presentation

A resolução de style pode mudar defaults de height/item height/arrow size. Presentation determina posicionamento da superfície. Overrides explícitos do builder para geometrias selecionadas são restaurados após style resolution. Mantenha esses mecanismos separados para evitar que mudanças de style alterem valores explícitos do consumidor.

## Mudanças de virtualização

Qualquer alteração no row pool deve preservar `Tag` como source index, mapeamento da view filtrada, `EnsureIndexVisible`, estados selected/target, source index passado ao callback e altura do conteúdo rolável. Teste com listas maiores que o viewport e filtros aplicados depois de scroll.

## Regra de atualização de documentação e testes

Ao alterar um contrato documentado, atualize implementação, cobertura DUnitX e o par correspondente EN/pt-BR na mesma mudança. Mantenha headings/exemplos estruturalmente equivalentes entre os idiomas.

## Checklist antes de alterar

1. Identifique a camada que possui o comportamento a ser alterado.
2. Leia o par de documentos correspondente e as source units.
3. Revise os testes atuais que protegem esse comportamento.
4. Preserve invariantes de índice e ownership.
5. Execute os testes focados do ComboBox e depois a suíte completa.
6. Valide visualmente nas plataformas target quando presentation/style mudar.
7. Atualize ambos os idiomas antes da entrega.
