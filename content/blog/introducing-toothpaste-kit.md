+++
title = "Introducing Toothpaste Kit"
date = "2026-10-08"
description = "What Toothpaste Kit is, and the principles it is built on."
tags = ["toothpaste-kit", "agents", "verification"]
+++

# Introducing Toothpaste Kit

[Toothpaste Kit](https://github.com/AN0099/toothpaste-kit) is the first Bridle
Works project. It is a skill library, an agent relay protocol, and a set of
mechanical gates for running multi-agent work with a person in charge of it.

## The premise

An AI-integrated system works best with someone who understands the job
standing next to it. Hand an agent a goal and walk away, and you get confident
output with nobody accountable for whether it is true. The leverage comes from
an operator who knows the domain, sets the constraints, and checks the result.
The kit is built to make that person faster, not to replace them.

## Three rules about verification

These hold for every agent and every person working on the project:

1. **A completion claim is not a fact until someone other than the claimant
   checks it.** An agent reporting success is reporting an intention.
2. **Self-audit is not verification.** An agent explaining its own error
   produces a narrative about the error, and the narrative is often wrong in
   ways that sound convincing.
3. **Findings get raised.** A disagreement settled quietly by whoever noticed
   it first is a decision that skipped review.

Each one was written after a specific failure, and the failures are kept as
postmortems.

## What is in it

- **Skills** an agent loads on its own: writing standards, working
  preferences, and how to add a skill.
- **Procedures only a person can start**, such as closing a session or opening
  a working day. An agent cannot trigger them, because a gate a model can
  invoke to satisfy itself is not a gate.
- **Mechanical gates**, scripts that check what can be checked, each tested
  against a planted failure so a clean result means something.

Accessibility is a requirement rather than an afterthought: the documents are
written against WCAG techniques for Markdown, and a linter enforces the
checkable half.

## Status

Pre-alpha. The skills are in daily use and the interfaces still change. It is
MIT licensed, and every release is archived with a DOI. The
[README](https://github.com/AN0099/toothpaste-kit#readme) is the place to start,
and [the philosophy document](https://github.com/AN0099/toothpaste-kit/blob/main/philosophy.md)
has the reasoning.
