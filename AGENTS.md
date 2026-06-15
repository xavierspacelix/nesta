---

description: Instructions for building Nesta mobile application
globs: *
alwaysApply: true
-----------------

# Nesta Development Agent

This project follows a documentation-first and UI-first development workflow.

Before writing any code, always read the project context files and understand the current build state.

---

# Read Before Anything Else

Read these files in this exact order before implementing any feature:

1. context/project-overview.md
2. context/architecture.md
3. context/ui-tokens.md
4. context/ui-rules.md
5. context/code-standards.md
6. context/library-docs.md
7. context/build-plan.md
8. context/progress-tracker.md

Never skip this sequence.

---

# Core Development Workflow

Every feature follows the same lifecycle:

1. Design UI with mock data
2. Review UI
3. Connect Supabase data
4. Add business logic
5. Add notifications
6. Test manually
7. Update documentation

No backend integration before UI approval.

No feature is complete until it is testable.

---

# Project Overview

Nesta is a mobile application for managing house chores, schedules, fines, activity feeds, and shared house finances.

Users belong to a house and collaborate to maintain shared spaces through a structured daily chore system.

Core features:

* Daily chore assignment
* Room-based checklist system
* Before & after photo evidence
* Fine management
* Schedule swap approval
* Activity feed
* Rent tracking
* Electricity tracking
* Water gallon purchasing schedule
* Push notifications

---

# Technology Stack

Frontend

* Flutter
* Material 3
* Riverpod
* Go Router
* Freezed
* Json Serializable

Backend

* Supabase
* Supabase Auth
* Supabase Database
* Supabase Storage
* Supabase Realtime

Notifications

* Firebase Cloud Messaging

Analytics

* Firebase Analytics

---

# Rules That Never Change

## Architecture

* Serverless only
* No custom backend
* No Express
* No Laravel
* No NestJS
* No VPS required

All business logic must run through:

* Flutter
* Supabase
* Firebase

---

## State Management

Use Riverpod only.

Never introduce:

* Provider
* Bloc
* GetX
* MobX

---

## Navigation

Use Go Router only.

Never use Navigator.push directly unless absolutely required.

---

## Models

Use:

* Freezed
* Json Serializable

Every database entity must have:

* DTO
* Freezed model
* Mapper if needed

---

## Database

Supabase is the single source of truth.

Never duplicate state unnecessarily.

All writes must go through repositories.

---

## Storage

Task evidence photos stored in Supabase Storage.

Folder structure:

task-evidence/
├── before/
└── after/

Never store images locally beyond temporary cache.

---

## Authentication

Supported methods:

* Google Sign In
* Email & Password

Every user belongs to exactly one house.

---

## Notifications

Firebase Cloud Messaging only.

Notification categories:

* Duty reminder
* Due soon reminder
* Missed duty
* Swap request
* Swap approval
* Payment reminder

---

# UI Rules

Always follow:

* context/ui-rules.md
* context/ui-tokens.md

These files are the source of truth.

Never invent colors or spacing.

---

# Build Rules

Always follow build-plan.md.

Build phases sequentially.

Never start a future phase before the current phase is completed.

Example:

If Phase 1 is incomplete:

* Do not build Dashboard
* Do not build Chore Management
* Do not build Analytics

---

# Progress Tracking

After every completed feature:

Update:

* progress-tracker.md

Required updates:

* Current Status
* Last Completed
* Next Feature

Also update completed checkboxes.

---

# Documentation First

Before implementing:

1. Verify feature exists in project-overview.md
2. Verify data model exists in architecture.md
3. Verify feature belongs to current build phase

If not found:

Stop and ask for clarification.

Never invent requirements.

---

# Available Commands

## /architect

Use before:

* Database changes
* Complex features
* New business logic

Think first.

Design before coding.

---

## /review

Use when:

* Feature is finished
* UI is completed
* Before moving to next phase

---

## /recover

Use when:

* A bug remains after one corrective attempt
* State becomes inconsistent
* Architecture drift occurs

---

## /remember save

Use when:

* Feature spans multiple sessions

---

## /remember restore

Use when:

* Continuing unfinished work

---

# Supabase Rules

Before writing Supabase code:

Read:

* context/library-docs.md

Follow repository pattern.

Never access Supabase directly from UI widgets.

Allowed flow:

Screen
→ Controller
→ Repository
→ Supabase

---

# Firebase Rules

Before writing notification logic:

Read:

* context/library-docs.md

Notification sending must be isolated.

Never place notification code inside UI widgets.

---

# Error Handling

Never expose raw errors.

Show human-readable messages.

Example:

Bad:

"PostgrestException: duplicate key value violates..."

Good:

"This room already exists."

---

# Code Quality

Prefer:

* Simple code
* Readable code
* Explicit naming

Avoid:

* Clever abstractions
* Premature optimization
* Unnecessary packages

A junior Flutter developer should understand every file.

---

# MVP Scope

Only these features are required for first release:

* Authentication
* Create / Join House
* Dashboard
* Room Management
* Daily Schedule
* Task Evidence
* Fine Calculation
* Activity Feed
* Schedule Swap
* Push Notifications

Everything else is Phase 2.

Do not expand scope without updating project documentation.

---

# Final Rule

If documentation conflicts with implementation:

Documentation wins.

Update code to match documentation.

Never update implementation assumptions without updating documentation first.
