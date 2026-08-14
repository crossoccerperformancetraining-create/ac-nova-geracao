# Nova Geração Manager 7.0 Online

Versão reorganizada do sistema da AC Nova Geração com layout premium azul-marinho/dourado e Firebase como base online.

## O que já está nesta versão

- Dashboard executivo mensal.
- Alunos, categorias, jogos, frequência e relatórios.
- Financeiro com contas a pagar/receber, recorrência, parcelas, pagamentos parciais e fechamento mensal.
- Inscrição pública por link.
- Foto do atleta na inscrição, enviada ao Firebase Storage.
- Anamnese separada dos dados comuns.
- TDAH, TEA e nível de suporte informado, asma/bronquite, convulsões, diabetes, condição cardíaca, alergias, medicamentos, adaptações e observações.
- Atestado médico opcional em imagem/PDF.
- Aprovação de inscrição por Cloud Function.
- Criação automática do aluno e da primeira mensalidade após aprovação.
- Geração automática das mensalidades no primeiro dia de cada mês.
- Firebase Authentication com perfis de acesso.
- Realtime Database com regras por função.
- Storage com regras por função e tipo/tamanho de arquivo.
- App Check preparado para reCAPTCHA Enterprise.
- Migração de dados locais V2/V3/V4/V5 para o Firebase quando o banco online estiver vazio.
- Estrutura `docs/` compatível com GitHub Pages e Firebase Hosting.

## Perfis

- `admin`: acesso total e identidade do clube.
- `secretaria`: inscrições, alunos, frequência e financeiro operacional.
- `coordenacao`: inscrições, alunos, frequência, categorias, jogos e anamnese.
- `financeiro`: alunos para referência, financeiro e relatórios; sem anamnese.
- `treinador`: alunos para consulta, frequência, categorias, jogos e relatórios; sem financeiro e sem anamnese completa.

## Estrutura

```text
docs/
  index.html
  inscricao.html
  assets/escudo.png
  js/firebase-config.js
  js/firebase-client.js
  js/admin-sync.js
  js/registration.js
functions/
  index.js
  package.json
database.rules.json
storage.rules
firebase.json
.firebaserc.example
SETUP-PASSO-A-PASSO.md
EXEMPLO-USUARIO-ADMIN.json
```

## Importante

O arquivo `docs/js/firebase-config.js` contém apenas marcadores. Copie para ele a configuração do seu App Web exibida no Firebase Console. A configuração Web do SDK não substitui as regras de segurança: mantenha Authentication, Security Rules e App Check configurados.

Cloud Functions em produção exigem projeto no plano Blaze. Se ainda estiver no Spark, a inscrição, Auth, Realtime Database e Storage podem ser preparados, mas a aprovação automática por Function e a geração mensal agendada devem aguardar o upgrade do plano.

Leia `SETUP-PASSO-A-PASSO.md` antes de publicar.
