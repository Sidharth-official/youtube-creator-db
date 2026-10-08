# Digital Media & Creator Management System for YouTube

> **Course**: Database Management Systems (DBMS)  
> **Mid-Semester Report Deadline**: 25 October 2025  
> **Tool**: MySQL Workbench (EER Diagram + 3NF Normalized Schema)

---

## 📁 Repository Structure

```
Project/
├── .gitignore                        # Ignores *.mwb.bak, *.tmp, .DS_Store, etc.
├── README.md                         # This file
├── schema_v1.sql                     # Canonical DDL — import into Workbench to
│                                     # auto-generate the EER diagram
└── youtube_creator_management.mwb    # MySQL Workbench model file (binary)
                                      # ⚠️  Only ONE person edits this at a time
```

---

## 🗄️ Core Entities (3NF Schema)

| Entity | Description |
|--------|-------------|
| `Creator` | A content creator; owns one or more channels |
| `Channel` | A YouTube channel belonging to a Creator |
| `Video` | A video uploaded to a Channel |
| `Analytics` | Per-video performance metrics (views, likes, watch time) |
| `Brand` | An advertiser / sponsor company |
| `Sponsorship` | Many-to-many link between Brand and Creator; optionally tied to a Video |

### Entity-Relationship Summary

```
Creator ──< Channel ──< Video ──── Analytics
                                      │
Sponsorship >── Creator               │
Sponsorship >── Brand                 │
Sponsorship ──> Video (optional) ─────┘
```

---

## ⚠️ SOP: Editing the `.mwb` File (MANDATORY — Read Before Touching It)

MySQL Workbench `.mwb` files are **ZIP-compressed XML binaries**. Git cannot perform a line-level merge on them. If two people edit the file simultaneously and both push, **one person's work will be silently overwritten**. Follow this procedure every single time.

### Step-by-Step Workflow

#### 1. Announce in the group chat
Post a message before you start:
> "I'm picking up the `.mwb` file — please don't edit until I push."

#### 2. Pull the absolute latest version
```bash
git pull origin main
```
> Never skip this step. Editing a stale copy is the #1 cause of conflicts.

#### 3. Open and edit in MySQL Workbench
- Launch `youtube_creator_management.mwb` in MySQL Workbench.
- Make your changes (add tables, relationships, notes, etc.).
- **Save frequently** with `Cmd+S` / `Ctrl+S`.  
  Workbench auto-creates `*.mwb.bak` backups — these are ignored by `.gitignore` and should **never** be committed.

#### 4. Stage, commit, and push immediately when done
```bash
# Stage only the model file (never commit *.mwb.bak)
git add youtube_creator_management.mwb

# Write a clear, descriptive commit message
git commit -m "feat(eer): add Sponsorship entity and FK to Video"

# Push to the shared branch
git push origin main
```

#### 5. Announce completion in the group chat
> "Done — pushed. Safe to pull."

#### 6. Everyone else pulls before their turn
```bash
git pull origin main
```

---

### ✅ Quick Reference Checklist

Before editing `.mwb`:
- [ ] Announced in group chat
- [ ] Ran `git pull origin main`
- [ ] Confirmed no one else is currently editing

After editing `.mwb`:
- [ ] Saved the file in Workbench
- [ ] Staged **only** `*.mwb` (not `*.mwb.bak`)
- [ ] Committed with a meaningful message
- [ ] Pushed to `origin main`
- [ ] Announced "done" in group chat

---

## 🚀 Getting Started (First-Time Setup)

### Import SQL to auto-generate the EER Diagram

1. Open **MySQL Workbench**.
2. Go to **Database → Reverse Engineer…**
3. Connect to your local MySQL server.
4. Alternatively, use **Server → Data Import** to run `schema_v1.sql`, then use **Database → Reverse Engineer** on the `youtube_creator_management` database.
5. Save the generated diagram as `youtube_creator_management.mwb` in the project root.
6. Commit and push the `.mwb` file following the SOP above.

### Clone the repo (for teammates)
```bash
git clone <repository-url>
cd Project
```

---

## 📌 Commit Message Convention

Use the format: `type(scope): short description`

| Type | Use for |
|------|---------|
| `feat` | Adding a new entity / relationship |
| `fix` | Correcting a constraint or data type |
| `docs` | README or report changes |
| `schema` | Changes to `schema_v1.sql` |
| `refactor` | Normalization improvements |

**Examples:**
```
feat(eer): add Analytics entity with FK to Video
fix(schema): change view_count from INT to BIGINT
docs(readme): update team roles
```

---

## 📋 Normalization Notes (3NF Compliance)

- All non-key attributes depend **only** on the primary key (2NF ✓).
- No transitive dependencies exist — metrics are split into `Analytics` so that `Video` attributes depend only on `video_id` (3NF ✓).
- The `Sponsorship` table resolves the many-to-many between `Brand` and `Creator` using a composite context (brand + creator + optional video).

---

*Last updated: October 2025*
