# Skill — Documentation Consistency

## Objetivo

Garantir que README e documentação técnica descrevam o código real e permaneçam sincronizados.

## Regras

1. Código final é fonte primária.
2. Interfaces/types definem o contrato público.
3. Testes são evidência de comportamento, não substitutos do código.
4. Sample só documenta usos realmente suportados pela API.
5. README principal deve ser resumido; detalhes pertencem a `docs/<recurso>/`.
6. Não duplique documentação extensa em múltiplos locais.
7. Não documente recursos planejados como existentes.

## Paridade EN/pt-BR

Quando houver pares:

- mesma ordem estrutural;
- mesmos conceitos;
- mesmos exemplos e tabelas;
- links equivalentes por idioma;
- código equivalente;
- redação natural, não tradução literal.

## Mudanças que exigem revisão documental

- API pública;
- configuração/defaults;
- dependências/arquitetura;
- lifecycle/ownership;
- regras de seleção/filtro;
- comportamento visual/interativo documentado;
- baseline de testes/métricas apresentada ao usuário.
