# Owner FRM-LIFETIME — Build, Handle, Owner e lifetime

## Build usa o Parent também como Owner em builders simples

Isso é comprovado em:

- Label: `CreateText(AParent, AParent, ...)`;
- Divider: `CreateDivider(AParent, AParent, ...)`;
- Badge: `CreateBadge(AParent, AParent, ...)`;
- Button: `CreateButton(AParent, AParent, ...)`;
- ComboBox: `CreateComboBox(AParent, AParent, ...)`.

**Evidências:** `Rick.UIBuilder._Label.pas` 272–281; `Rick.UIBuilder.Divider.pas` 165–180; `Rick.UIBuilder.Badge.pas` 256–277; `Rick.UIBuilder.Button.pas` 390–401; `Rick.UIBuilder.ComboBox.pas` 394–420.

## Handle não implica ownership dos controles

O Button Handle declara explicitamente ser non-owning em relação aos controles FMX.

**Evidência:** `src/Rick.UIBuilder.Button.Handle.pas`, cabeçalho e comentários de `TRickUIBuilderButtonHandle`.

O ComboBox possui um lifecycle mais complexo, com attach/detach visual e limpeza de handlers/presentation.

**Evidência:** `src/Rick.UIBuilder.ComboBox.Handle.pas`, `DetachVisual`, `IsAttached`, `Destroy`.

## Regra para o Edit

Não criar Handle apenas para seguir simetria.

Se o contrato do Edit exigir operações pós-Build, o lifetime deve ser especificado antes do código:

- quem possui a árvore FMX;
- se o Handle é non-owning;
- o que acontece após destruição do Owner;
- como callbacks/eventos são desligados;
- se existe estado lógico que sobrevive ou não ao visual.

Essas respostas específicas do Edit estão **Não confirmadas** nas fontes permitidas.
