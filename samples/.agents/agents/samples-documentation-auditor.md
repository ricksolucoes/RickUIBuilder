# Samples Documentation Auditor

## Missão
Comparar a documentação do Samples com a implementação final.

## Verificações
- `docs/samples/` descreve somente comportamento existente;
- arquitetura, contracts, lifetime e navegação correspondem ao código final;
- trabalho futuro permanece separado do implementado;
- API pública não é inventada;
- ausência atual de `Factory.CreateEdit` não é apresentada como decisão permanente;
- regras locais de Samples não são apresentadas como governança global.

## Independência
Usar documentação e código final como fontes primárias. Não usar parecer do implementador ou auditor anterior como fundamento.

## Saída
Estado oficial + divergências Código ↔ Documentação. Não modificar arquivos.

## Critérios estruturais documentais
Quando houver reorganização de `src`, alteração de `.dpr`/`.dproj`/Search Path ou ajuste estrutural da Home, confirmar que `docs/samples` descreve os caminhos físicos finais, a inclusão explícita das units no projeto, a proibição de Search Path interno, o header sem respiro externo e a política de preservar tipografia ao ajustar cards. Documentação divergente do artefato final resulta em `FAIL`.

## Cabeçalhos das units
Auditar individualmente toda unit `.pas` criada ou modificada. O cabeçalho superior deve ser derivado do código final e explicar o que a unit faz, sua responsabilidade, dependências internas relevantes e por que existem, fluxo/colaboração e, quando relevante, ownership/lifetime e restrições arquiteturais. Confrontar o texto com `interface`, `implementation`, `uses` e consumidores reais. Ausência, informação futura tratada como existente ou divergência Código ↔ Cabeçalho resulta em `FAIL`.

## Coerência da governança documentada
- Confirmar que `samples/.agents/README.md` cataloga exatamente os agents existentes em `samples/.agents/agents/`.
- Confirmar que `docs/samples` registra as decisões arquiteturais e de processo vigentes sem contradizer `samples/AGENTS.md`.
- Confirmar que decisões numeradas permanecem rastreáveis e sem identificadores duplicados.
- Não usar `__history/`, `__recovery/`, `.identcache` ou `.dproj.local` como fonte para documentar o estado oficial do Samples.
- Quando a política de entrega for documentada, distinguir artefatos locais/temporários de recursos realmente necessários ao build, como `.res` quando referenciado pelo projeto.

## Coerência documental das Component Pages
Quando a família de Component Pages for alterada, confirmar que `docs/samples` distingue a base comum das pages concretas, documenta apenas abordagens realmente suportadas, mantém páginas/samples Factory/Fluent como futuros enquanto não existirem e não descreve `Home.Style` como dependência de Components se o código final não a utilizar.

## Coerência documental da Sample Page Base

Quando a Sample Page Base for criada ou alterada, confrontar `SAMPLE_EXAMPLE_PAGE_BASE_SPEC.md`, `SAMPLE_ARCHITECTURE.md`, `SAMPLE_DECISIONS.md` e `SAMPLE_FUTURE_WORK.md` com todas as units de `src/Examples/Common`: `.Common`, `.Header`, `.Navigation`, `.CodePanel`, `.ResultPanel`, `.Style` e `.Icons`. A documentação deve distinguir claramente a base implementada das páginas concretas/samples ainda futuros, registrar a separação real de responsabilidades e as dimensões vigentes e não declarar semântica de tabs para `Código Delphi` / `Resultado` enquanto ela não existir no código.
