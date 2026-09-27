# Checklist de verificação — Rick.UIBuilder Source

Este roteiro deve ser seguido manualmente a cada release do framework, antes de publicar. O Sample (`sample/RickUIBuilder.Sample.dpr`) não substitui os testes automatizados — cobre o que eles não cobrem: a aparência real e a interação dos controles renderizados.

Rode o Sample e confira cada item abaixo, na ordem em que aparecem na tela.

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

## Seção 3 — ComboBox - matriz visual

- [ ] Os exemplos Desktop, Mobile, Adaptive, Custom e Custom FullWindow aparecem sem sobreposição.
- [ ] Os modos Anchored e FullWindow abrem e fecham corretamente.
- [ ] Pesquisa, seleção, Value, colunas e owner-draw permanecem operacionais nos exemplos correspondentes.
- [ ] O ComboBox configurado em runtime reflete a alteração de arrow color e os itens adicionados após o Build.

## Seção 4 — Composição (meio-termo)

- [ ] O texto, divisor, badge "Composição" e botão "Botão da composição" aparecem em sequência vertical, sem sobreposição entre eles.
- [ ] O badge "Composição" aparece com o mesmo estilo visual (fundo verde claro, texto verde escuro, pílula) configurado no `TRickUIBuilderBadgeConfig` passado a `AddBadge`.

## Verificação geral

- [ ] Nenhum controle aparece cortado, sobreposto ou fora da área visível do formulário (role a tela se necessário).
- [ ] Redimensionar a janela não quebra o layout de forma grosseira (os controles usam posicionamento absoluto, então algum overflow lateral é esperado — o objetivo aqui é só confirmar que nada quebra visualmente de forma inesperada).
- [ ] Fechar o Source não deixa nenhuma exceção pendente no console/log.

---

Se qualquer item falhar, **não publique a versão** até identificar se a causa é uma regressão no framework ou apenas no próprio Sample.
## Seção 5 — Edit runtime

### Documentos e contato

- [ ] CPF aplica progressivamente `000.000.000-00` durante a digitação.
- [ ] CNPJ aceita base alfanumérica e apresenta `AA.AAA.AAA/AAAA-00`.
- [ ] CEP aplica `00000-000`.
- [ ] E-mail converte a entrada para lowercase.
- [ ] Telefone e celular funcionam com e sem DDD conforme a quantidade de dígitos.

### Números, texto e case

- [ ] Inteiro aceita sinal negativo no exemplo configurado.
- [ ] Float funciona no modo `Locale` e no modo `Custom`; o exemplo custom aceita negativo, duas casas e separadores explícitos.
- [ ] Os cinco exemplos textuais respeitam as diferenças de acentos/pontuação/all characters.
- [ ] Uppercase e lowercase transformam a entrada conforme configurado.
- [ ] URL `SchemeAndHost` preserva o case fora de scheme/host; `EntireValue` converte todo o valor.

### Recursos visuais e runtime

- [ ] O campo com `MaxLength(20)` nunca termina acima do limite e o contador exibe `atual/20`.
- [ ] O clear aparece quando há conteúdo e limpa o campo.
- [ ] O ícone de senha alterna entre conteúdo oculto e visível.
- [ ] Os exemplos `AlertOnly`, `IconOnly` e `AlertAndIcon` exibem somente os elementos previstos por cada modo.
- [ ] "Marcar inválido" aplica borda/fundo/feedback no exemplo interativo; "Marcar válido" restaura o estado correspondente ao foco.
- [ ] Os botões de requisito alternam visualmente entre atendido e não atendido.

### Copiar e colar

- [ ] "Copiar válido" + "Colar no alvo" transfere `123.456.789-01` para o CPF alvo.
- [ ] Depois de existir um valor válido no alvo, "Copiar sem máscara" + "Colar no alvo" rejeita `12345678901` e preserva o último conteúdo válido.
- [ ] Ctrl+C/Ctrl+V (ou equivalente da plataforma) continua disponível diretamente nos `TEdit`.
- [ ] Seleção, caret e foco continuam operacionais após copy/paste e após rejeição de entrada.

O Sample é uma bancada manual. Um item visual aprovado aqui não substitui a suíte DUnitX, build real ou relatório de Method Toxicity Metrics.
