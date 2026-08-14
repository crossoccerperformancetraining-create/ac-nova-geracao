# Passo a passo — Nova Geração Manager 7.0 Online

Este guia coloca a versão nova para funcionar com login, inscrições, fotos, anamnese, frequência e financeiro sincronizados no Firebase.

## 0. Faça um backup antes de trocar a versão

1. No sistema antigo, use o botão de backup/exportação se estiver disponível.
2. Salve o arquivo JSON em lugar seguro.
3. Não apague o repositório antigo até testar a versão 7.0.

A versão 7.0 também procura automaticamente dados locais das chaves antigas (`acng_v2`, `ng_manager_v3`, `ng_manager_v4`, `ng_manager_v5`) e, quando o Firebase estiver vazio, oferece migrá-los.

---

## 1. Firebase Console — Authentication

Abra seu projeto Firebase.

### 1.1 Ative E-mail/Senha

1. Authentication.
2. Sign-in method / Método de login.
3. Ative **E-mail/senha**.

Esse método será usado por Administrador, Secretaria, Financeiro, Coordenação e Treinadores.

### 1.2 Ative Anônimo

Na mesma tela, ative **Anônimo**.

A ficha pública usa uma conta anônima temporária para enviar uma inscrição protegida pelas regras sem obrigar o responsável a criar senha.

---

## 2. Realtime Database

1. Abra **Realtime Database**.
2. Se ainda não existir, crie o banco.
3. Anote a URL completa do banco. Exemplo de formato:

```text
https://SEU-PROJETO-default-rtdb.REGIAO.firebasedatabase.app
```

Não use regras em "modo de teste" para produção. As regras prontas estão em `database.rules.json`.

---

## 3. Cloud Storage

1. Abra **Storage** no Firebase Console.
2. Clique em começar/configurar.
3. Use o bucket do mesmo projeto.

A versão 7.0 usa Storage para:

- foto do atleta;
- atestado médico;
- escudo personalizado do clube.

As regras estão em `storage.rules`.

---

## 4. Crie ou confira o App Web do Firebase

1. Firebase Console > engrenagem > **Configurações do projeto**.
2. Em **Seus apps**, selecione ou crie um App Web (`</>`).
3. Localize **Configuração do SDK**.
4. Copie os valores para:

```text
docs/js/firebase-config.js
```

Exemplo de estrutura:

```js
export const firebaseConfig = {
  apiKey: "...",
  authDomain: "...",
  databaseURL: "...",
  projectId: "...",
  storageBucket: "...",
  messagingSenderId: "...",
  appId: "..."
};
```

Não invente os valores: copie exatamente do Console.

---

## 5. Crie o primeiro usuário Administrador

### 5.1 Crie a conta

1. Firebase Console > Authentication > Users.
2. **Add user / Adicionar usuário**.
3. Informe e-mail e uma senha forte.
4. Depois de criar, copie o **UID** desse usuário.

### 5.2 Cadastre o perfil no Realtime Database

No Realtime Database, crie:

```text
/users/UID_DO_ADMIN
```

Com este conteúdo:

```json
{
  "name": "Administrador AC Nova Geração",
  "email": "seu-email@exemplo.com",
  "role": "admin",
  "clubId": "default",
  "active": true
}
```

O arquivo `EXEMPLO-USUARIO-ADMIN.json` contém o mesmo modelo.

Esse cadastro inicial pode ser feito diretamente no Console. Depois, os perfis devem ser administrados por um Administrador.

---

## 6. Instale Firebase CLI e dependências das Functions

Use Node.js 20 ou 22. O projeto está configurado para Node.js 20.

No terminal:

```bash
npm install -g firebase-tools
firebase login
```

Na pasta raiz do projeto:

```bash
firebase use --add
```

Selecione o projeto correto e defina-o como `default`.

Depois:

```bash
cd functions
npm install firebase-functions@latest firebase-admin@latest
cd ..
```

---

## 7. Plano Blaze para Cloud Functions

Para implantar Cloud Functions em produção, o projeto precisa estar no plano **Blaze**.

As Functions desta versão fazem:

- `syncMyClaims`: sincroniza o perfil do usuário com custom claims, usados nas regras do Storage;
- `setUserRole`: permite ao administrador ajustar perfis futuramente;
- `approveApplication`: aprova a inscrição, cria o atleta, separa a anamnese e cria a primeira mensalidade;
- `generateMonthlyFees`: no dia 1 de cada mês gera a mensalidade dos atletas ativos sem duplicar lançamentos já existentes.

Se ainda não quiser habilitar Blaze, não abra a inscrição ao público até definir como fará a aprovação automática e o acesso aos documentos.

---

## 8. Publique regras, Functions e o site

### Opção recomendada: Firebase Hosting

Na raiz:

```bash
firebase deploy --only database,storage,functions,hosting
```

Ao terminar, o site ficará disponível normalmente em:

```text
https://SEU-PROJETO.web.app
```

A inscrição:

```text
https://SEU-PROJETO.web.app/inscricao.html
```

### Se quiser manter o GitHub Pages

Publique a pasta `docs/` pelo GitHub Pages e implante no Firebase apenas o backend:

```bash
firebase deploy --only database,storage,functions
```

No GitHub:

1. Settings > Pages.
2. Deploy from a branch.
3. Branch `main`.
4. Pasta `/docs`.

Atenção: o GitHub Pages deve apontar para **`/docs` desta versão**, e não para o `index.html` antigo na raiz. Isso é o que evita continuar aparecendo o layout antigo.

---

## 9. Primeiro login e custom claims

1. Abra `index.html` publicado.
2. Entre com o e-mail/senha do Administrador.
3. O sistema chama `syncMyClaims` automaticamente.
4. Se o escudo/fotos retornarem erro de permissão no primeiro acesso, saia e entre novamente para renovar o token.

---

## 10. Migre os dados antigos

Se o Firebase estiver vazio e o navegador possuir dados das versões antigas, ao primeiro login de Administrador o sistema perguntará se deseja migrar:

- alunos;
- financeiro;
- frequência;
- categorias;
- jogos;
- anamnese já existente nos alunos.

Confirme somente após ter feito o backup do passo 0.

As pré-inscrições antigas não são migradas automaticamente porque versões anteriores podiam guardar foto/atestado em formatos locais diferentes. Novas inscrições entram na estrutura segura da V7.

---

## 11. Teste a ficha de inscrição

Abra:

```text
/inscricao.html?origem=WhatsApp
```

Teste:

1. nome do atleta;
2. data de nascimento;
3. categoria;
4. **foto do atleta**;
5. camisa, escola e turno;
6. responsável, WhatsApp e endereço;
7. TDAH;
8. TEA/autismo;
9. quando TEA for informado, nível de suporte/grau constante em laudo quando houver;
10. asma/bronquite;
11. epilepsia/convulsões;
12. diabetes;
13. condição cardíaca/restrição;
14. alergias/medicamentos;
15. adaptações para treino;
16. atestado médico opcional;
17. todos os aceites.

Depois do envio, confira no Realtime Database:

```text
/clubs/default/applications/ID
/clubs/default/applicationHealth/ID
```

A parte de saúde deve estar separada.

---

## 12. Aprove uma matrícula

No sistema interno:

1. Abra **Inscrições**.
2. Clique na ficha.
3. Confira os dados.
4. Clique **Aprovar matrícula**.

A Cloud Function criará:

```text
/clubs/default/students/ID_DO_ATLETA
/clubs/default/healthRecords/ID_DO_ATLETA
/clubs/default/transactions/ID_DA_MENSALIDADE
```

E atualizará:

```text
/clubs/default/applicationAdmin/ID_DA_INSCRICAO
```

A foto continua vinculada ao atleta pelo `photoPath`.

---

## 13. Frequência em tablet/celular

1. Abra o sistema no tablet.
2. Faça login com perfil `treinador`, `coordenacao`, `secretaria` ou `admin`.
3. Entre em **Frequência**.
4. Escolha/crie o treino e a categoria.
5. Marque todos presentes e altere apenas faltas, justificativas ou atrasos.

O Realtime Database sincroniza as mudanças com os demais aparelhos conectados.

---

## 14. Perfis e privacidade

### Anamnese completa

Somente:

- admin;
- secretaria;
- coordenacao.

### Sem acesso à anamnese completa

- financeiro;
- treinador.

O financeiro também não deve receber acesso a documentos médicos no Storage.

Os dados de saúde ficam em nós e caminhos separados para evitar que apareçam em listagens comuns.

---

## 15. App Check — faça antes de divulgar amplamente o link

A configuração está preparada para **reCAPTCHA Enterprise**.

1. Google Cloud Console > reCAPTCHA Enterprise.
2. Crie uma chave de site Web baseada em pontuação.
3. Cadastre os domínios usados pelo sistema, por exemplo:
   - `SEU-PROJETO.web.app`;
   - seu domínio personalizado;
   - seu domínio do GitHub Pages, se continuar usando-o.
4. Firebase Console > App Check.
5. Registre o App Web com essa chave.
6. Cole a **site key** em `docs/js/firebase-config.js`:

```js
export const appCheckSiteKey = "SUA_SITE_KEY";
```

7. Publique e teste.
8. Só depois ative enforcement gradualmente para os produtos usados.

---

## 16. Teste de segurança obrigatório

Crie usuários de teste para cada perfil e confirme:

- Treinador não abre financeiro.
- Financeiro não vê anamnese.
- Treinador não vê atestado médico.
- Responsável pela ficha pública não consegue listar inscrições existentes.
- Usuário desativado deixa de acessar o sistema.
- Somente Administrador troca o escudo e configura identidade.

---

## 17. Link para WhatsApp

No próprio painel de Inscrições existe o link público. O endereço também pode ser compartilhado diretamente:

```text
https://SEU-DOMINIO/inscricao.html?origem=WhatsApp
```

Você pode criar variações para medir a origem:

```text
?origem=Instagram
?origem=Indicacao
?origem=Panfleto
?origem=WhatsApp
```

---

## 18. Anamnese: observação importante

O formulário não diagnostica TDAH ou TEA. Ele registra a informação fornecida pelo responsável. Para TEA, o campo utiliza **nível de suporte** e permite registrar Nível 1, 2 ou 3 somente quando essa informação já constar de avaliação/laudo ou for conhecida pelo responsável.

Dados de saúde e dados de crianças exigem cuidados reforçados de privacidade, finalidade, necessidade, controle de acesso e segurança. Revise o texto final de consentimento e sua política de privacidade com profissional jurídico/DPO antes de uso em escala.

---

## 19. Se o site continuar mostrando o layout antigo

Esse é o problema visto anteriormente. Faça esta verificação:

### GitHub Pages

O Pages precisa usar:

```text
Branch: main
Folder: /docs
```

O novo arquivo é:

```text
docs/index.html
```

Depois de publicar:

1. espere o deploy terminar;
2. faça `Ctrl + F5`;
3. abra em janela anônima;
4. confira se o título mostra **Nova Geração Manager 7.0 Online**.

### Firebase Hosting

Execute:

```bash
firebase deploy --only hosting
```

Depois abra o endereço `.web.app` informado pela CLI.

---

## 20. Ordem de teste para começar a trabalhar hoje

1. Configurar `firebase-config.js`.
2. Ativar Email/Senha e Anônimo.
3. Criar primeiro Admin e `/users/UID`.
4. Publicar Database Rules e Storage Rules.
5. Se estiver no Blaze, publicar Functions.
6. Publicar `/docs` no Firebase Hosting ou GitHub Pages.
7. Fazer login como Admin.
8. Testar uma inscrição com foto.
9. Conferir a anamnese.
10. Aprovar a matrícula.
11. Confirmar que o aluno apareceu no elenco.
12. Confirmar a primeira mensalidade.
13. Criar um treino e testar chamada no tablet.
14. Testar outro aparelho ao mesmo tempo.
15. Ativar App Check após todos os testes funcionarem.
