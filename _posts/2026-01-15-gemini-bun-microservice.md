---
layout: post
title: "Gemini Test: Bun vs Node Benchmark - Without Writing a Single Line of Code"
date: 2026-01-15 08:00:00 -0000
categories: [blog, introduction, cloud, microservices, performance,development]
tags: [cloud, google cloud, gcp, backend, development, nodejs, bun,builtwithai, vibecoding]
image:
  path: /assets/img/bun-vs-node-v2.png
---

# Gemini Test: Bun vs Node Benchmark - Without Writing a Single Line of Code

**Can an AI agent autonomously build and benchmark high-performance microservices?** 

This project is a real-world experiment to answer that question. Using the **Gemini 3 Pro** model via the `gemini-cli`, we've orchestrated a complete "no-code" workflow to generate, deploy, and benchmark two identical microservices: one built on the battle-tested **Node.js** and the other on the ultra-fast **Bun** runtime.

This guide details how we set up this experiment, the specifications we fed the AI, and how you can replicate it yourself to see which runtime reigns supreme.

---

## 🧪 The Experiment

The goal is simple but ambitious: 
1.  **Define** strict architectural specifications for two identical microservices.
2.  **Prompt** the Gemini AI agent to build the entire system from scratch—including code, tests, Dockerfiles, and deployment scripts.
3.  **Benchmark** both services side-by-side using `wrk` to measure throughput and latency.
4.  **Do it all without writing a single line of application code manually.**

### The Contenders

| Feature | Node.js Service | Bun Service |
| :--- | :--- | :--- |
| **Runtime** | Node.js (v22+ LTS) | Bun (Latest) |
| **Language** | TypeScript | TypeScript (Native) |
| **Framework** | Fastify (for speed) | ElysiaJS or Bun.serve |
| **Database** | `node:sqlite` (Native) | `bun:sqlite` (Native) |
| **Deployment** | Google Cloud Run | Google Cloud Run |

---

## 🚀 How to Replicate With Gemini CLI

You can run this entire experiment yourself. All you need is the `gemini-cli` and the specification files included in this repository.

### 1. Prerequisites
Ensure you have the following tools installed. These are required to run the agent, the runtimes, and the benchmarks:

- **[Gemini CLI](https://github.com/GoogleCloudPlatform/gemini-cli)**: The AI agent interface.
- **[Node.js](https://nodejs.org/)** (v22+): For running the Node.js microservice.
- **[Bun](https://bun.sh/)** (Latest): For running the Bun microservice.
- **[Docker](https://docs.docker.com/get-docker/)**: For containerization and Cloud Run deployment.
- **[Google Cloud SDK](https://cloud.google.com/sdk/docs/install)**: For authenticated deployment to Cloud Run.
- **[wrk](https://github.com/wg/wrk)**: The HTTP benchmarking tool (e.g., `sudo apt-get install wrk`).

> **Note**: This project includes automation scripts to help you get started quickly. The `install_tools.sh` script can automate the installation of Node.js, Bun, gcloud, and wrk, while `setup_deploy.sh` handles Docker. Finally, `setup.sh` will initialize the services and seed the database.

### 2. Fetch the Code
Clone the repository to your local machine:

```bash
git clone https://github.com/nuno-joao-andrade-dev/bun.microservice.performance.git
cd bun.microservice.performance
```

### 3. Start the Agent
Launch the Gemini CLI with the specific model used for this test:

```bash
gemini-cli --model gemini-3-pro-preview
```

### 3. The Golden Prompt
Once the CLI is running, paste this exact prompt. This instructs the agent to read our "source of truth" files (`GEMINI.md`, etc.) and execute the plan.

> **"Please read and strictly follow all instructions and specifications outlined in the `GEMINI.md` file in the root directory, as well as the `bun/GEMINI.md` and `nodejs/GEMINI.md` files. These files contain the authoritative source of truth for the project's architecture, testing procedures, and deployment workflows."**

---

## 📂 Project Architecture & Specifications

We provided the AI with three key markdown files acting as the "brain" of the operation. Here is what they contain:

### 1. Root Orchestration (`GEMINI.md`)
This file tells the agent *how* to coordinate the project. It defines:
- **Benchmarking Strategy**: Using `wrk` to test 7 distinct scenarios, including health checks, database reads/writes, and raw CPU computation (Fibonacci).
- **Automation Scripts**: Instructions to generate `setup.sh`, `deploy_all.sh`, and `benchmark.sh`.
- **Remote Testing**: Procedures for deploying to Cloud Run and running benchmarks against live URLs.

### 2. Bun Service Specs (`bun/GEMINI.md`)
Specific instructions for the Bun microservice:
- **Native Power**: leverages `bun:sqlite` and Bun's native TypeScript support (no compilation step needed!).
- **Endpoints**:
    - `GET /contacts`: Pagination and DB reads.
    - `POST /contacts`: DB writes.
    - `/perf/*`: Raw performance endpoints (Text, JSON, Echo, Compute).
- **Infrastructure**: Optimized Dockerfile based on `oven/bun`.

### 3. Node.js Service Specs (`nodejs/GEMINI.md`)
Specific instructions for the Node.js microservice:
- **Modern Node**: Uses Node 22+ and `node:sqlite`.
- **Performance Focus**: Specifies Fastify over Express to give Node.js a fair fighting chance.
- **Infrastructure**: Multi-stage Docker build to keep the image light.

---

## 📊 Benchmarking Methodology

To ensure a fair fight, we test more than just "Hello World". The generated benchmark suite (`benchmark.sh`) covers:

1.  **Baseline**: `GET /health` (Framework overhead).
2.  **Read/Write**: `GET /contacts` & `POST /contacts` (Real-world DB usage).
3.  **Serialization**: `GET /perf/json` (JSON throughput).
4.  **CPU Bound**: `GET /perf/compute` (Recursive Fibonacci calculation).

The results are automatically saved to `results_node.txt` and `results_bun.txt` for easy comparison.

### ⚠️ Important Note on Benchmarking
For accurate and fair results:
- **Environment Isolation**: When running remote benchmarks, it is highly recommended to execute `wrk` from a separate virtual machine within the same VPC as the Cloud Run services to minimize network latency.
- **Instance Focus**: The provided deployment scripts configure Cloud Run to use **exactly one instance** (`min-instances: 1`, `max-instances: 1`). This ensures we are benchmarking the raw performance of the Node.js and Bun runtimes themselves, rather than Cloud Run's auto-scaling capabilities.

---

## 🔮 What to Expect

By running this experiment, you aren't just comparing Node.js and Bun. You are witnessing the future of software development where **human intent drives AI implementation**.

Will Bun's native speed crush Node.js? Will Node's mature ecosystem and recent optimizations (like `node:sqlite`) keep it competitive? 

**Clone the repo, run the prompt, and find out.**
