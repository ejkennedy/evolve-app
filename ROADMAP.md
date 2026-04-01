# Evolve – Roadmap & Checklist

> **Stack:** Flutter 3.41 · Dart 3.11 · Riverpod 2 · GoRouter · Hive · Supabase Auth · OpenAI GPT-4o · Material 3

---

## Phase 1 — Foundation & Core Flows ✅

> Goal: a working app on macOS and iOS with auth, onboarding, and the main tab shell.

### Infrastructure
- [x] Flutter project scaffolded with feature-first architecture (`lib/features/`, `lib/core/`)
- [x] `pubspec.yaml` with all dependencies (Riverpod, GoRouter, Hive, Dio, Supabase, Freezed, fl_chart, etc.)
- [x] `flutter_dotenv` for runtime `.env` config (no build step)
- [x] `HiveConfig` — opens all boxes (`user`, `goals`, `habits`, `habit_logs`, `chat_messages`, `settings`)
- [x] `HiveJsonBox<T>` wrapper — JSON-string storage, no hive_generator type adapters needed
- [x] `DioClient` — OpenAI base URL + `Authorization: Bearer` header
- [x] Material 3 theme (light + dark) with custom colour palette and typography
- [x] macOS sandbox entitlements for outbound network access
- [x] GitHub repo pushed (`ejkennedy/evolve-app`) with meaningful commit history

### Auth
- [x] Supabase initialised in `main.dart`
- [x] `AuthStatus` model (`isAuthenticated`, `isOnboarded`, `user`)
- [x] `authStateProvider` — `StreamProvider` backed by `supabase.auth.onAuthStateChange`
- [x] `authNotifierProvider` — `signIn`, `signUp`, `signOut`, `saveUser`
- [x] Login screen (email + password)
- [x] Sign-up screen (name + email + password)
- [x] Splash screen with 3-second fallback to login if stream is slow

### Navigation
- [x] `GoRouter` with auth guard + onboarding guard + `ShellRoute` (5 tabs)
- [x] Route constants (`/`, `/login`, `/signup`, `/onboarding`, `/dashboard`, `/goals`, `/habits`, `/coach`, `/insights`, `/settings`, `/log`)
- [x] `onboardingCompleteProvider` override so router sees `isOnboarded=true` immediately after save (fixes post-onboarding navigation hang)

### Onboarding
- [x] 6-question conversational onboarding chat UI
- [x] Captures: name, main goal, existing habit, peak energy time, motivation style, main obstacle
- [x] Saves `AppUser` with `onboardingComplete: true` to Hive on completion
- [x] Navigates to dashboard after "Let's go!"

---

## Phase 2 — Goals & Habits ✅ / 🚧

> Goal: users can create, track, and log progress against goals and habits.

### Goals
- [x] `Goal` model (Freezed + json_serializable) — title, description, category, targetValue, currentValue, unit, targetDate, status
- [x] `GoalRepository` — CRUD via Hive
- [x] `goalsProvider` (`StateNotifierProvider`) — `createGoal`, `updateGoal`, `deleteGoal`, `logProgress`
- [x] Goals list screen
- [x] Create goal screen (title, description, category chips, target + unit, date picker)
- [x] Goal detail screen
- [ ] Progress bar / ring visualisation on goal detail
- [ ] Edit goal screen
- [ ] Goal completion celebration (confetti / animation)
- [ ] Archive completed goals

### Habits
- [x] `Habit` model (Freezed) — title, description, frequency, targetDays, icon, colour
- [x] `HabitLog` model (Freezed) — habitId, completedAt, note
- [x] `HabitRepository` — CRUD + log via Hive
- [x] `habitsProvider` — `createHabit`, `deleteHabit`, `logHabit`, streak calculation
- [x] Habits list screen with today's completion state
- [x] Create habit screen
- [x] Habit detail screen
- [ ] Habit streak calendar (GitHub-style heatmap)
- [ ] Edit habit screen
- [ ] Habit reminders via `flutter_local_notifications`

### Quick Log
- [x] `QuickLogSheet` modal bottom sheet (route `/log`)
- [ ] Wire up to actually log a habit or goal progress from the sheet
- [ ] Smart suggestions (show today's incomplete habits)

---

## Phase 3 — AI Coach 🚧

> Goal: a streaming GPT-4o coach that knows the user's goals and habits.

- [x] `ChatMessage` model (Freezed) — id, role, content, sessionId, isStreaming, createdAt
- [x] `CoachRepository` — OpenAI `/chat/completions` SSE streaming, parses `choices[0].delta.content`
- [x] `buildSystemPrompt` — injects user name, goals, habits, motivation style from onboarding
- [x] `CoachNotifier` — manages message list, streaming state, persists to Hive
- [x] Coach chat screen with streaming bubble UI
- [ ] "Improve with AI" on create goal screen (currently shows snackbar placeholder)
- [ ] Daily check-in prompt — coach proactively asks about progress
- [ ] Coach aware of habit streaks and goal deadlines (pull from providers in system prompt)
- [ ] Message history pagination (currently loads all; cap at last 50)
- [ ] Clear conversation / new session button

---

## Phase 4 — Dashboard & Insights 🚧

> Goal: a rich home screen and an insights tab backed by real data.

### Dashboard
- [x] Dashboard screen scaffold
- [ ] Today's habits widget (tap to complete inline)
- [ ] Active goals summary card
- [ ] Streak counter widget
- [ ] Coach greeting card (personalised based on time of day + onboarding data)
- [ ] Quick-add FAB

### Insights
- [x] Insights screen scaffold
- [ ] Weekly habit completion chart (`fl_chart` bar chart)
- [ ] Goal progress over time line chart
- [ ] Streak leaderboard (personal bests)
- [ ] AI-generated weekly summary (call coach endpoint on demand)

---

## Phase 5 — Polish & Notifications 📋

> Goal: production-quality feel, push notifications, and app store readiness.

- [ ] `flutter_local_notifications` — daily habit reminder at user's peak energy time
- [ ] Onboarding revisit / edit answers in Settings
- [ ] App icon + launch screen (replace placeholder)
- [ ] Dark / light mode toggle in Settings
- [ ] Haptic feedback on habit completion
- [ ] Empty states for goals, habits, coach (illustrated)
- [ ] Error states with retry actions
- [ ] Accessibility audit (semantics labels, contrast)
- [ ] Performance: `const` widget audit, list `RepaintBoundary`
- [ ] Widget tests for critical flows (auth, onboarding, habit log)
- [ ] Golden tests for key screens

---

## Phase 6 — Backend Sync (Cloudflare) 📋

> Goal: sync data across devices, replace Hive-only storage with a proper backend.

- [ ] Cloudflare D1 database schema (users, goals, habits, habit_logs, coach_sessions)
- [ ] Hono API on Cloudflare Workers — REST endpoints for CRUD + auth middleware
- [ ] Sync layer: write to Hive first (optimistic), then sync to D1 in background
- [ ] Conflict resolution strategy (last-write-wins with `updatedAt` timestamps)
- [ ] Cloudflare R2 for any future file uploads (e.g. profile photo)
- [ ] Migrate Supabase auth JWT to Cloudflare Workers auth validation
- [ ] Offline-first indicator in UI when sync is pending

---

## Phase 7 — App Store Launch 📋

> Goal: ship to TestFlight and the App Store.

- [ ] Privacy policy + terms of service pages
- [ ] App Store Connect — app record, screenshots, description
- [ ] TestFlight build (release mode, signed)
- [ ] iOS entitlements review (notifications, network)
- [ ] Crashlytics or Sentry integration
- [ ] Rate-limit handling for OpenAI API (retry with backoff + user-facing message)
- [ ] Production `.env` with real keys (never committed)
- [ ] macOS App Store build (optional stretch goal)
