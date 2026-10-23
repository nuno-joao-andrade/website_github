---
title: "Build It with AI: A Hands-On Code-Along com Antigravity CLI (agy)"
date: 2026-10-23 10:00:00 +0100
categories: [AI Engineering, Workshops]
tags: [antigravity-cli, agy, gemini, mcp, context-engineering, skills, hooks, plugins, nodejs, react, python, gdg-lisbon]
author: Nuno João Andrade
description: "Um workshop prático de nível de produção e guia de referência sobre como estruturar, construir e escalar projetos de software AI-First utilizando o Google Antigravity CLI (agy), Regras Hierárquicas (AGENTS.md), Skills de Revelação Progressiva (SKILL.md), Hooks Determinísticos de Ciclo de Vida, Model Context Protocol (MCP) e Plugins de Equipa."
image:
  path: ./assets/builditwithai/slide-01.png
  alt: "Engenharia de Software AI-First com Google Antigravity CLI (agy) — Masterclass Code-Along GDG Lisbon"
---

# Build It with AI: A Hands-On Code-Along com Antigravity CLI (agy)

> **Repositório Code-Along do Workshop**: [https://github.com/nuno-joao-andrade-dev/builditwithai-techparkcv](https://github.com/nuno-joao-andrade-dev/builditwithai-techparkcv)
>
> ```bash
> git clone https://github.com/nuno-joao-andrade-dev/builditwithai-techparkcv.git
> cd builditwithai-techparkcv
> ```

> **Agradecimento Especial**: Um agradecimento especial ao **[TechPark CV](https://www.linkedin.com/company/techparkcv/posts/)** ([ver o anúncio do evento no LinkedIn](https://lnkd.in/p/emG5uTee)), ao **[GDG Lisbon](https://gdg.community.dev/gdg-lisbon/)** e à **[Eimy Blanco](https://www.linkedin.com/in/eimy-blanco/)** pela organização, pelo apoio e por tornarem esta sessão possível!

Bem-vindo ao guia técnico completo da **Masterclass Code-Along de Engenharia AI-First do GDG Lisbon**. Neste workshop prático, vamos além da simples «conversa ad-hoc com um LLM» e arquitetamos um **Sistema de Engenharia de Contexto e Governação** completo e determinístico para equipas de software, recorrendo ao **Google Antigravity CLI (`agy`)**.

Em vez de depender de «prompts mágicos» frágeis e isolados que se perdem no final de cada sessão de chat, este workshop demonstra como codificar as fronteiras arquiteturais da sua equipa, os *runbooks* operacionais, os portões de qualidade (*quality gates*) e as integrações com ferramentas externas diretamente no seu repositório Git, utilizando **Regras (`AGENTS.md`)**, **Skills On-Demand (`SKILL.md`)**, **Hooks Determinísticos de Ciclo de Vida (`hooks.json`)**, **Model Context Protocol (`mcp_config.json`)** e **Plugins Partilháveis (`plugin.json`)**.

![Slide 01 — Desenvolvimento AI-First com Google Antigravity CLI (agy)](/assets/builditwithai/slide-01.png)

> [!NOTE]
> **Objetivo Arquitetural Principal**: Transformar um agente autónomo de programação — que sem governação atua como um gerador de código imprevisível — num parceiro de engenharia disciplinado, com consumo de contexto controlado (orçamento de regras de `20.000 tokens` + revelação progressiva de *skills*), validação de migrações *zero-downtime*, hooks de segurança determinísticos `PreToolUse` / `PostToolUse` e verificação *full-stack* orientada por contratos (*contract-first*).

---

## Sobre o Orador & a Comunidade GDG Lisbon

![Slide 02 — Apresentação do Orador & Comunidade GDG Lisbon](/assets/builditwithai/slide-02.png)

Este workshop foi criado para a comunidade **Google Developer Group (GDG) Lisbon** por **Nuno João Andrade** ([nja.dev](https://nja.dev)), **Google Developer Expert (GDE)** em Google Cloud & Infraestrutura Moderna e Senior Backend & Cloud Architect.

- **Estratégia do Repositório (Bilingue por Desenho)**: Todos os slides da apresentação (`slides/`) e o guia geral na raiz do repositório estão redigidos em **Português de Portugal (`pt-PT`)** para a sessão ao vivo, enquanto as cinco diretorias de projetos práticos (`examples/00-*` a `examples/04-*`), os ficheiros `AGENTS.md` e as definições `SKILL.md` estão escritos em **Inglês (`EN`)** — o idioma recomendado para maximizar a precisão no cumprimento de instruções e a eficiência de *tokens* nos modelos de fronteira (LLMs).

---

## A Mudança de Paradigma na Engenharia de IA: Chat Ad-Hoc vs. Engenharia de Contexto AI-First

![Slide 05 — Do Autocomplete de Código ao Pair Programming Agêntico](/assets/builditwithai/slide-05.png)

Quando as equipas de engenharia adotam assistentes de código baseados em IA sem uma arquitetura de contexto ao nível do repositório, rapidamente enfrentam **deriva de contexto (*context drift*)**: o modelo esquece fronteiras arquiteturais, propõe bibliotecas descontinuadas, ignora testes unitários ou executa comandos de consola arriscados. Comparar a utilização ad-hoc de IA com a **Engenharia AI-First** estruturada evidencia por que razão a governação sob controlo de versões é essencial:

| Dimensão | Utilização Ad-Hoc de IA (Chat / Copilots Básicos) | Engenharia AI-First com Antigravity (`agy`) |
| :--- | :--- | :--- |
| **Memória do Projeto** | Repetida manualmente pelo programador em cada nova sessão de chat | Versionada em Git através de ficheiros `AGENTS.md` hierárquicos, ADRs (`docs/adr/`) e `Skills` |
| **Fluxos de Trabalho Complexos** | O LLM tenta adivinhar passos de migração, *scaffolding* ou *release* | *Runbooks* passo-a-passo carregados a pedido (*on-demand*) a partir de `.agents/skills/<nome>/SKILL.md` |
| **Qualidade & Segurança** | Revisão humana manual para detetar erros de *lint* ou comandos destrutivos | Imposta de forma determinística através de **Lifecycle Hooks** síncronos (`PreToolUse`, `PostToolUse`, `Stop`) |
| **Sistemas Externos** | Copiar e colar esquemas SQL, *logs* de serviços ou métricas de incidentes no chat | Acesso estruturado e governado via **Model Context Protocol (MCP)** (`mcp_config.json`) |
| **Saúde da Janela de Contexto** | Despejar documentos de 50 páginas no prompt, degradando a atenção do modelo | **Revelação Progressiva (*Progressive Disclosure*)**: metadados leves no arranque; referências profundas lidas apenas quando necessário |

> [!TIP]
> **A Regra de Ouro da Engenharia Agêntica**: Se tiver de corrigir o agente duas vezes sobre a mesma convenção do projeto, essa regra deve passar a constar no `AGENTS.md`, numa `Skill` ou num `Hook` (ou ser persistida de imediato através do comando `/learn`).

---

## Blueprint da Arquitetura do Sistema & Os 5 Pilares de Personalização

![Slide 08 — Estrutura de Diretorias Recomendada para Projetos AI-Ready](/assets/builditwithai/slide-08.png)

Um repositório *AI-Ready* separa a **documentação de arquitetura para humanos e agentes (`docs/`)**, as **regras contextuais sempre ativas (`AGENTS.md`)** e as **personalizações modulares do agente (`.agents/`)**:

```text
+-----------------------------------------------------------------------------------+
|                        Arquitetura de Repositório AI-Ready                        |
+-----------------------------------------------------------------------------------+
         |                                    |                                 |
         v                                    v                                 v
+------------------------+     +------------------------------+     +---------------+
| Regras Contextuais     |     | Raiz de Personalização       |     | Documentação  |
| (Hierárquicas)         |     | .agents/ (Versionada em Git) |     | Viva (docs/)  |
+------------------------+     +------------------------------+     +---------------+
| - AGENTS.md na raiz    |     | - skills/<nome>/SKILL.md     |     | - product-spec|
| - apps/api/AGENTS.md   |     | - hooks.json + scripts/*.sh  |     | - architecture|
| - apps/web/AGENTS.md   |     | - skills.json / plugins.json |     | - conventions |
|   (limite 24 KB/fich., |     | - plugins/<nome>/plugin.json |     | - adr/0001.md |
|    orçamento 20k tok.) |     |   + mcp_config.json          |     |               |
+------------------------+     +------------------------------+     +---------------+
```

### Os 5 Pilares de Personalização do Antigravity

![Slide 09 — Os 5 Pilares de Personalização do Antigravity](/assets/builditwithai/slide-09.png)

Escolher a primitiva de personalização certa para cada problema de engenharia mantém o contexto enxuto e as barreiras de segurança determinísticas:

| Pilar | Ficheiro / Diretoria | Âmbito de Ativação | Quando Utilizar |
| :--- | :--- | :--- | :--- |
| **1. Rules (Regras)** | `AGENTS.md` ou `GEMINI.md` | Contextual e Hierárquico (sempre ativo na diretoria) | Impor estilo de código, fronteiras entre módulos, comandos de teste de ficheiro único e restrições permanentes |
| **2. Skills** | `.agents/skills/<nome>/SKILL.md` | *On-Demand* (Revelação Progressiva) | Ensinar fluxos de trabalho multi-etapa, migrações de BD, *scaffolding* de endpoints ou triagem de incidentes |
| **3. Hooks** | `.agents/hooks.json` | Evento Síncrono do Ciclo de Vida (`stdin` -> `stdout`) | Bloquear comandos destrutivos na consola, correr *linters* automaticamente após edições ou exigir testes antes de terminar |
| **4. Servidores MCP** | `mcp_config.json` / `.agents/mcp.json` | Integração com Ferramentas Externas (`stdio` ou Streamable HTTP) | Ligar o agente de forma segura a bases de dados, catálogos de serviços, GitHub, Jira ou APIs internas |
| **5. Plugins** | `.agents/plugins/<nome>/plugin.json` | Pacote Unificado e Partilhável | Empacotar Skills, Regras, Hooks e servidores MCP numa única unidade ativável para toda a equipa |

**Ordem de Prioridade de Descoberta (da Mais Alta para a Mais Baixa):**
1. **Workspace (`.agents/`)** &rarr; 2. **Configurações Declaradas no Workspace (`skills.json` / `plugins.json`)** &rarr; 3. **Global (`~/.gemini/config/`)** &rarr; 4. **Integrado (*Built-in*)** &rarr; 5. **Configurações Globais Declaradas**.

### Orçamento de Contexto & Revelação Progressiva (*Progressive Disclosure*)

![Slide 10 — Orçamento de Contexto e Revelação Progressiva](/assets/builditwithai/slide-10.png)

Injetar milhares de linhas de instruções num único *system prompt* degrada a capacidade de raciocínio do modelo. O Antigravity resolve este problema com **Orçamentos de Contexto** rigorosos e **Revelação Progressiva**:

- **Regras (`AGENTS.md` / `GEMINI.md`)**:
  - **Limite por Ficheiro**: `24 KB` (`24.000 bytes`, após expandir quaisquer inclusões `@[label](path)`).
  - **Orçamento Agregado de Regras**: `20.000 tokens` dedicados ao conjunto de ficheiros de regras ativos.
  - **Degradação Graciosa (*Graceful Degradation*)**: Se as regras ativas excederem o orçamento, as regras de menor prioridade passam automaticamente de texto *inline* para ponteiros de ficheiro lidos a pedido.
  - **Desduplicação**: Cada ficheiro de regras é injetado no máximo uma vez por conversa.
- **Skills (`SKILL.md`) — Poupança de Tokens em 3 Fases**:
  1. **Fase 1 (Injeção Leve no Arranque)**: Apenas os campos `name` e `description` do cabeçalho YAML (*frontmatter*) de cada *skill* são injetados no *system prompt* inicial.
  2. **Fase 2 (Ativação a Pedido)**: O corpo completo do ficheiro `SKILL.md` só é lido quando a tarefa pedida pelo utilizador corresponde à `description` da *skill*.
  3. **Fase 3 (Referências Profundas)**: Manuais extensos em `references/` ou ficheiros de exemplo em `examples/` só são lidos se o passo específico do fluxo de trabalho o exigir.

---

## Roteiro Curricular Progressivo de 5 Laboratórios

O repositório inclui cinco laboratórios práticos autónomos e progressivos dentro da diretoria `examples/`, que o levam desde um esqueleto base (*boilerplate*) vazio até uma aplicação *full-stack* completa em Node.js + React:

| Diretoria do Lab | Foco Arquitetural | Principais Primitivas Demonstradas | Comando de Verificação |
| :--- | :--- | :--- | :--- |
| **`examples/00-project-boilerplate/`** | Esqueleto Universal de Projeto AI-First | `AGENTS.md`, `product-spec.md`, `architecture.md`, `conventions.md`, `ADR-0001`, skills `init-project` & `feature-workflow` | `./.agents/skills/init-project/scripts/check-boilerplate.sh` |
| **`examples/01-starter-template/`** | Monólito Modular Python *Greenfield* | `AGENTS.md` conciso na raiz, regras de domínio em cêntimos inteiros, skill `project-bootstrap`, hook de segurança `PreToolUse` | `./.agents/skills/project-bootstrap/scripts/verify-env.sh` |
| **`examples/02-fullstack-monorepo/`** | Escalabilidade em Monorepo Multi-Serviço | `AGENTS.md` hierárquicos (Raiz + API + Web), skills `db-migration` & `api-endpoint-scaffold`, hooks `PreToolUse` + `PostToolUse` | `./.agents/skills/db-migration/scripts/validate-sql.sh apps/api/migrations/001_create_users.sql` |
| **`examples/03-team-plugin-and-mcp/`** | Governação em Equipa, Plugins & MCP | `skills.json` & `plugins.json` declarativos, plugin `platform-engineering-kit`, servidor MCP Stdio local em Python | `printf '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}\n' \| python3 tools/local-mcp-server/server.py` |
| **`examples/04-restaurant-reservation/`** | App Full-Stack de Produção (Node.js + React 19) | Esquema *contract-first* (`contracts.json`), API REST em Node.js (`:4000`), UI em React 19 + Vite (`:5173`), skill `add-reservation-feature` | `npm test` & `npm start` |

---

## Pré-requisitos & Configuração do Ambiente

### 1. Instalar o Google Antigravity CLI (`agy`) & Configurar a Autenticação

![Slide 03 — Instalar o Google Antigravity CLI (agy) & Autenticação por API Key](/assets/builditwithai/slide-03.png)

O repositório inclui um script de instalação automática em Bash ([`scripts/install-antigravity.sh`](./scripts/install-antigravity.sh)) que verifica se o `agy` já está instalado, transfere-o caso não esteja presente, solicita de forma segura a sua `GEMINI_API_KEY`, configura `"modelProvider": "gemini"` em `~/.gemini/antigravity-cli/settings.json` e persiste a chave no perfil da sua *shell* (`~/.bashrc` / `~/.zshrc`):

```bash
# Opção A: Verificação, instalação e configuração automática da API Key
./scripts/install-antigravity.sh
source ~/.bashrc
agy --version
```

Se preferir realizar a instalação manual:

```bash
# Linux, macOS ou WSL:
curl -fsSL https://antigravity.google/cli/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"

# Windows (PowerShell):
irm https://antigravity.google/cli/install.ps1 | iex
```

> [!NOTE]
> Documentação Oficial de Instalação e Referência do CLI:
> - Guia de Instalação: [`https://antigravity.google/docs/install/?tab=cli`](https://antigravity.google/docs/install/?tab=cli)
> - Referência do CLI: [`https://antigravity.google/docs/cli/reference`](https://antigravity.google/docs/cli/reference)

### 2. Instalar o Python 3 & Node.js LTS (via NVM)

![Slide 04 — Instalar o Python 3 e o Node.js via NVM](/assets/builditwithai/slide-04.png)

Os Laboratórios `00` a `03` utilizam **Python 3.11+** (sem necessidade de quaisquer pacotes externos do PyPI — 100% biblioteca padrão) e o Laboratório `04` utiliza **Node.js LTS** (para a API REST e o frontend em React 19 + Vite):

```bash
# 1. Verificar ou instalar o Python 3 (Ubuntu / Debian / WSL)
sudo apt update && sudo apt install -y python3 python3-venv python3-pip
python3 --version

# 2. Instalar o NVM e o Node.js LTS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install --lts && nvm use --lts
node -v && npm -v
```

### 3. Dominar as Flags, Modos de Execução & Comandos Slash do `agy`

![Slide 06 — Dominar o Antigravity CLI no Terminal](/assets/builditwithai/slide-06.png)

O `agy` suporta sessões interativas de *pair programming*, execução *headless* de comando único (`-p` / `--print`), execução em *sandbox* (`-s`) e nível de esforço de raciocínio personalizável (`-e`):

```bash
# Interface interativa (TUI) no repositório atual
agy

# Execução headless (ideal para pipelines de CI/CD e auditorias automatizadas)
agy -p "Run the test suite and summarize any failures" --output-format json

# Modos de execução (-m) e esforço de raciocínio (-e: low | medium | high | max)
agy -m plan -e high "Design the database schema for multi-tenant billing"

# Ativar sandboxing de sistema de ficheiros e rede
agy -s
```

![Slide 07 — Comandos Slash Interativos Essenciais](/assets/builditwithai/slide-07.png)

Dentro de uma sessão interativa do `agy`, utilize os **Comandos Slash** para orquestrar ciclos de vida de engenharia complexos:

- **`/plan`**: Investiga a base de código e produz um plano de implementação estruturado antes de modificar qualquer ficheiro.
- **`/grill-me`**: Inicia uma entrevista arquitetural interativa para esclarecer casos-limite (*edge cases*) e ambiguidades antes de programar.
- **`/learn`**: Persiste uma convenção, correção ou padrão arquitetural no `AGENTS.md` ou em `.agents/skills/` para que o agente nunca repita o mesmo erro.
- **`/boost`**: Ativa uma análise profunda multi-perspetiva e verificação rigorosa para *bugs* ou refatorizações complexas.
- **`/teamwork`**: Coordena múltiplos subagentes autónomos a trabalhar em paralelo entre backend, frontend e testes.
- **`/goal`**: Executa uma tarefa de longo alcance com auto-verificação exaustiva até que todos os critérios de aceitação sejam cumpridos.
- **`/compact`**: Resume e compacta o histórico da conversa para libertar espaço na janela de contexto antes de iniciar uma nova tarefa.

---

## Análise Profunda às 5 Primitivas de Personalização

### 1. Regras Hierárquicas (`AGENTS.md` / `GEMINI.md`)

![Slide 11 — Escrever Ficheiros de Regras AGENTS.md Eficazes](/assets/builditwithai/slide-11.png)

Quando o `agy` edita um ficheiro (por exemplo, `apps/api/src/routes.py`), percorre a árvore de diretorias desde a diretoria de trabalho atual até ao ficheiro de destino, combinando o `AGENTS.md` da raiz com os ficheiros `AGENTS.md` específicos de cada subdiretoria:

- **`AGENTS.md` na Raiz**: *Stack* tecnológica global, comandos de *build*/teste/*lint* (especialmente o comando para executar **um único ficheiro de teste** para obter *feedback* em frações de segundo) e fronteiras arquiteturais entre pacotes.
- **Subdiretorias `apps/api/AGENTS.md` & `apps/web/AGENTS.md`**: Convenções específicas de cada *framework* (por exemplo, envelopes de erro em FastAPI/Python vs. regras de componentes em React 19/TypeScript).
- **Regra de Formatação**: Os ficheiros autónomos `AGENTS.md` e `GEMINI.md` são Markdown puro — **não** lhes adicione cabeçalhos YAML (*frontmatter*).

### 2. Fluxos de Trabalho Modulares com Skills (`SKILL.md`)

![Slide 12 — Anatomia e Exemplo de um Ficheiro SKILL.md](/assets/builditwithai/slide-12.png)

Uma **Skill** reside em `.agents/skills/<nome-da-skill>/` e empacota instruções passo-a-passo juntamente com scripts auxiliares executáveis e modelos de referência:

```text
.agents/skills/db-migration/
├── SKILL.md              # Obrigatório: YAML frontmatter (name, description) + passos numerados
├── scripts/              # Opcional: Utilitários executáveis de validação (ex.: validate-sql.sh)
├── examples/             # Opcional: Implementações de referência (ex.: 001_create_users.sql)
├── resources/            # Opcional: Templates base & recursos estáticos
└── references/           # Opcional: Documentação aprofundada lida apenas quando necessário
```

Melhores práticas para a criação de ficheiros `SKILL.md`:
1. **Escrever a `description` na 3.ª pessoa**: Indique claramente *o que* a skill faz e *quando* o agente a deve ativar (por exemplo: *"Creates and validates zero-downtime SQL database migrations. Use this skill whenever the user asks to create, alter, or review database tables..."*).
2. **Delegar lógica complexa de consola para `scripts/`**: Faça com que o agente invoque um script determinístico (`./.agents/skills/db-migration/scripts/validate-sql.sh <ficheiro>`) em vez de improvisar expressões regulares complexas diretamente em Bash.

### 3. Ferramentas Externas via Model Context Protocol (`mcp_config.json`)

![Slide 13 — Configuração e Transportes do Model Context Protocol (MCP)](/assets/builditwithai/slide-13.png)

O **Model Context Protocol (MCP)** liga o `agy` a fontes de dados e ferramentas externas através de dois modos de transporte suportados:
1. **Transporte Stdio (Local)**: O `agy` inicia um binário ou script local (`command`, `args`, `env`) e comunica através de `stdin` / `stdout` utilizando JSON-RPC 2.0. Ideal para inspetores locais de SQLite/PostgreSQL, catálogos de serviços e *wrappers* de CLIs internos.
2. **Transporte Streamable HTTP (Remoto)**: Liga-se a um endpoint MCP HTTP remoto através do campo `url` (`https://mcp.internal.company.com/mcp`). *(Nota: O transporte legado HTTP+SSE encontra-se descontinuado; utilize Streamable HTTP ou uma ponte stdio local).*

### 4. Barreiras de Segurança Determinísticas com Lifecycle Hooks (`.agents/hooks.json`)

![Slide 14 — Lifecycle Hooks Determinísticos (.agents/hooks.json)](/assets/builditwithai/slide-14.png)

Enquanto os ficheiros `AGENTS.md` e `SKILL.md` orientam o raciocínio do LLM, os **Lifecycle Hooks** impõem regras com **execução 100% determinística** fora do modelo. Os scripts de *hook* recebem um *payload* JSON via `stdin` (com chaves em `camelCase`, além de *fallbacks* de compatibilidade) e devolvem uma decisão em JSON via `stdout`:

| Evento de Ciclo de Vida | Ponto de Disparo | Ação Determinística Típica (JSON no `stdout`) |
| :--- | :--- | :--- |
| **`SessionStart`** | Arranque de uma nova sessão do `agy` | Injetar o estado inicial do ambiente ou o *banner* de plugins ativos (`injectSteps`) |
| **`PreToolUse`** | Antes de executar uma ferramenta (ex.: `run_command` / `Bash`) | Devolver `{"decision": "deny", "reason": "..."}` para bloquear `rm -rf`, `git reset --hard` ou `DROP TABLE` |
| **`PostToolUse`** | Imediatamente após `edit_file` ou `write_file` | Executar automaticamente compiladores de sintaxe (`python3 -m py_compile`, `node --check`) ou *linters* |
| **`PreInvocation`** | Antes de invocar o modelo | Injetar um lembrete contextual através de `ephemeralMessage` |
| **`PostInvocation`** | Após a conclusão das chamadas de ferramentas | Definir `terminationBehavior: "force_continue"` caso sejam necessárias ações subsequentes |
| **`Stop`** | Quando o ciclo do agente está prestes a terminar | Correr a suite de testes unitários e devolver `{"decision": "continue"}` se algum teste falhar |

### 5. Empacotamento para Equipas com Plugins (`plugin.json`) & Configurações Declarativas (`skills.json`)

![Slide 15 — Plugins (plugin.json) e Registo Declarativo (skills.json)](/assets/builditwithai/slide-15.png)

Para equipas de *Platform Engineering* que gerem múltiplos repositórios ou *monorepos*:
- **Plugins (`.agents/plugins/<nome>/plugin.json`)**: Empacotam `rules/AGENTS.md`, `skills/`, `hooks.json`, `mcp_config.json` e `assets/logo.svg` num único pacote versionado com `suggestedPrompts`.
- **Registo Declarativo (`.agents/skills.json` & `.agents/plugins.json`)**: Permite que um projeto herde *skills* ou *plugins* partilhados a partir de outra pasta ou caminho central (`/opt/company/...`, `~/...`, ou caminhos relativos ao repositório) com filtros granulares de expressões regulares (`include_only` e `exclude`).

### 6. Metodologia do Dia-a-Dia: Greenfield vs. Brownfield

![Slide 16 — Metodologia Diária de Engenharia AI-First](/assets/builditwithai/slide-16.png)

Quer esteja a iniciar um repositório **Greenfield** do zero ou a manter uma base de código **Brownfield** complexa, o fluxo de trabalho diário assenta em quatro hábitos disciplinados:
1. **Planear Antes de Programar (`/plan` & `/grill-me`)**: Alinhar contratos de dados, casos-limite e ADRs antes de escrever ficheiros de implementação.
2. **Execução Orientada por Contratos (*Contract-First*)**: Atualizar primeiro os esquemas partilhados (`schemas.json` / `contracts.json`) e migrações SQL, depois os *handlers* de backend e, por fim, os componentes de frontend.
3. **Feedback Rápido por Ficheiro Único**: Executar testes direcionados após cada edição (`pytest tests/unit/test_x.py` ou `node --test tests/api.test.js`).
4. **Codificação Contínua (`/learn`)**: Transformar cada correção de *bug* ou observação de *code review* num teste permanente e numa atualização de regra ou *skill*.

---

## Laboratórios Práticos: Instruções Passo-a-Passo & O Que Esperar

![Slide 17 — Visão Geral dos 5 Projetos Práticos de Exemplo](/assets/builditwithai/slide-17.png)

Abaixo encontra o guia passo-a-passo completo para os cinco projetos práticos disponíveis na diretoria `examples/`.

---

## Lab 00: Esqueleto Universal de Projeto AI-First (`examples/00-project-boilerplate/`)

**Objetivo Arquitetural**: Disponibilizar um esqueleto base agnóstico à linguagem (`00-project-boilerplate`) pronto a copiar (`cp -r`) para inicializar *qualquer* novo projeto de software com modelos completos de documentação, hooks de segurança e duas *skills* de fluxo de trabalho integradas (`init-project` e `feature-workflow`).

### Estrutura da Diretoria

```text
examples/00-project-boilerplate/
├── AGENTS.md                                      # Template de regras globais de IA com marcadores [TODO]
├── docs/
│   ├── product-spec.md                            # Definição do problema, personas, objetivos e não-objetivos
│   ├── architecture.md                            # Mapa de módulos, fronteiras e fluxo de dados
│   ├── conventions.md                             # Convenções de nomes, testes, tratamento de erros e Git
│   └── adr/
│       └── 0001-initial-architecture-and-stack.md # Template para o ADR-0001
├── .agents/
│   ├── hooks.json                                 # Segurança PreToolUse + verificação de sintaxe PostToolUse
│   ├── mcp.json                                   # Template de servidor MCP
│   ├── scripts/
│   │   ├── command-guard.sh                       # Bloqueia rm -rf, git reset --hard, DROP TABLE
│   │   └── post-edit-lint.sh                      # Verifica automaticamente ficheiros .py e .js ao guardar
│   └── skills/
│       ├── init-project/                          # Entrevista o utilizador e substitui os marcadores [TODO]
│       │   ├── SKILL.md
│       │   └── scripts/check-boilerplate.sh
│       └── feature-workflow/                      # Fluxo Spec -> Plan -> Code -> Test
│           └── SKILL.md
├── src/
└── tests/
```

### Passo 1: Auditar o Boilerplate Não Inicializado

Execute o script de auditoria do *boilerplate* para inspecionar todos os ficheiros de governação obrigatórios e contabilizar os marcadores `[TODO: ...]` por preencher:

```bash
cd examples/00-project-boilerplate
./.agents/skills/init-project/scripts/check-boilerplate.sh
```

**O Que Esperar:**

```text
=== AI-First Boilerplate Readiness Audit ===
[1/2] Checking required directories and files...
  [OK] Directory exists: docs/
  [OK] Directory exists: docs/adr/
  [OK] Directory exists: .agents/
  [OK] Directory exists: src/
  [OK] Directory exists: tests/
  [OK] File exists: AGENTS.md
  [OK] File exists: docs/product-spec.md
  [OK] File exists: docs/architecture.md
  [OK] File exists: docs/conventions.md
  [OK] File exists: docs/adr/0001-initial-architecture-and-stack.md
  [OK] File exists: .agents/hooks.json
  [OK] File exists: .agents/mcp.json
[2/2] Scanning for unfilled [TODO: ...] placeholders...
  [WARN] Found 22 '[TODO: ...]' placeholders remaining across AGENTS.md and docs/.
         Run 'agy' and ask the agent to execute the 'init-project' skill to complete setup.
```

### Passo 2: Copiar o Boilerplate & Inicializar um Novo Projeto com o `agy`

```bash
cp -r examples/00-project-boilerplate /tmp/expense-splitter
cd /tmp/expense-splitter
agy
```

Introduza o seguinte prompt dentro do `agy`:

> `"Use the init-project skill to initialize this project as a CLI & library for splitting group travel expenses in Python 3.12 (stdlib only, unittest for tests, integer cents for all currency amounts)."`

**O Que Esperar:**
1. O `agy` ativa a skill `.agents/skills/init-project/SKILL.md` e executa `check-boilerplate.sh`.
2. Substitui todos os 22 marcadores `[TODO: ...]` em `AGENTS.md`, `docs/product-spec.md`, `docs/architecture.md` e `docs/adr/0001-initial-architecture-and-stack.md` com especificações concretas e comandos `unittest` exatos.
3. Cria a implementação inicial em `src/` e os testes unitários em `tests/`.
4. À medida que cada ficheiro `.py` é guardado, o hook `PostToolUse` (`post-edit-lint.sh`) valida automaticamente a sintaxe Python através de `python3 -m py_compile`.
5. Por fim, o agente volta a executar `check-boilerplate.sh`, confirmando:
   `[OK] 0 '[TODO: ...]' placeholders remaining! All documentation is customized.`

---

## Lab 01: Template Inicial Greenfield (`examples/01-starter-template/`)

**Objetivo Arquitetural**: Demonstrar um projeto Python **Greenfield** limpo e inicializado (uma Calculadora de Totais de Faturas de Encomendas) com um `AGENTS.md` conciso na raiz, um Architecture Decision Record (`ADR-0001`), a skill `project-bootstrap` e um hook de segurança determinístico `PreToolUse`.

### Passo 1: Executar o Script Determinístico de Verificação do Ambiente

```bash
cd examples/01-starter-template
./.agents/skills/project-bootstrap/scripts/verify-env.sh
```

**O Que Esperar:**

```text
=== [1/3] Checking Python runtime ===
Python 3.12.x
=== [2/3] Checking required AI-First documentation files ===
  [OK] AGENTS.md found
  [OK] docs/architecture.md found
  [OK] .agents/hooks.json found
=== [3/3] Running unit test suite ===
test_invalid_tax_rate_raises (test_main.TestInvoiceTotal.test_invalid_tax_rate_raises) ... ok
test_line_item_negative_price_raises (test_main.TestInvoiceTotal.test_line_item_negative_price_raises) ... ok
test_line_item_subtotal (test_main.TestInvoiceTotal.test_line_item_subtotal) ... ok
test_order_invoice_total_with_tax (test_main.TestInvoiceTotal.test_order_invoice_total_with_tax) ... ok
----------------------------------------------------------------------
Ran 4 tests in 0.001s

OK
=== Environment verification PASSED ===
```

### Passo 2: Executar a Skill `project-bootstrap` no `agy`

```bash
cd examples/01-starter-template
agy
```

Prompt a introduzir no `agy`:

> `"Run the project-bootstrap skill to verify this workspace and summarize the project architecture."`

**O Que Esperar:**
1. O `agy` carrega automaticamente o `AGENTS.md` da raiz para o contexto.
2. Através de **Revelação Progressiva (*Progressive Disclosure*)**, faz corresponder o seu pedido à skill `.agents/skills/project-bootstrap/SKILL.md` e carrega as respetivas instruções a pedido.
3. O agente lê `docs/architecture.md` e `docs/adr/0001-use-modular-monolith-and-sqlite.md`, executa `./.agents/skills/project-bootstrap/scripts/verify-env.sh`, verifica `references/onboarding-checklist.md` e apresenta um relatório estruturado de prontidão destacando que todos os valores monetários têm de utilizar **cêntimos inteiros (`int`)** para evitar erros de arredondamento de vírgula flutuante IEEE 754.

### Passo 3: Implementar uma Nova Funcionalidade Guiada pelo `AGENTS.md`

Prompt a introduzir no `agy`:

> `"Add a discount calculation helper calculate_discount_cents(subtotal_cents: int, discount_percent: int) -> int in src/main.py and add unit tests in tests/test_main.py."`

**O Que Esperar:**
- Sem necessidade de repetir estas regras no prompt, o `agy` cumpre todas as restrições definidas no `AGENTS.md`:
  - Utiliza aritmética inteira (`(subtotal_cents * discount_percent) // 100` ou `round`) com tipo de retorno `int` — nunca `float`.
  - Lança `ValueError` se `subtotal_cents < 0` ou se `discount_percent` estiver fora do intervalo `0..100`.
  - Adiciona anotações de tipo explícitas (*type annotations*) e *docstrings*, recorrendo exclusivamente à biblioteca padrão do Python.
  - Executa `python3 -m unittest discover -s tests -p "test_*.py" -v` automaticamente para comprovar que todos os testes unitários passam.

### Passo 4: Testar o Hook de Segurança Determinístico `PreToolUse`

Simule uma tentativa do agente de executar um comando destrutivo `git reset --hard`:

```bash
printf '{"tool_name":"Bash","tool_input":{"command":"git reset --hard HEAD~1"}}' \
  | ./.agents/scripts/pre-tool-safety.sh
```

**O Que Esperar:**

```json
{"decision":"deny","reason":"Blocked by workspace safety hook: destructive rm -rf or git reset --hard is not permitted."}
```

---

## Lab 02: Escalar um Monorepo Full-Stack (`examples/02-fullstack-monorepo/`)

**Objetivo Arquitetural**: Escalar a engenharia AI-First num **Monorepo Brownfield** multi-serviço que contém um backend em Python (`apps/api`), um frontend em React/TypeScript (`apps/web`) e esquemas JSON partilhados (`packages/shared/schemas.json`), governados por **Ficheiros `AGENTS.md` Hierárquicos**, **Skills de Fluxo de Trabalho (`db-migration` e `api-endpoint-scaffold`)** e **Hooks Duplos de Ciclo de Vida (`PreToolUse` + `PostToolUse`)**.

### Como Funciona a Herança de Contexto neste Monorepo

```text
examples/02-fullstack-monorepo/
├── AGENTS.md                        # Nível 1 (Raiz): Fronteiras entre serviços e regras de esquema partilhado
├── packages/shared/schemas.json     # Fonte única de verdade para contratos de entidades da API
├── apps/
│   ├── api/
│   │   ├── AGENTS.md                # Nível 2 (Backend): Envelope Python/FastAPI e regras de migração SQL
│   │   ├── migrations/001_create_users.sql
│   │   └── src/routes.py
│   └── web/
│       ├── AGENTS.md                # Nível 2 (Frontend): Interfaces TypeScript e funções puras de UI
│       └── src/App.tsx
└── .agents/
    ├── hooks.json                   # PreToolUse (command-guard.sh) + PostToolUse (post-edit-check.sh)
    └── skills/
        ├── db-migration/            # Fluxo de migração SQL zero-downtime + validate-sql.sh
        └── api-endpoint-scaffold/   # Fluxo de scaffolding API + Frontend orientado por contratos
```

### Passo 1: Validar uma Migração SQL Existente

```bash
cd examples/02-fullstack-monorepo
./.agents/skills/db-migration/scripts/validate-sql.sh apps/api/migrations/001_create_users.sql
```

**O Que Esperar:**

```text
[PASS] Migration apps/api/migrations/001_create_users.sql passed all static zero-downtime checks.
```

### Passo 2: Criar uma Migração SQL Zero-Downtime com o `agy`

Inicie o `agy` dentro de `examples/02-fullstack-monorepo`:

```bash
cd examples/02-fullstack-monorepo
agy
```

Prompt a introduzir no `agy`:

> `"Create a new zero-downtime migration 002_add_projects_table.sql in apps/api/migrations/ for a projects table (id, name, owner_user_id, created_at) and validate it."`

**O Que Esperar:**
1. O `agy` ativa a skill `.agents/skills/db-migration/SKILL.md`.
2. Inspeciona o exemplo de referência (`examples/001_create_users.sql`) e o manual de migrações sem indisponibilidade (`references/zero-downtime-migrations.md`).
3. Cria o ficheiro `apps/api/migrations/002_add_projects_table.sql` começando por `-- Migration: 002_add_projects_table` e instruções idempotentes `CREATE TABLE IF NOT EXISTS projects (...)`.
4. Executa `./.agents/skills/db-migration/scripts/validate-sql.sh apps/api/migrations/002_add_projects_table.sql` e confirma `[PASS]`.

### Passo 3: Criar um Endpoint Full-Stack entre `packages/shared`, `apps/api` e `apps/web`

Prompt a introduzir no `agy`:

> `"Add a GET /v1/projects endpoint (list_projects) to apps/api/src/routes.py and add a ProjectSummary interface and renderProjectRow helper in apps/web/src/App.tsx."`

**O Que Esperar:**
1. **Contract-First (`packages/shared/schemas.json`)**: Guiado pelo `AGENTS.md` da raiz e pela skill `api-endpoint-scaffold`, o agente atualiza primeiro `packages/shared/schemas.json` com o esquema `Project`.
2. **Contexto de Backend (`apps/api/AGENTS.md`) + Hook `PostToolUse`**: Ao editar `apps/api/src/routes.py`, o agente devolve o envelope de resposta padronizado `{"data": [...], "meta": {"requestId": request_id, "count": ...}}` com chaves em `camelCase`. Imediatamente após guardar `routes.py`, o script `.agents/scripts/post-edit-check.sh` executa `python3 -m py_compile apps/api/src/routes.py` de forma automática.
3. **Contexto de Frontend (`apps/web/AGENTS.md`)**: Ao editar `apps/web/src/App.tsx`, o agente aplica as regras de frontend, definindo `export interface ProjectSummary` e uma função pura `renderProjectRow(project: ProjectSummary): string` sem importar código do backend.

### Passo 4: Verificar o Guarda de Segurança SQL contra `DROP TABLE`

```bash
printf '{"tool_name":"run_command","tool_input":{"command":"sqlite3 app.db \"DROP TABLE users;\""}}' \
  | ./.agents/scripts/command-guard.sh
```

**O Que Esperar:**

```json
{"decision":"deny","reason":"Blocked by monorepo safety hook: DROP DATABASE/TABLE and destructive rm -rf commands are prohibited."}
```

---

## Lab 03: Plugins de Equipa, Registos Declarativos & Servidor MCP Local (`examples/03-team-plugin-and-mcp/`)

**Objetivo Arquitetural**: Demonstrar como as equipas de *Platform Engineering* empacotam e distribuem capacidades reutilizáveis de IA entre vários repositórios utilizando **Configurações Declarativas (`.agents/skills.json` e `.agents/plugins.json`)**, um **Plugin Empacotado (`platform-engineering-kit`)** e um **Servidor MCP Local em Python sem Dependências (`tools/local-mcp-server/server.py`)**.

### Passo 1: Testar o Servidor MCP Stdio Local via JSON-RPC 2.0

Antes de iniciar o `agy`, teste o servidor MCP local diretamente no terminal enviando pedidos JSON-RPC 2.0 através do `stdin`:

```bash
cd examples/03-team-plugin-and-mcp

# 1. Listar as ferramentas MCP disponíveis
printf '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}\n' \
  | python3 tools/local-mcp-server/server.py | python3 -m json.tool

# 2. Consultar os metadados de um serviço específico
printf '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"get_service_metadata","arguments":{"service_name":"inventory-worker"}}}\n' \
  | python3 tools/local-mcp-server/server.py | python3 -m json.tool
```

**O Que Esperar:**
O servidor MCP responde através do `stdout` com as ferramentas registadas (`list_registered_services` e `get_service_metadata`) e devolve a entrada de catálogo em tempo real para o serviço `inventory-worker`:

```json
{
  "service": "inventory-worker",
  "ownerTeam": "supply-chain-team",
  "tier": "tier-2",
  "status": "degraded",
  "version": "1.8.3",
  "environment": "local"
}
```

### Passo 2: Executar uma Sessão Automatizada de Triagem de Incidentes no `agy`

```bash
cd examples/03-team-plugin-and-mcp
agy
```

Prompt a introduzir no `agy`:

> `"Run an incident triage for our services, check the metadata of any degraded service via MCP, and generate a triage report."`

**O Que Esperar:**
1. **Injeção do Hook `SessionStart`**: No arranque, o hook do plugin (`session-banner.sh`) injeta uma notificação de sistema a confirmar que o plugin `platform-engineering-kit` está ativo com as skills `incident-triage` e `release-readiness`.
2. **Execução do Script de Diagnóstico**: O agente ativa a skill `incident-triage` e executa `./.agents/plugins/platform-engineering-kit/skills/incident-triage/scripts/collect-diagnostics.sh`, detetando que `checkout-api` está `healthy` (`p95LatencyMs: 42`), enquanto `inventory-worker` se encontra `degraded` (`p95LatencyMs: 890`, `errorRatePct: 2.40`, *"Database connection pool saturation at 92%"*).
3. **Chamada à Ferramenta MCP (`get_service_metadata`)**: O agente consulta o servidor MCP `platform-engineering-kit-registry` para o serviço `inventory-worker`, obtendo `ownerTeam: "supply-chain-team"`, `tier: "tier-2"` e `version: "1.8.3"`.
4. **Classificação pela Matriz de Severidade**: Consultando `references/severity-matrix.md`, o agente classifica o incidente como **SEV-2** (uma vez que `errorRatePct > 1%` e `p95LatencyMs > 500ms` num serviço `tier-2`) e produz um Relatório de Triagem de Incidente em Markdown *blameless* (sem atribuição de culpa individual), conforme exigido por `.agents/plugins/platform-engineering-kit/rules/AGENTS.md`.

### Passo 3: Avaliar a Prontidão de Lançamento (*Release Readiness*) & Auditoria de Segurança Partilhada

Prompt a introduzir no `agy`:

> `"Evaluate whether inventory-worker is ready for production deployment using our release-readiness skill, and run a security audit using our security-audit skill."`

**O Que Esperar:**
- **Scorecard de Release Gate (`BLOCKED`)**: Utilizando a skill `release-readiness`, o agente avalia o `inventory-worker` face aos critérios em `references/release-gate-criteria.md` e emite um *scorecard* com o estado **`BLOCKED`**, dado que a taxa de erro (`2.40%`) excede o limite de `< 0.5%` e a latência p95 (`890ms`) ultrapassa o limite de `< 250ms`.
- **Herança Declarativa de Skills (`.agents/skills.json`)**: O agente carrega `tools/shared-skills/security-audit/SKILL.md` (registada através de `.agents/skills.json`, excluindo simultaneamente skills `experimental-.*`) e audita o repositório em busca de segredos *hardcoded*, hooks de consola inseguros e privilégios excessivos em servidores MCP.

---

## Lab 04: Aplicação Full-Stack de Reserva de Mesas de Restaurante (`examples/04-restaurant-reservation/`)

![Slide 18 — Análise Profunda ao Exemplo 04: Aplicação Full-Stack de Reserva de Mesas (Node.js + React)](/assets/builditwithai/slide-18.png)

**Objetivo Arquitetural**: Experienciar a engenharia AI-First numa **Aplicação Web Full-Stack** completa e funcional, construída com uma **API REST HTTP em Node.js (`apps/api`, porta `4000`)**, um **Frontend em React 19 + Vite (`apps/web`, porta `5173`)** e um **Esquema Partilhado Orientado por Contratos (`packages/shared/contracts.json`)**.

### Visão Geral da Arquitetura Full-Stack

```text
examples/04-restaurant-reservation/
├── AGENTS.md                                      # Regras globais contract-first e de verificação
├── package.json                                   # Scripts do workspace: npm start, npm test, npm run build
├── docs/
│   ├── architecture.md                            # Diagrama de sistema, mapa de capacidade de mesas e fluxo de dados
│   └── adding-functionality-guide.md              # Guia passo-a-passo manual e com IA para 3 novas funcionalidades
├── packages/
│   └── shared/
│       └── contracts.json                         # Fonte única de verdade: Mesas, Horários e Estados
├── apps/
│   ├── api/                                       # API REST HTTP em Node.js (Porta 4000, zero dependências externas)
│   │   ├── AGENTS.md                              # Regras de backend: envelope, códigos HTTP, validação
│   │   ├── src/
│   │   │   ├── validators.js                      # Funções puras de validação de dados de entrada
│   │   │   ├── store.js                           # Armazenamento em memória do estado de reservas e mesas
│   │   │   └── server.js                          # Encaminhamento HTTP e configuração CORS
│   │   └── tests/
│   │       └── api.test.js                        # 6 testes de integração automatizados (node --test)
│   └── web/                                       # Frontend React 19 + Vite (Porta 5173)
│       ├── AGENTS.md                              # Regras de frontend: fluxo de estado, atributos semânticos
│       └── src/
│           ├── api.js                             # Cliente fetch tipado para /api/v1/*
│           ├── App.jsx                            # Planta interativa do restaurante, formulário e agenda
│           └── styles.css                         # Estilos responsivos da interface
└── .agents/
    ├── hooks.json                                 # PreToolUse (command-guard.sh) + PostToolUse (node --check)
    └── skills/
        └── add-reservation-feature/               # Skill de implementação de funcionalidades full-stack em 6 passos
            ├── SKILL.md
            └── scripts/verify-fullstack.sh        # Executa verificação de sintaxe + 6 testes de API + build Vite
```

### Passo 1: Executar a Pipeline de Verificação Full-Stack (`npm test`)

```bash
cd examples/04-restaurant-reservation
npm test
```

**O Que Esperar:**

```text
=== [1/3] Checking Node.js backend syntax ===
  [OK] Backend syntax check passed.
=== [2/3] Running Node.js API integration test suite ===
✔ GET /api/v1/health returns service status ok
✔ GET /api/v1/tables returns 6 tables with availability for date and slot
✔ POST /api/v1/reservations creates a reservation and marks table unavailable
✔ POST /api/v1/reservations rejects double-booking the same table and slot with 409
✔ POST /api/v1/reservations rejects partySize exceeding table capacity with 400
✔ PATCH /api/v1/reservations/:id/cancel frees the table for rebooking
ℹ tests 6
ℹ pass 6
ℹ fail 0
=== [3/3] Verifying React frontend production build ===
✓ 30 modules transformed.
dist/index.html                   0.48 kB
dist/assets/index-C0_uB6c4.css    4.28 kB
dist/assets/index-D6xK3p9a.js   194.15 kB
✓ built in 760ms
=== Full-stack verification PASSED ===
```

### Passo 2: Iniciar a Aplicação Full-Stack (`npm start`)

```bash
cd examples/04-restaurant-reservation
npm start
```

**O Que Esperar:**
- A **API REST em Node.js** arranca em **`http://localhost:4000`** (`GET /api/v1/health`, `GET /api/v1/tables`, `GET /api/v1/reservations`, `POST /api/v1/reservations`, `PATCH /api/v1/reservations/:id/cancel`).
- O **Servidor de Desenvolvimento React 19 + Vite** arranca em **`http://localhost:5173`** (com `/api` encaminhado automaticamente via proxy para `http://localhost:4000`).
- Abra **`http://localhost:5173`** no seu navegador web:
  1. Selecione uma **Data (*Date*)**, um **Horário (*Time Slot*, das `17:30` às `21:00`)** e o **Número de Pessoas (*Party Size*, de `1` a `8` pessoas)**.
  2. Observe a **Planta Interativa do Restaurante (*Interactive Floor Plan*)** (mesas `T1` a `T6` distribuídas pelas zonas *Window*, *Main Hall*, *Patio* e *Private Room*):
     - Cartões verdes (**`Available`**) podem ser clicados para selecionar uma mesa.
     - Cartões vermelhos (**`Booked`**) indicam mesas já reservadas para essa data e horário.
     - Cartões cinzentos (**`Max N Guests`**) desativam automaticamente as mesas cuja capacidade é inferior ao número de pessoas selecionado.
  3. Preencha o formulário **New Reservation** e clique em **Confirm Reservation** — a planta do restaurante e a tabela **Reservations Schedule** atualizam-se de imediato.
  4. Clique em **Cancel** em qualquer reserva confirmada para libertar a mesa de volta para o estado **`Available`** em tempo real.

### Passo 3: Estender a Aplicação Utilizando o Blueprint Contract-First de 6 Passos

Tanto o ficheiro [`examples/04-restaurant-reservation/README.md`](./examples/04-restaurant-reservation/README.md) como o guia [`docs/adding-functionality-guide.md`](./examples/04-restaurant-reservation/docs/adding-functionality-guide.md) incluem três exercícios progressivos de extensão que pode construir **com o `agy`** (utilizando a skill `add-reservation-feature`) ou **manualmente**:

```text
Passo 1: Contrato Partilhado          -->  packages/shared/contracts.json
Passo 2: Validação Pura               -->  apps/api/src/validators.js
Passo 3: Store / Lógica de Negócio    -->  apps/api/src/store.js
Passo 4: Handler de Rota HTTP         -->  apps/api/src/server.js
Passo 5: Testes Automatizados de API  -->  apps/api/tests/api.test.js
Passo 6: Cliente & Interface React    -->  apps/web/src/api.js + apps/web/src/App.jsx
```

#### Exercício de Extensão A: Adicionar `occasion` & `dietaryNotes` às Reservas
Inicie o `agy` dentro de `examples/04-restaurant-reservation`:

```bash
cd examples/04-restaurant-reservation
agy
```

Prompt a introduzir no `agy`:

> `"Use the add-reservation-feature skill to add an 'occasion' field (none, birthday, anniversary, business) and a 'dietaryNotes' field (max 200 chars) to reservations across contracts.json, the Node.js API, API tests, and the React booking form and schedule table."`

#### Exercício de Extensão B: Adicionar uma Fila de Lista de Espera Full-Stack (`POST /api/v1/waitlist`)
Prompt a introduzir no `agy`:

> `"Use the add-reservation-feature skill to implement a Waitlist feature (GET /api/v1/waitlist and POST /api/v1/waitlist) in the backend store and server, add integration tests in apps/api/tests/api.test.js, and add a 'Join Waitlist' panel in apps/web/src/App.jsx when tables are full."`

#### Exercício de Extensão C: Adicionar Distintivo de Mesa VIP & Regra de Mínimo de Pessoas (`partySize >= 4`)
Prompt a introduzir no `agy`:

> `"Use the add-reservation-feature skill to mark Table T6 (Private Room) as isVip: true in contracts.json, enforce a minimum partySize of 4 for VIP tables in the backend store with a 400 validation error, add an API test, and render a gold VIP badge on VIP table cards in React."`

**O Que Esperar Após Cada Exercício:**
- Sempre que o `agy` edita um ficheiro `.js` em `apps/api/`, o hook `PostToolUse` (`.agents/scripts/post-edit-check.sh`) executa `node --check` automaticamente.
- No final do fluxo de trabalho, o `agy` executa `./.agents/skills/add-reservation-feature/scripts/verify-fullstack.sh`, garantindo que todos os testes de backend (`node --test`) e o *build* de produção em React (`vite build`) passam sem erros.

---

## Resolução de Problemas & Armadilhas Comuns

Caso os participantes encontrem dificuldades durante a sessão prática de Code-Along, utilize esta matriz de diagnóstico rápido:

| Sintoma / Erro | Causa Raiz | Correção Imediata |
| :--- | :--- | :--- |
| `agy: command not found` | `~/.local/bin` não consta no `PATH` da *shell* atual | Executar `./scripts/install-antigravity.sh && source ~/.bashrc` ou `export PATH="$HOME/.local/bin:$PATH"`. |
| Erro de autenticação / pedido de API Key | `GEMINI_API_KEY` não exportada ou `modelProvider` não definido | Voltar a executar `./scripts/install-antigravity.sh`, que configura `~/.gemini/antigravity-cli/settings.json` e `~/.bashrc`. |
| `EADDRINUSE: address already in use :4000` | Instância anterior do servidor da API do Lab 04 ainda em execução | Executar `lsof -ti:4000 \| xargs kill -9` (ou definir `PORT=4001`). |
| `Permission denied` ao executar scripts `.sh` | O `git clone` removeu a permissão de execução nos scripts de consola | Executar `chmod +x scripts/*.sh examples/*/.agents/scripts/*.sh examples/*/.agents/skills/*/scripts/*.sh`. |
| O agente ignora um novo ficheiro `SKILL.md` | Falta o cabeçalho YAML (*frontmatter* com `name` e `description`) | Garantir que o `SKILL.md` começa exatamente na linha 1 com `---`, `name: <kebab-case>`, `description: ...`, `---`. |
| O script de Hook falha ou bloqueia inesperadamente | O script de Hook imprimiu texto de *debug* não-JSON para o `stdout` | Redirecionar todos os *logs* de diagnóstico dos hooks para `stderr` (`>&2`) e emitir **apenas** JSON válido no `stdout`. |

---

## Principais Conclusões Arquiteturais

1. **Engenharia de Contexto Supera Engenharia de Prompts**: Ficheiros `AGENTS.md` hierárquicos e sob controlo de versões (`< 150 linhas` cada, dentro do orçamento de `24 KB` por ficheiro / `20.000 tokens` agregados) eliminam a repetição manual de instruções e mantêm o modelo alinhado com a sua arquitetura em todas as diretorias.
2. **A Revelação Progressiva Escala o Conhecimento da Equipa**: Empacotar fluxos de trabalho complexos em `.agents/skills/<nome>/SKILL.md`, acompanhados de scripts de validação (`scripts/`) e manuais técnicos (`references/`), dá ao agente conhecimento procedimental profundo consumindo praticamente zero *tokens* enquanto está inativo.
3. **Hooks Determinísticos Impõem Barreiras Inegociáveis**: Combinar guardas de segurança `PreToolUse` (`command-guard.sh`), verificações automáticas de sintaxe `PostToolUse` (`post-edit-check.sh`) e servidores **Model Context Protocol (MCP)** transforma um LLM num parceiro de engenharia fiável e pronto para produção.

---

### Agradecimentos Especiais

- **[TechPark CV](https://www.linkedin.com/company/techparkcv/posts/)** ([Publicação no LinkedIn](https://lnkd.in/p/emG5uTee))
- **[GDG Lisbon (Google Developer Group Lisbon)](https://gdg.community.dev/gdg-lisbon/)**
- **[Eimy Blanco](https://www.linkedin.com/in/eimy-blanco/)**
- **[Programa Google Developer Experts (GDE)](https://developers.google.com/community/experts)**

---

## Recursos & Ligações da Comunidade

- **Guia Oficial de Instalação do Antigravity CLI**: [antigravity.google/docs/install/?tab=cli](https://antigravity.google/docs/install/?tab=cli)
- **Referência Oficial do Antigravity CLI**: [antigravity.google/docs/cli/reference](https://antigravity.google/docs/cli/reference)
- **Blog Técnico do Autor & Guias de Arquitetura Cloud**: [nja.dev](https://nja.dev)
- **Diagramação Interativa de Arquitetura**: [DrawIt by NJA (`drawit.nja.dev`)](https://drawit.nja.dev/)
- **Perfil do Orador**: [Nuno João Andrade no LinkedIn](https://www.linkedin.com/in/nuno-andrade-964b2416)
- **Comunidade GDG Lisbon**: [gdg.community.dev/gdg-lisbon](https://gdg.community.dev/gdg-lisbon/)
