# Skill — ComboBox Maintenance

## Antes de qualquer alteração

Leia obrigatoriamente:

1. `../../docs/combobox/README.pt-BR.md`;
2. `../../docs/combobox/arquitetura-e-dependencias.pt-BR.md`;
3. `../../docs/combobox/manutencao-e-armadilhas.pt-BR.md`.

Depois leia o documento específico:

| Assunto | Documento |
|---|---|
| API/config | `api-publica-e-configuracao.pt-BR.md` |
| Dados/filtro/seleção | `dados-selecao-e-filtro.pt-BR.md` |
| Presentation | `presentation-modes.pt-BR.md` |
| FullWindow/search | `fullwindow-e-pesquisa.pt-BR.md` |
| Virtualização/render | `virtualizacao-e-renderizacao.pt-BR.md` |
| Lifetime/ownership | `lifecycle-ownership-e-handle.pt-BR.md` |
| Uso/customização | `customizacao-e-exemplos.pt-BR.md` |
| Testes | `testes-e-contratos.pt-BR.md` |

## Invariantes críticas

- `ViewIndex` não é `SourceIndex` quando existe filtro.
- Filtrar não remove nem reordena a coleção fonte.
- FullWindow reutiliza o mesmo `Data` e o mesmo `Virtualizer`; não crie uma segunda engine de lista.
- `Data` não manipula controles FMX.
- `Presentation` não implementa o filtro da coleção.
- `StyleType` e `PresentationMode` são conceitos distintos.
- Mobile + `Auto` resolve para FullWindow; Desktop + `Auto` resolve para Anchored no comportamento documentado.
- Anchor Parent e Presentation Host são responsabilidades diferentes.
- Back/Clear usam áreas de hit; o `TPath` interno é visual.
- Clear depende de `Length(SearchEdit.Text)`, não de `Trim`.
- `TPathData.Data` não deve ser tratado como identidade textual persistente do SVG; normalize antes de comparar em testes.
- Handle runtime não assume ownership da árvore visual e deve refletir detach corretamente.

## Após alterar

- execute/reavalie os testes ComboBox pertinentes;
- execute a suíte completa quando possível;
- reavalie Method Toxicity dos `.pas` alterados;
- revise os documentos `docs/combobox` afetados pelo comportamento modificado.
