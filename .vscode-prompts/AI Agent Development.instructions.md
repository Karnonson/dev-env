---
description: "Use when the user wants to build an AI agent, discusses agent architecture, or creates an agent system. Defines what an AI agent is and provides guidelines for framework selection."
---

# AI Agent Development Guidelines

When the user wants to build an AI agent, adhere to the following definition and architectural guidelines.

## What is an AI Agent?
An AI agent is, at its core, a system equipped with:
- **A Brain**: A Large Language Model (LLM) for processing, reasoning, and decision-making.
- **Hands**: Tools that allow the agent to perform actions and interact with external systems or APIs.

## Framework Selection
- **Prefer Existing Frameworks**: Instead of building custom orchestration code from scratch, strongly prefer using an established AI agent framework when it fits the project's stack, operational constraints, and maintenance model.
- **User Confirmation Required**: The selection of a specific framework MUST be presented to and confirmed by the user before proceeding.
- **Stack Compatibility**: Ensure the recommended framework integrates smoothly with the project's existing technology stack, if applicable.

## Architecture Recommendations
When recommending a framework or architecture for the AI agent, you must account for:
1. **Budget (Cloud + API Costs)**: Explicitly ask the user about their budget to keep the app running (LLM usage, cloud hosting, and tooling API costs). Architecture choices must fit within this operational constraint.
2. **AI-Agent Usability**: How easily the chosen architecture and framework can be navigated, read, and maintained by AI coding agents.