---
title: "AI Exam Prep with Google ADK & Local Gemma 4: Hands-On JavaScript Code-Along (IADE & GDG Lisbon)"
date: 2026-10-26 10:00:00 +0100
categories: [AI Engineering, Workshops]
tags: [google-adk, gemma4, ollama, javascript, nodejs, react, rag, socratic-agent, structured-outputs, zod, gdg-lisbon, iade]
author: Nuno João Andrade
description: "A complete, code-first JavaScript (ES Modules) workshop and architectural guide on building a 100% offline AI Exam Prep platform with Google ADK (@google/adk), local Gemma 4 (gemma4:e2b via Ollama), area-parameterized Markdown RAG (data/[area]/[content files]), Socratic mentoring with ADK Web UI, deterministic rubric grading, and a React Markdown-First interface."
image:
  path: /assets/ai-exam-prep/slide-01.png
  alt: "AI Exam Prep in Plain JavaScript — Step-by-Step Code Walkthrough with Google ADK, Local Gemma 4 & React (GDG Lisbon & IADE)"
---

# AI Exam Prep with Google ADK & Local Gemma 4: Hands-On JavaScript Code-Along

> **Workshop GitHub Repository**: [https://github.com/nuno-joao-andrade-dev/ai-exam-prep](https://github.com/nuno-joao-andrade-dev/ai-exam-prep)
> **Interactive Presentation Slides**: [https://nuno-joao-andrade-dev.github.io/ai-exam-prep/slides/](https://nuno-joao-andrade-dev.github.io/ai-exam-prep/slides/)
>
> ```bash
> git clone https://github.com/nuno-joao-andrade-dev/ai-exam-prep.git
> cd ai-exam-prep
> npm install
> ```

> **Special Thanks**: A special thank you to **IADE**, **[Lurdes Ferraz](https://www.linkedin.com/in/lurdes-ferraz-0061923a9/)**, **[Nathan Campos](https://www.linkedin.com/in/nathanpc/)**, **[GDG Lisbon](https://gdg.community.dev/gdg-lisbon/)**, and **[Eimy Blanco](https://www.linkedin.com/in/eimy-blanco/)** for the invitation, organization, and support in making this hands-on session possible!

Welcome to the complete technical walkthrough of the **AI Exam Prep in Plain JavaScript — Step-by-Step Code-Along Workshop**, presented with **IADE** and **GDG Lisbon**. In this practical engineering session, we build a complete, **100% local and offline AI Exam Preparation & Socratic Study System** from the ground up using **Plain JavaScript (ES Modules, Node.js 22+)**, the **Google Agent Development Kit (`@google/adk`)**, **Local Gemma 4 (`gemma4:e2b`)** running via **Ollama**, and a **React + Vite Web Interface** (`question-interface`).

Instead of relying on opaque cloud wrappers, complex TypeScript compilation pipelines, or external vector database containers, this workshop demonstrates how to structure a clean, modular 5-step agentic pipeline where study materials live in **`data/[area]/[content files]`** and any subject area (`javascript`, `ai-agents`, `cloud`, or your own custom Markdown notes) can be passed dynamically as a CLI argument or URL parameter.

![Slide 01 — Simple JavaScript Folder Layout & data/[area]/[content files]](/assets/ai-exam-prep/slide-01.png)

> [!NOTE]
> **Primary Architectural Goal**: Empower developers and students to build a privacy-first, zero-API-cost agentic study companion that grounds every exam question, Socratic hint, and rubric evaluation strictly in local Markdown study notes (`data/[area]/*.md`), while supporting both interactive CLI execution, the **Google ADK DevTools Web UI (`adk web`)**, and a full-stack **React Markdown Preview** web interface.

---

## About the Speaker & the GDG Lisbon + IADE Session

This workshop was created for the **IADE** academic and developer community in partnership with **Google Developer Groups (GDG) Lisbon** by **Nuno João Andrade** ([nja.dev](https://nja.dev)), **Google Developer Expert (GDE)** in Google Cloud & Modern Infrastructure and Senior Backend & Cloud Architect.

- **Plain JavaScript by Design**: Every step (`step-01-setup` through `step-05-grading-complete`) is written in native **Node.js ES Modules (`.js`)** using built-in `fetch()`—zero TypeScript build steps, zero external HTTP client bloat, and instant execution inside each folder (`cd step-0X-... && npm start <area>`).
- **Dynamic Content Parameterization (`data/[area]/[content files]`)**: Drop any `.md` or `.txt` files into `data/<area>/` and pass `<area>` as a parameter in the terminal (`node index.js javascript`, `node index.js ai-agents`, `node index.js cloud`) or in the React Web UI (`?area=javascript` or via the **+ Pass Custom Content Parameter** drawer).

---

## Why Local-First Agentic Exam Prep? Ad-Hoc Cloud Chat vs. Structured ADK + Local Gemma 4

When students or engineering teams use generic cloud chatbots to study for technical exams, three problems immediately surface: **hallucinated syllabus details**, **instant answer spoilers** (which rob the learner of active recall), and **inconsistent grading**. Comparing ad-hoc chat with our structured **Google ADK + Local Gemma 4** architecture highlights why a deterministic multi-step pipeline is essential:

| Dimension | Ad-Hoc Cloud LLM Chat | Local-First AI Exam Prep (`@google/adk` + `gemma4:e2b`) |
| :--- | :--- | :--- |
| **Syllabus Grounding** | Unbounded general knowledge; often invents APIs or concepts outside the course | Grounded strictly in **`data/[area]/[content files]`** via an ADK `FunctionTool` (`search_area_content`) |
| **Exam Structure** | Unstructured prose questions with arbitrary point values | Deterministic **20-point JSON Schema** (`EXAM_JSON_SCHEMA`) validated at runtime with **Zod** |
| **Learning Pedagogy** | Spoils the full solution immediately when asked for help | **Socratic Study Mentor Agent** (`step-04-socratic-agent`) gives a 2–4 sentence hint + **one guiding question** |
| **Answer Grading** | Vague "Good job!" feedback without criterion-level breakdown | **Deterministic Rubric Grader** (`step-05-grading-complete`) scoring each criterion against `data/[area]/` notes |
| **Cost & Privacy** | Requires paid API keys and sends study notes to external servers | **100% Offline & Free**: runs locally on `gemma4:e2b` via Ollama (`127.0.0.1:11434`) |

---

## System Architecture Blueprint & Progressive 5-Step Curriculum

The repository is organized into shared foundation helpers (`src/shared/`), five progressive self-contained step folders (`step-01-setup` to `step-05-grading-complete`), and a full-stack React web interface (`question-interface/`):

```text
examprep/
├── data/                         # Pass any <area> folder name as a parameter!
│   ├── javascript/
│   │   ├── 01-event-loop-async.md
│   │   └── 02-closures-scopes.md
│   ├── ai-agents/
│   │   ├── 01-adk-fundamentals.md
│   │   └── 02-rag-and-gemma.md
│   └── cloud/
│       ├── 01-containers-and-scaling.md
│       └── 02-caching-and-cdns.md
├── src/shared/
│   ├── content-loader.js         # Loads & searches data/[area]/*.md (or customContent)
│   └── ollama-llm.js             # Minimal ADK BaseLlm adapter using native fetch()
├── step-01-setup/                # Step 1: Verify Ollama + ADK LlmAgent
├── step-02-rag/                  # Step 2: ADK FunctionTool over data/[area]/
├── step-03-exam-gen/             # Step 3: Structured 20-pt JSON exam + rubric generator
├── step-04-socratic-agent/       # Step 4: Multi-turn Socratic Mentor + `adk web` UI
├── step-05-grading-complete/     # Step 5: Deterministic rubric grader + Express API (:3000)
└── question-interface/           # React + Vite Web UI (:5173) with Markdown Preview boxes
```

### The 5-Step Workshop Roadmap

| Step Folder | Architectural Focus | Key Primitives Demonstrated | Execution Command |
| :--- | :--- | :--- | :--- |
| **`step-01-setup/`** | Connectivity & First ADK Agent Turn | `OllamaGemmaLlm` (`BaseLlm`), `LlmAgent`, `InMemoryRunner`, `loadAreaContent(area)` | `cd step-01-setup && npm start javascript` |
| **`step-02-rag/`** | Area Content RAG Tool | `FunctionTool` (`search_area_content`), Zod tool parameters, heading-aware Markdown chunking | `cd step-02-rag && npm start javascript` |
| **`step-03-exam-gen/`** | Structured 20-Point Exam & Rubric Generator | Ollama JSON Schema (`format: EXAM_JSON_SCHEMA`), `ExamQuestionSchema` Zod validation | `cd step-03-exam-gen && npm start javascript` |
| **`step-04-socratic-agent/`** | Multi-Turn Socratic Mentor & ADK DevTools Web UI | Multi-turn `InMemoryRunner`, Socratic system rules, `export const rootAgent`, `adk web` (`:8000`) | `cd step-04-socratic-agent && npm start javascript` (or `npm run web`) |
| **`step-05-grading-complete/`** | Deterministic Rubric Grader & Full-Stack Express API | Criterion-by-criterion JSON grading (`EVALUATION_JSON_SCHEMA`), REST API (`server.js` on `:3000`) | `cd step-05-grading-complete && npm start javascript` |

---

## Step 0: Environment Setup & Offline Model Distribution

### 1. Install Node.js 22+ & Ollama Local LLM Runtime

![Slide 02 — Install Node.js 22+ & Ollama Local LLM Server](/assets/ai-exam-prep/slide-02.png)

Node.js 22+ runs ES Modules (`"type": "module"`) and built-in `fetch()` natively—no TypeScript build step or external HTTP libraries required:

```bash
# 1. Verify Node.js v22+ and npm
node --version   # v22.x or newer
npm --version

# 2. Install Ollama on Linux (or `brew install ollama` on macOS)
curl -fsSL https://ollama.com/install.sh | sh

# 3. Start Ollama daemon if not already running as a systemd service
ollama serve &

# 4. Verify the local Ollama HTTP API is responding on port 11434
curl http://127.0.0.1:11434/api/tags
```

### 2. Pull Local `gemma4:e2b` & Install Workspace Dependencies

![Slide 03 — Pull Local gemma4:e2b & Install Workspace Dependencies](/assets/ai-exam-prep/slide-03.png)

Pull the local Gemma 4 model (`gemma4:e2b`) once for offline inference, then run `npm install` at the repository root to link all 5 step workspaces and `question-interface`:

```bash
# 1. Download local Gemma 4 model
ollama pull gemma4:e2b

# 2. Test local inference in CLI
ollama run gemma4:e2b "Say hello in 1 sentence."

# 3. Clone the repository and install all workspace dependencies
git clone https://github.com/nuno-joao-andrade-dev/ai-exam-prep.git
cd ai-exam-prep
npm install
```

> [!TIP]
> **Classroom Offline USB Model Installation (`OLLAMAMODEL`)**: In a live classroom where 30+ participants shouldn't download 4.6 GB over venue Wi-Fi simultaneously, the repository includes **[OFFLINE-MODEL-SETUP.md](https://github.com/nuno-joao-andrade-dev/ai-exam-prep/blob/main/OFFLINE-MODEL-SETUP.md)** with ready-to-run commands for copying the `models/` folder (`blobs/`, `manifests/`, `manifests-v2/`, `metadata/`) directly from the `OLLAMAMODEL` USB drive on **Windows (PowerShell)**, **macOS**, and **Linux** with zero internet usage.

The root `package.json` provides clean scripts for running individual steps, launching the **Google ADK DevTools Web UI** (`step04:web`), or starting the **Express API + React Web UI + Slide Deck** simultaneously with `concurrently`:

```json
{
  "scripts": {
    "dev": "concurrently -n api,ui,slides -c green,cyan,magenta \"npm run server\" \"npm run ui\" \"npm run slides\"",
    "step01": "node step-01-setup/index.js",
    "step02": "node step-02-rag/index.js",
    "step03": "node step-03-exam-gen/index.js",
    "step04": "node step-04-socratic-agent/index.js",
    "step04:web": "adk web step-04-socratic-agent/index.js --compile false --bundle false",
    "step05": "node step-05-grading-complete/index.js",
    "server": "node step-05-grading-complete/server.js",
    "ui": "npm --prefix question-interface run dev",
    "ui:build": "npm --prefix question-interface run build",
    "slides": "node src/shared/serve-slides.js",
    "test:all": "node src/shared/test-all.js"
  }
}
```

---

## Shared Core Architecture: `data/[area]/[content files]` & the ADK Ollama Adapter

### 1. Organizing Study Notes in `data/[area]/[content files]`

![Slide 04 — Adding Study Notes in data/[area]/[content files]](/assets/ai-exam-prep/slide-04.png)

Every subfolder inside `data/` represents a study area (`javascript`, `ai-agents`, `cloud`, or any new folder you create). Markdown files inside each area folder are automatically split into semantic sections by `## ` headings:

```markdown
<!-- data/javascript/01-event-loop-async.md -->
# Event Loop, Microtasks & Async JavaScript

## Slide 1: The Single-Threaded Runtime Model
JavaScript executes code on a single main thread:
- **Call Stack:** Executes synchronous functions (LIFO).
- **Task / Macrotask Queue:** `setTimeout`, `setInterval`.
- **Microtask Queue:** `Promise.then`, `queueMicrotask`.

## Slide 2: Microtask Queue vs. Macrotask Queue
After the Call Stack empties, the Event Loop drains **100% of the Microtask Queue**
before taking the next Macrotask:
`Sync Code -> All Microtasks -> Next Macrotask`
```

### 2. Loading & Chunking Area Files (`src/shared/content-loader.js`)

![Slide 05 — Loading Area Content: src/shared/content-loader.js](/assets/ai-exam-prep/slide-05.png)

`getAreaArg()` reads the `<area>` parameter from the command line (`node index.js javascript`), while `loadAreaContent(area, customContent)` loads either the Markdown files in `data/[area]/` or a raw `customContent` Markdown string passed dynamically from the React Web UI:

```javascript
// src/shared/content-loader.js
export function getAreaArg(defaultArea = 'javascript') {
  const args = process.argv.slice(2).filter((a) => a !== '--demo');
  for (const arg of args) {
    if (arg.startsWith('--area=')) return arg.split('=')[1];
    if (!arg.startsWith('-')) return arg;
  }
  return process.env.AREA || defaultArea;
}

export function loadAreaContent(area = 'javascript', customContent = '') {
  const areaPath = path.join(DATA_DIR, area);
  const files = [];
  const chunks = [];

  if (customContent && customContent.trim()) {
    files.push({ file: 'custom-parameter.md', content: customContent.trim() });
    chunks.push(...chunkMarkdownContent(area, 'custom-parameter.md', customContent));
  } else {
    for (const entry of fs.readdirSync(areaPath, { withFileTypes: true })) {
      if (!entry.isFile() || !/\.(md|txt)$/i.test(entry.name)) continue;
      const raw = fs.readFileSync(path.join(areaPath, entry.name), 'utf-8');
      files.push({ file: entry.name, content: raw.trim() });
      chunks.push(...chunkMarkdownContent(area, entry.name, raw));
    }
  }
  return { area, files, chunks };
}
```

### 3. Keyword & Heading-Boosted Retrieval (`searchAreaContent`)

![Slide 06 — Chunking & Searching Area Notes: src/shared/content-loader.js](/assets/ai-exam-prep/slide-06.png)

Rather than requiring an external vector database container, `searchAreaContent({ area, query, topK, customContent })` scores each Markdown section by keyword frequency with a `+1.5` relevance boost when query terms appear in the section heading:

```javascript
export function searchAreaContent({ area = 'javascript', query = '', topK = 3, customContent = '' } = {}) {
  const { area: resolvedArea, chunks } = loadAreaContent(area, customContent);
  if (!query || !query.trim()) {
    return { area: resolvedArea, query, results: chunks.slice(0, topK) };
  }

  const terms = query
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, ' ')
    .split(/\s+/)
    .filter((t) => t.length >= 2);

  const scored = chunks.map((chunk) => {
    const haystack = `${chunk.docTitle} ${chunk.heading} ${chunk.content}`.toLowerCase();
    let score = 0;
    for (const term of terms) {
      if (haystack.includes(term)) {
        score += 1;
        if (chunk.heading.toLowerCase().includes(term)) score += 1.5;
      }
    }
    return { ...chunk, score: Number(score.toFixed(2)) };
  });

  scored.sort((a, b) => b.score - a.score);
  return { area: resolvedArea, query, results: scored.slice(0, topK) };
}
```

### 4. Bridging `@google/adk` to Local Ollama (`src/shared/ollama-llm.js`)

![Slide 07 — Google ADK Local Ollama Adapter: src/shared/ollama-llm.js](/assets/ai-exam-prep/slide-07.png)

`OllamaGemmaLlm` extends `BaseLlm` from `@google/adk` and communicates with Ollama's `/api/chat` endpoint using Node's native `fetch()`, automatically translating ADK `functionDeclarations` into Ollama `tools` and yielding ADK `functionCall` parts when `gemma4:e2b` invokes a tool:

```javascript
import { BaseLlm, InMemoryRunner } from '@google/adk';

export class OllamaGemmaLlm extends BaseLlm {
  constructor({ model = 'gemma4:e2b', temperature = 0.2 } = {}) {
    super({ model });
    this.model = model;
    this.temperature = temperature;
  }

  async *generateContentAsync(llmRequest) {
    const response = await ollamaChat({
      model: this.model,
      messages: buildOllamaMessages(llmRequest),
      tools: buildOllamaTools(llmRequest),
      options: { temperature: this.temperature },
    });

    const msg = response.message || {};
    if (msg.tool_calls?.length) {
      yield {
        content: {
          role: 'model',
          parts: msg.tool_calls.map((tc) => ({
            functionCall: { name: tc.function.name, args: tc.function.arguments },
          })),
        },
      };
      return;
    }
    yield { content: { role: 'model', parts: [{ text: msg.content || '' }] } };
  }
}
```

---

## Step-by-Step Hands-On Walkthrough (`step-01` to `step-05`)

### Step 01: Setup & Hello Gemma 4 (`step-01-setup/index.js`)

![Slide 08 — Execute Step 01: cd step-01-setup && node index.js <area>](/assets/ai-exam-prep/slide-08.png)

**Goal**: Verify that Ollama is reachable, list all study areas inside `data/`, load the Markdown files for the selected `<area>`, and run a first turn through Google ADK's `LlmAgent`.

```bash
# Run from inside the Step 01 folder:
cd step-01-setup
npm start javascript          # or: node index.js ai-agents / node index.js cloud

# Or from the root folder:
npm run step01 -- javascript
```

---

### Step 02: Area Content RAG Tool (`step-02-rag/index.js`)

![Slide 09 — Execute Step 02: cd step-02-rag && node index.js <area>](/assets/ai-exam-prep/slide-09.png)

**Goal**: Wrap `searchAreaContent` inside a Google ADK `FunctionTool` (`search_area_content`) with a Zod parameter schema so `gemma4:e2b` automatically searches `data/[area]/` and cites the exact Markdown file before answering.

```bash
# Run from inside the Step 02 folder:
cd ../step-02-rag
npm start javascript          # or: node index.js javascript "microtask queue promise"

# Or from the root folder:
npm run step02 -- cloud
```

---

### Step 03: Structured 20-Point Exam & Rubric Generator (`step-03-exam-gen/index.js`)

![Slide 10 — Execute Step 03: cd step-03-exam-gen && node index.js <area>](/assets/ai-exam-prep/slide-10.png)

**Goal**: Retrieve the top Markdown chunks from `data/[area]/` and use Ollama's structured JSON schema mode (`format: EXAM_JSON_SCHEMA`) combined with `ExamQuestionSchema.parse(...)` (Zod) to generate a deterministic **20-point technical exam question**, realistic scenario, 3-criterion grading rubric (`8 + 7 + 5 = 20 points`), and sample ideal answer.

```bash
# Run from inside the Step 03 folder:
cd ../step-03-exam-gen
npm start javascript          # or: node index.js javascript "Event Loop and Closures"

# Or from the root folder:
npm run step03 -- cloud "Horizontal Scaling and Cache Stampede"
```

---

### Step 04: Socratic Study Mentor Agent & Google ADK Web UI (`step-04-socratic-agent/index.js`)

![Slide 11 — Execute Step 04: cd step-04-socratic-agent && node index.js <area>](/assets/ai-exam-prep/slide-11.png)

**Goal**: Build a multi-turn **Socratic Study Mentor** agent (`createSocraticMentorAgent`) that uses `createAreaSearchTool(area)` to check the student's study notes in `data/[area]/` and provides a short conceptual hint (2–4 sentences) ending with **one guiding question**—never spoiling the final exam answer.

Step 04 also exports `export const rootAgent = createSocraticMentorAgent({ area: process.env.AREA || 'javascript' })` so you can inspect tool calls, events, and multi-turn state visually inside the official **Google ADK DevTools Web UI (`adk web`)** on `http://localhost:8000`!

```bash
# Run the multi-turn CLI demo inside step-04-socratic-agent:
cd ../step-04-socratic-agent
npm start javascript

# Or launch the interactive Google ADK DevTools Web UI on http://localhost:8000:
npm run web
# (With a custom area: AREA=cloud npm run web)

# Or from the root folder:
npm run step04 -- javascript
npm run step04:web
```

---

### Step 05: Deterministic Rubric Grader & Express API Server (`step-05-grading-complete/`)

![Slide 12 — Execute Step 05: cd step-05-grading-complete && node index.js <area>](/assets/ai-exam-prep/slide-12.png)

**Goal**: Grade any student Markdown submission against each criterion in the exam rubric and the reference notes in `data/[area]/`, returning per-criterion awarded points, justifications, overall feedback, and actionable improvement suggestions.

```bash
# Run the CLI rubric grader demo:
cd ../step-05-grading-complete
npm start javascript

# Or from the root folder:
npm run step05 -- javascript
```

![Slide 13 — Backend API Server: step-05-grading-complete/server.js](/assets/ai-exam-prep/slide-13.png)

`step-05-grading-complete/server.js` exposes the complete pipeline over HTTP (`http://localhost:3000`) for the React Web Interface. Every endpoint accepts both `area` (folder name inside `data/`) and optional `customContent` (raw Markdown passed from the UI):
- `GET /api/status?area=<area>`: Lists all available `data/[area]` folders, loaded files, and Ollama connectivity status.
- `POST /api/rag/search`: Runs `searchAreaContent({ area, query, topK, customContent })`.
- `POST /api/exam/generate`: Generates a 20-point exam question and rubric for `area` + `topic`.
- `POST /api/socratic/chat`: Multi-turn Socratic mentor chat grounded in `data/[area]/`.
- `POST /api/grade/evaluate`: Evaluates the student's Markdown answer against the 20-point rubric.

---

## Full-Stack React Web Interface (`question-interface/`)

### 1. Passing `area` and `customContent` as Parameters

![Slide 14 — Passing Content as a Parameter in question-interface/src/App.jsx](/assets/ai-exam-prep/slide-14.png)

In `question-interface/src/App.jsx`, you can switch study areas or pass custom study notes in three ways:
1. **URL Query Parameter (`?area=javascript`, `?area=ai-agents`, `?area=cloud`)**: Automatically synced with `window.history.replaceState`.
2. **Header Area Selector Dropdown**: Switches between any folder discovered inside `data/`.
3. **`+ Pass Custom Content Parameter` Drawer (or `?content=...`)**: Paste any custom Markdown lecture notes directly in the browser to override `data/[area]/` on the fly for RAG search, exam generation, Socratic mentoring, and rubric grading.

### 2. Markdown Preview Boxes (`<MarkdownPreview />` & `<MarkdownBox />`)

![Slide 15 — Markdown Preview Boxes: question-interface/src/components/MarkdownPreview.jsx](/assets/ai-exam-prep/slide-15.png)

To make technical scenarios, code snippets, rubrics, and student answers effortless to read, most boxes in the React UI render formatted Markdown previews by default:
- Read-only displays (exam scenario, question prompt, rubric criteria, sample solution, Socratic mentor replies, and RAG source excerpts) use `<MarkdownPreview />`.
- Interactive inputs (student answer box, Socratic chat input, and custom content parameter editor) use `<MarkdownBox defaultMode="preview" />` with instant **`Markdown Preview | Split | Edit MD`** mode tabs.

---

## Running Everything End-to-End

![Slide 16 — Running Every Step & Launching the React Web Interface](/assets/ai-exam-prep/slide-16.png)

Use `npm run dev` at the repository root to launch the **Express API Server (`:3000`)**, **React Vite Web UI (`:5173`)**, and **GDG Lisbon Slide Deck (`:3030`)** concurrently:

```bash
# Run API Server (:3000) + React Web UI (:5173) + Slide Deck (:3030) together:
npm run dev

# Or run all 5 steps in automated demo mode to verify your setup:
npm run test:all -- javascript
```

Open your browser at:
- **React Exam Prep Web UI**: `http://localhost:5173/?area=javascript` (or `?area=ai-agents`, `?area=cloud`)
- **Interactive Slide Deck**: `http://localhost:3030`
- **Google ADK DevTools Web UI (Step 4)**: `npm run step04:web` &rarr; `http://localhost:8000`

---

## Troubleshooting & Common Workshop Pitfalls

| Symptom / Error | Root Cause | Immediate Fix |
| :--- | :--- | :--- |
| `fetch failed` / `ECONNREFUSED 127.0.0.1:11434` | Ollama daemon is not running | Run `ollama serve` in a terminal (or `sudo systemctl start ollama` on Linux). |
| `model "gemma4:e2b" not found` | Model has not been pulled or copied into Ollama's `models/` directory | Run `ollama pull gemma4:e2b` or copy `models/` from the `OLLAMAMODEL` USB drive (`OFFLINE-MODEL-SETUP.md`). |
| `Unknown area "<name>"` | Folder `data/<name>` does not exist | Check available folders in `data/` (`javascript`, `ai-agents`, `cloud`) or create `data/<name>/notes.md`. |
| `No rootAgent found` when running `adk web` | Running `adk web` without disabling TypeScript bundling on an ESM `.js` file | Use `npm run web` (inside `step-04-socratic-agent`) or `npm run step04:web` (which passes `--compile false --bundle false`). |

---

## Key Architectural Takeaways

1. **Plain JavaScript + `@google/adk` Keeps Agentic Code Accessible**: Extending `BaseLlm` with 60 lines of native `fetch()` code (`src/shared/ollama-llm.js`) connects Google ADK's `LlmAgent`, `FunctionTool`, `InMemoryRunner`, and `adk web` directly to local Ollama models with zero cloud dependencies.
2. **Convention Over Configuration (`data/[area]/[content files]`)**: Organizing study notes into `data/[area]/*.md` and splitting on `## ` headings turns any folder of Markdown notes into a searchable knowledge base (`search_area_content`) without vector database infrastructure.
3. **Structured Schemas + Socratic Guardrails Transform Pedagogy**: Combining Ollama's JSON Schema enforcement (`format`) with Zod validation guarantees deterministic 20-point exams and rubric scores, while Socratic system instructions ensure the agent mentors students instead of spoiling answers.

---

### Special Thanks

- **IADE — Faculdade de Design, Tecnologia e Comunicação**
- **[Lurdes Ferraz](https://www.linkedin.com/in/lurdes-ferraz-0061923a9/)**
- **[Nathan Campos](https://www.linkedin.com/in/nathanpc/)**
- **[GDG Lisbon (Google Developer Group Lisbon)](https://gdg.community.dev/gdg-lisbon/)**
- **[Eimy Blanco](https://www.linkedin.com/in/eimy-blanco/)**
- **[Google Developer Experts (GDE) Program](https://developers.google.com/community/experts)**

---

## Resources & Community Links

- **Workshop GitHub Repository**: [github.com/nuno-joao-andrade-dev/ai-exam-prep](https://github.com/nuno-joao-andrade-dev/ai-exam-prep)
- **Live Workshop Slides**: [nuno-joao-andrade-dev.github.io/ai-exam-prep/slides/](https://nuno-joao-andrade-dev.github.io/ai-exam-prep/slides/)
- **Offline Classroom Model Guide**: [OFFLINE-MODEL-SETUP.md](https://github.com/nuno-joao-andrade-dev/ai-exam-prep/blob/main/OFFLINE-MODEL-SETUP.md)
- **Author's Technical Blog & Cloud Architecture Guides**: [nja.dev](https://nja.dev)
- **Interactive Architecture Diagramming**: [DrawIt by NJA (`drawit.nja.dev`)](https://drawit.nja.dev/)
- **Speaker Profile**: [Nuno João Andrade on LinkedIn](https://www.linkedin.com/in/nuno-andrade-964b2416)
- **GDG Lisbon Community**: [gdg.community.dev/gdg-lisbon](https://gdg.community.dev/gdg-lisbon/)
