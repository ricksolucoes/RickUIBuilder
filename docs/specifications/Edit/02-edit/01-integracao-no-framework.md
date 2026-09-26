# Owner EDIT-INTEGRATION — Integração do novo domínio Edit

## Fato confirmado

O snapshot 0.2.2 não contém um componente Edit na facade nem no package.

## Objetivo documental

Preparar um contrato inequívoco para que outra IA possa implementar o Edit sem deduzir arquitetura por semelhança.

## Cinco caminhos avaliados

1. copiar Label;
2. copiar Button;
3. copiar ComboBox;
4. criar arquitetura inteiramente nova;
5. usar os contratos do framework como limites e escolher somente as abstrações exigidas pelo comportamento confirmado do Edit.

**Selecionado:** caminho 5.

## Dependências obrigatórias antes de implementar

A IA implementadora deve ler:

- `FRM-PUBLIC`;
- `FRM-CREATION`;
- `FRM-LIFETIME`;
- `FRM-FMX`;
- `FRM-CONFIG`;
- `FRM-PACKAGE`.

## O que este Owner não define

Este documento não define:

- API fluent do Edit;
- record de configuração;
- Handle;
- visual tree;
- máscaras;
- validação;
- eventos;
- estados;
- ícones;
- defaults.

Esses pontos exigem contrato funcional confirmado e não podem ser deduzidos do framework.
