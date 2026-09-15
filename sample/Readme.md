# Checklist de verificação — Rick.UIBuilder Source

Este roteiro deve ser seguido manualmente a cada release do framework, antes de publicar. O Source (`Source/RickUIBuilderSource.dpr`) não substitui os testes automatizados — cobre o que eles não cobrem: a aparência real dos controles renderizados.

Rode o Source e confira cada item abaixo, na ordem em que aparecem na tela.

## Seção 1 — Factory (Opção A)

- [ ] O texto "CreateText: este texto..." aparece com a cor de texto padrão, alinhado à esquerda.
- [ ] O divisor logo abaixo do texto aparece como uma linha cinza de 1px, ocupando toda a largura do conteúdo.
- [ ] O badge "CreateBadge" aparece com fundo verde claro, texto verde escuro, cantos totalmente arredondados (pílula).
- [ ] O botão "CreateButton" aparece azul, com texto branco, cantos arredondados, e reage ao cursor de mão ao passar o mouse.

## Seção 2 — Builders fluentes (Opção B)

- [ ] O label "Label via builder fluente..." aparece em **negrito**.
- [ ] O divisor abaixo do label aparece mais grosso que o divisor da Seção 1 (Thickness 2 vs. 1).
- [ ] Os dois badges "Pill (True)" e "Pill (False)" aparecem lado a lado: o primeiro com cantos totalmente arredondados, o segundo com cantos levemente arredondados (raio de 6px), não retos e não em pílula.
- [ ] Passe o mouse sobre o botão "Passe o mouse e clique": a cor de fundo deve escurecer (de azul para azul mais escuro) enquanto o cursor permanece sobre o botão, e voltar à cor original ao tirar o mouse.
- [ ] Clique no botão 3 vezes: o texto "Cliques: N" ao lado deve atualizar para "Cliques: 3".

## Seção 3 — Composição (meio-termo)

- [ ] O texto, divisor, badge "Composição" e botão "Botão da composição" aparecem em sequência vertical, sem sobreposição entre eles.
- [ ] O badge "Composição" aparece com o mesmo estilo visual (fundo verde claro, texto verde escuro, pílula) configurado no `TRickUIBuilderBadgeConfig` passado a `AddBadge`.

## Verificação geral

- [ ] Nenhum controle aparece cortado, sobreposto ou fora da área visível do formulário (role a tela se necessário).
- [ ] Redimensionar a janela não quebra o layout de forma grosseira (os controles usam posicionamento absoluto, então algum overflow lateral é esperado — o objetivo aqui é só confirmar que nada quebra visualmente de forma inesperada).
- [ ] Fechar o Source não deixa nenhuma exceção pendente no console/log.

---

Se qualquer item falhar, **não publique a versão** até identificar se a causa é uma regressão no framework ou apenas no próprio Source.