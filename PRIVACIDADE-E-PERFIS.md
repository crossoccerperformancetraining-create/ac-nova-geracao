# Privacidade e perfis — Nova Geração Manager 7.1

## Regra de acesso proposta

| Informação | Admin | Secretaria | Coordenação | Financeiro | Treinador | Público |
|---|---:|---:|---:|---:|---:|---:|
| Dados básicos do atleta | Sim | Sim | Sim | Sim* | Sim* | Não |
| Foto do atleta | Sim | Sim | Sim | Sim* | Sim* | Não |
| Anamnese completa | Sim | Sim | Sim | Não | Não | Não |
| TDAH / TEA / nível de suporte | Sim | Sim | Sim | Não | Não | Não |
| Atestado médico | Sim | Sim | Sim | Não | Não | Não |
| Financeiro | Sim | Sim | Não | Sim | Não | Não |
| Frequência | Sim | Sim | Sim | Não | Sim | Não |
| Pré-inscrições | Sim | Sim | Sim | Não | Não | Criar somente |
| Configurações / escudo | Sim | Não | Não | Não | Não | Não |

\* A interface deve mostrar somente os dados necessários à função. As regras do banco podem ser ainda mais segmentadas no futuro se o clube quiser separar a ficha administrativa em nós menores.

## Como a V7.1 separa os dados

- `clubs/default/applications`: dados comuns da pré-inscrição.
- `clubs/default/applicationHealth`: anamnese da pré-inscrição.
- `clubs/default/students`: ficha comum do atleta já matriculado.
- `clubs/default/healthRecords`: anamnese do atleta matriculado.
- Storage `/applications/.../athlete/`: foto do atleta.
- Storage `/applications/.../medical/`: atestado e documentos de saúde.

A foto do atleta não é publicada automaticamente. O atestado médico e os dados de saúde ficam em caminhos distintos e com permissões mais restritas.

## Observação jurídica

O texto e a arquitetura foram preparados para reduzir exposição e separar dados sensíveis, mas o clube continua responsável por definir finalidade, base legal, período de retenção, procedimentos para direitos dos titulares, incidentes e demais obrigações aplicáveis. Antes do uso em escala, revise o termo e a política de privacidade com profissional jurídico ou encarregado/DPO.
