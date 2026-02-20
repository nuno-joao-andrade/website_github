---
title: "Building an AI Auditor with Gemini CLI: Spec-Driven Development in Action"
date: "2026-02-20"
description: "A deep dive into the GlobalAudit AI workshop, exploring how to use the Gemini CLI to orchestrate a serverless, multimodal compliance application purely through Markdown specifications."
image: "/assets/img/globalauditai-banner.png"
tags: [cloud, google cloud, gcp,  development, gde, google developer expert,nodejs, performance, intermediate, gemini-cli, multimodal, google-cloud, ai-agents, spec-driven-development]
---


**GlobalAudit AI** is an enterprise-grade multimodal application that automates corporate document auditing. Using **Gemini 3.1 Pro**, the system "reads" invoices, extracts structured data, and evaluates compliance against corporate policies—all within a secure, stateless Google Cloud environment.

But the most fascinating part of this workshop isn't just *what* the application does; it's *how* it's built. 

In this workshop, we move away from traditional line-by-line coding and embrace a new paradigm: **Spec-Driven Development with the Gemini CLI**.

![GlobalAudit AI Workflow Architecture](/assets/img/workflow-diagram.png)
*A high-level view of the Gemini CLI orchestration workflow.*

---

## 🧠 The Paradigm Shift: Coding by Specification

When using the `@google/gemini-cli` in an agentic workflow, the developer's role shifts from a "code writer" to a "system architect." Instead of writing Express routes or React hooks manually, you write highly structured Markdown documents that serve as the **brain** and the **orchestrator** for the AI.

In the GlobalAudit AI project, this is handled by two critical files:

1.  **`GEMINI.md` (The System Context):** This file defines the persona, the security boundaries, and the technical constraints. It tells the AI:
    *   *Constraint 1:* "All file handling must be stateless. Use `@google/genai` for enterprise-grade access."
    *   *Constraint 2:* "Implement an `fs.unlinkSync(path)` call within a `finally` block to delete uploaded files immediately after model inference."
    *   *Constraint 3:* "Do NOT use `.env` files. Rely exclusively on system environment variables."

2.  **`INIT-WORKSHOP.md` (The Runbook):** This file contains the step-by-step instructions (Tasks 1 through 7) that the Gemini CLI will execute. It maps the high-level prompts defined in `GEMINI.md` to specific file paths and commands.

By treating these Markdown files as source code, the Gemini CLI acts as a highly capable sub-agent that autonomously scaffolds the entire project, ensuring all generated code strictly adheres to the defined architectural constraints.

---

## 🔍 What is GlobalAudit AI?

At its core, GlobalAudit AI is a compliance engine deployed on Google Cloud Run. 

*   **Frontend:** A zero-build React 18 SPA styled with Tailwind CSS, served directly from `public/index.html`. It provides a clean, corporate dashboard for uploading invoices.
*   **Backend:** A lightweight Node.js Express server (`index.js`).
*   **The Intelligence:** Instead of complex OCR pipelines and brittle Regex, the backend passes the uploaded image and a carefully crafted prompt directly to the **Gemini 3.1 Pro Preview** model.

**The Prompt Logic:**
The model is instructed to extract the `Vendor`, `Date`, `Amount`, and `TaxID` (treating "VAT ID", "TIN", etc., as equivalents). It evaluates two primary compliance rules:
1.  **Compliance Risk:** Is the `TaxID` missing, or is it just a placeholder like "[Insert VAT ID]"? If so, flag it.
2.  **Manual Review:** Is the invoice amount greater than `$5,000`? If so, flag it for human oversight.

---

## 🛠️ The Workshop Breakdown: Orchestrating the Build

Using the Gemini CLI, the entire application is brought to life through a sequence of automated tasks:

### 1. Generating the Application Logic
The CLI reads the `INIT-WORKSHOP.md` specs and generates the `index.js` (backend), the `index.html` (frontend), and the `package.json`. It applies the strict stateless `/tmp` file handling rules dictated in the specs.

### 2. Synthesizing Multimodal Test Data
You can't test an AI invoice auditor without invoices. Using the `nanobanana` MCP (Model Context Protocol) server integrated with the Gemini CLI, the agent dynamically generates **six highly-specific sample invoices**:
*   **3 Compliant (OK) Invoices:** Including standard receipts, software subscriptions with alphanumeric VAT IDs, and professional consulting invoices.
*   **3 Non-Compliant (NOT OK) Invoices:** Including high-value invoices (triggering Manual Review) and messy handwritten receipts missing a Tax ID (triggering Compliance Risk).

### 3. Automated Verification & Testing
A truly agentic workflow must verify its own work. The CLI is instructed to act as a "QA Automation Engineer" to generate two test suites using Jest and Supertest:
*   **`tests/unit.test.js`:** Mocks the `@google/genai` SDK to validate the backend's routing and risk evaluation logic rapidly.
*   **`tests/e2e.test.js`:** Spawns the server locally, uploads the 6 dynamically generated sample images, and asserts that the actual AI model's responses match the expected compliance flags.

### 4. DevOps & Cloud Run Deployment
Finally, the CLI generates the production-ready `Dockerfile` (optimized for Node 20-slim and `/tmp` permissions) and the `deploy.sh` script required to push the stateless container to Google Cloud Run.

---

## 🚀 Conclusion

The **GlobalAudit AI** workshop is a masterclass in the future of software engineering. By mastering **Spec-Driven Development** with the `gemini-cli`, developers can focus on architecture, constraints, and business logic, while the AI agent handles the heavy lifting of implementation, data generation, and testing.

You aren't just writing code anymore; you are managing a digital development team.

---

## 📚 Resources & Links

*   **[GlobalAudit AI GitHub Repository](https://github.com/nuno-joao-andrade-dev/globalauditai.gemini.series)**
*   **[System Architecture Deep-Dive](https://github.com/nuno-joao-andrade-dev/globalauditai.gemini.series/blob/main/doc/ARCHITECTURE.md)**
*   **[Backend Implementation Details](https://github.com/nuno-joao-andrade-dev/globalauditai.gemini.series/blob/main/doc/BACKEND.md)**
*   **[Frontend Implementation Details](https://github.com/nuno-joao-andrade-dev/globalauditai.gemini.series/blob/main/doc/FRONTEND.md)**
*   **[Testing Strategy Overview](https://github.com/nuno-joao-andrade-dev/globalauditai.gemini.series/blob/main/doc/TESTING.md)**
*   **[Deployment & DevOps Guide](https://github.com/nuno-joao-andrade-dev/globalauditai.gemini.series/blob/main/doc/DEPLOYMENT.md)**
