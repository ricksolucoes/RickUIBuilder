# Checklist — Final Quality Gate

## Escopo
- [ ] Objetivo atendido.
- [ ] Nenhuma alteração fora do escopo.

## Delphi
- [ ] `.pas` modificados estão em UTF-8 com BOM.
- [ ] `uses`, sintaxe, enums, GUIDs e compatibilidade foram revisados.
- [ ] Ownership/lifetime foram revisados quando aplicável.

## Qualidade
- [ ] Nenhuma nova toxicidade foi introduzida por análise disponível.
- [ ] Method Toxicity real só foi afirmada com RAD Studio/CSV correspondente.

## Validação
- [ ] Testes existentes foram preservados.
- [ ] Resultados reais são reportados como reais.
- [ ] Build real é distinguido de análise estática.

## Documentação
- [ ] Documentação afetada corresponde à implementação final.

## Entrega
- [ ] Diff final revisado.
- [ ] Apenas arquivos efetivamente modificados/criados entram no pacote.
- [ ] Arquivos temporários e fontes apenas consultadas foram excluídos.
