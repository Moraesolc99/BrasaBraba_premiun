# Brasa Braba — calendário de disponibilidade

## O que foi implementado

- Calendário em português com datas passadas e datas reservadas desabilitadas.
- Um evento por dia: `event_date` é a chave primária da tabela.
- Consulta pública somente de datas reservadas.
- Painel administrativo discreto no rodapé.
- Login compartilhado via Supabase Auth.
- Cadastro e liberação de datas pelo painel, sem novo deploy.
- A disponibilidade é consultada novamente ao enviar o formulário, para reduzir o risco de usar uma lista desatualizada.

**Importante:** enviar o orçamento pelo WhatsApp não confirma automaticamente uma reserva. A equipe continua responsável por confirmar o evento e cadastrar a data no painel. O formulário não cria bloqueios temporários nem recebe pagamentos.

## 1. Criar o projeto Supabase

1. O projeto Supabase já foi criado.
2. A URL e a chave publishable já estão preenchidas em `supabase-config.js`.
3. A chave publishable é pública por definição; nunca use uma Secret key ou `service_role` no navegador.

## 2. Criar o login compartilhado

1. Os dois usuários administrativos já foram informados e seus UUIDs já estão autorizados no arquivo `supabase-schema.sql`.
2. Confirme em **Authentication → Users** que os dois usuários existem e estão com e-mail confirmado. Se ainda não existirem, crie-os usando os UUIDs informados não é possível; crie os usuários e confira se os UUIDs gerados correspondem aos autorizados no SQL.
3. Em **Authentication → Providers → Email**, desative o cadastro público (Sign ups), para impedir que visitantes criem contas.
4. Abra `supabase-schema.sql` e execute todo o conteúdo no **SQL Editor** do Supabase.

A política RLS permite que qualquer visitante leia as datas reservadas. Somente os dois UUIDs autorizados podem inserir ou excluir datas. As senhas nunca ficam no HTML.

## 3. Publicar no Vercel

1. Coloque `index.html`, `supabase-config.js` e `supabase-schema.sql` na raiz do mesmo projeto/pasta.
2. Publique essa pasta como projeto no Vercel (framework preset **Other**, sem build command; output directory `.`).
3. O arquivo principal precisa se chamar `index.html`.
4. Abra a URL publicada e teste o calendário.
5. No rodapé, clique em **Acesso administrativo**, entre com um dos dois e-mails e sua respectiva senha e cadastre uma data de teste.
6. Abra a página em uma janela anônima e confirme que a data aparece bloqueada.
7. Volte ao painel e libere a data de teste.

## 4. Observações técnicas

- A chave publishable/anon é pública por definição; a proteção real é feita pelas políticas RLS no banco.
- Não crie políticas de escrita para `anon`.
- Se trocar um administrador, atualize os UUIDs autorizados nas duas políticas SQL.
- O calendário usa Flatpickr e Supabase JS por CDN; a página precisa de internet para carregar essas bibliotecas.
- Uma data já selecionada pode ficar temporariamente no formulário se for reservada por outra pessoa enquanto a página está aberta. Por isso o sistema consulta o banco novamente no envio. Ainda assim, o orçamento não é uma reserva automática: o bloqueio definitivo é feito pelo ADM.
