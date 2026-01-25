---
layout: post
title: "Building an Ultrafast C++ Microservice for Google Cloud Run: A Case Study in Extreme Performance"
description: "Learn how to build a high-performance C++ microservice for Google Cloud Run using a Pgpool-II sidecar, thread-local connections, and multi-level caching to achieve sub-millisecond API latency."
date: 2026-01-24
image: "/assets/img/ultrafast.png"
tags: [cloud, google cloud, gcp, backend, development, nodejs, bun,builtwithai, gde, google developer expert,golang, gcp, security, cloud-run, cloud-sql, devops, advanced]
---

# Building an Ultrafast C++ Microservice for Google Cloud Run: A Case Study in Extreme Performance

*Originally posted on nja.dev - High Performance Software Engineering*

**Summary:** Learn how to build a high-performance C++ microservice for Google Cloud Run using a Pgpool-II sidecar, thread-local connections, and multi-level caching to achieve sub-millisecond API latency.
The build process is done in a docker, so no need to install everything on your local environment, the docker will do that.

---

## Introduction: Optimizing Serverless Performance

When I talk about **serverless microservices**, the standard "go-to" languages are usually Node.js, Python, or Go. But what happens when you need to squeeze every single microsecond of performance out of your infrastructure? What if your relational database is the bottleneck, not because of the query complexity, but because of the massive connection overhead inherent in serverless scaling?

In this comprehensive case study, I’ll walk you through how I architected and built an **"Ultrafast" C++ Microservice** designed specifically for **Google Cloud Run**. By combining the raw, deterministic power of **C++17** with a local **Pgpool-II sidecar** pattern and a sophisticated **two-tier caching strategy** (Local RAM + Redis), I achieved consistent sub-millisecond latencies and high-throughput reliability under heavy load.

**[👉 View the full source code on GitHub](https://github.com/nuno-joao-andrade-dev/advanced.ultrafast.cpp.microservice)**  
**[📚 Read the technical documentation](https://github.com/nuno-joao-andrade-dev/advanced.ultrafast.cpp.microservice/blob/main/doc/README.md)**

---

## The Challenge: The Serverless DB Connection Tax

Google Cloud Run is an incredible platform for auto-scaling containers, but it presents a unique performance challenge for traditional relational databases like **PostgreSQL** (Cloud SQL).

### The Anatomy of Latency
Every time a serverless container scales from zero or handles a new concurrent request, it typically needs to establish a TCP (and often SSL/TLS) connection to the database.
*   **Latency Cost:** A new secure Postgres connection can take anywhere from **100ms to 500ms**. This "cold start" penalty is unacceptable for real-time applications.
*   **Connection Exhaustion:** Scaling to 100+ containers can instantly exhaust the database's `max_connections` limit, causing cascading failures.

---

## The Solution: Architecture & The Sidecar Pattern

To solve the "connection tax," I didn't just write a C++ application; I engineered a **coordinated runtime environment** inside my Docker container.

### 1. The Pgpool-II Sidecar Strategy
I packaged **Pgpool-II** directly inside the same Docker image as the C++ binary.
- **Mechanism:** When the container starts, the entrypoint script launches Pgpool in the background. Pgpool immediately establishes a small, warm pool of persistent connections to the remote Cloud SQL instance.
- **Benefit:** The C++ application connects to `localhost:5432`. Since this traffic stays on the local loopback interface (or Unix socket), the "connection" cost is effectively **zero microseconds**. The expensive physical connection to the remote DB remains open and is efficiently reused across thousands of HTTP requests.

### 2. The High-Performance C++ Tech Stack
I skipped heavy web frameworks (like Django or Spring) and went straight to the metal for maximum efficiency:
*   **Networking:** `cpp-httplib` - A header-only, multi-threaded C++ HTTP server optimized for blocking I/O models.
*   **Database Client:** Native `libpq` - The official C library for Postgres. No ORM overhead.
*   **JSON Processing:** `RapidJSON` - One of the world's fastest C++ JSON parsers, utilizing in-situ memory manipulation to avoid allocation costs.

---

## Engineering Deep Dive: How to Achieve "Ultrafast"

### Thread-Local Connection Persistence
Creating a new database object per request is a standard pattern, but it's wasteful. I utilized C++ **`thread_local`** storage duration.

```cpp
// One connection per thread, reused indefinitely
thread_local std::unique_ptr<Database> t_db;
```

**Why this matters for performance:**
Each worker thread in the HTTP server's thread pool maintains its own private, persistent connection to the local Pgpool instance. This eliminates **100% of syscalls** related to connection management during the request lifecycle.

### Zero-Copy JSON & GZIP Compression
To handle large API payloads without choking the CPU or bandwidth:
1.  **In-situ Parsing:** I used RapidJSON to parse request bodies directly in their original input buffer. This prevents unnecessary memory copies (`malloc`/`free`), which are expensive at scale.
2.  **GZIP Compression:** I implemented support for `Accept-Encoding: gzip`. While this costs CPU cycles, it reduces network transfer time by up to **90%** for large JSON datasets, effectively increasing the perceived speed for mobile clients on varying networks.

---

## The Performance Multiplier: Two-Layer Caching

The fastest database query is the one you never make. My microservice implements an aggressive two-layer caching strategy:

### Level 1: Local In-Memory Cache (RAM)
*   **Implementation:** A thread-safe LRU (Least Recently Used) cache using `std::unordered_map` and `std::list`.
*   **Latency:** **~10-50 microseconds**.
*   **Use Case:** Serving "hot" data that is requested frequently by the same container instance.

### Level 2: Distributed Redis Cache
*   **Implementation:** A sidecar **Redis** instance (or Google Cloud Memorystore).
*   **Latency:** **~1-3 milliseconds**.
*   **Benefit:** Persistence. If a container crashes or restarts, the "warm" data remains available in Redis for other instances, preventing a "thundering herd" of requests to the primary database.

---

## Benchmark Results

I stress-tested the service using `hey`, simulating 100 concurrent users performing complex product search queries. The results speak for themselves.

| Scenario | Average Latency | Throughput (RPS) | Notes |
| :--- | :--- | :--- | :--- |
| **Cold DB Hit** | 45ms | ~250 | Standard performance. |
| **L2 (Redis) Hit** | 2.5ms | ~650 | Excellent persistence. |
| **L1 (Local RAM) Hit** | **0.4ms** | **~670+** | **Limited only by CPU**. |

*Note: In the L1 hit scenario, the bottleneck shifts entirely from I/O to the speed of JSON serialization.*

---

## Conclusion: Why C++ in Serverless Matters

This project proves that C++ isn't just for embedded systems, high-frequency trading, or game engines. In a modern serverless cloud environment where you pay per millisecond of CPU time, a highly optimized C++ microservice can:

1.  **Slash Cloud Costs:** By completing requests 10x-50x faster than interpreted languages, you drastically reduce billable compute time.
2.  **Enhance UX:** Provide "instant" API responses that delight users.
3.  **Resilience:** Protect your critical database infrastructure from connection storms and exhaustion.

If you’re interested in the full source code, Docker configurations, or the Pgpool tuning parameters, check out the repository on my GitHub.

**Keep it fast. Keep it lean.**

---
*Tags: C++, Microservices, Google Cloud Run, PostgreSQL, Pgpool-II, Redis, Performance Optimization, Serverless, Docker, High Performance Computing.*
