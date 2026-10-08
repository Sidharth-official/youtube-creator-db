# Digital Media & Creator Management System for YouTube

> **Course**: Database Management Systems (DBMS)
> **Mid-Semester Report Deadline**: 25 October 2025
> **Tool**: MySQL Workbench — EER Diagram & 3NF Normalized Schema

---

## Team

| Name | Enrollment |
|------|------------|
| Sidharth Gupta | — |
| Aditya Koul | — |
| Ahshan Khan | — |
| Aradhya Sharma | — |
| Daksh | — |

---

## Repository Structure

```
Project/
├── .gitignore                         # Excludes *.mwb.bak, *.tmp, .DS_Store, etc.
├── README.md                          # This file
├── schema_v1.sql                      # Canonical DDL for all 6 core entities
└── youtube_creator_management.mwb     # MySQL Workbench model (binary — see SOP below)
```

---

## Getting Started

Clone the repository and open the model directly in MySQL Workbench — no import or generation steps required.

```bash
git clone <repository-url>
cd Project
```

Then open `youtube_creator_management.mwb` in MySQL Workbench to view and edit the EER diagram.

---

## Schema Overview (3NF)

### Entities

| Entity | Description |
|--------|-------------|
| `Creator` | A content creator who may own one or more channels |
| `Channel` | A YouTube channel associated with a single Creator |
| `Video` | A video uploaded to a Channel |
| `Analytics` | Per-video performance metrics — views, likes, watch time, retention |
| `Brand` | An advertiser or sponsor |
| `Sponsorship` | Junction table resolving the many-to-many between Brand and Creator; optionally linked to a specific Video |

### Relationship Diagram

```
Creator ──< Channel ──< Video ──── Analytics (1-to-1)
   │
   └──< Sponsorship >── Brand
              └──> Video (optional)
```

### Normalization Notes

- **1NF**: All attributes are atomic; no repeating groups.
- **2NF**: Every non-key attribute depends on the full primary key of its table.
- **3NF**: No transitive dependencies. Video performance metrics are isolated in `Analytics` so that attributes of `Video` depend solely on `video_id`.
- `Sponsorship` eliminates the Brand ↔ Creator many-to-many with a clean associative entity.

---

## Commit Message Convention

Format: `type(scope): short description`

| Type | When to use |
|------|-------------|
| `feat` | New entity, relationship, or attribute |
| `fix` | Correcting a constraint, data type, or FK |
| `schema` | Changes to `schema_v1.sql` |
| `docs` | README, report, or documentation edits |
| `refactor` | Normalization or structural improvements |

**Examples**
```
feat(eer): add Sponsorship junction table with FK to Video
fix(schema): widen view_count column from INT to BIGINT
docs(readme): update normalization notes
```

---

## SOP — Coordinating Changes to `youtube_creator_management.mwb`

MySQL Workbench `.mwb` files are **ZIP-compressed XML binaries**. Git stores them as opaque blobs and cannot perform a line-level merge. If two people edit the file concurrently and both push, one set of changes will overwrite the other without warning. The following lightweight procedure keeps the file in a consistent state.

### Before You Start

**1. Signal your intent in the group chat.**
A short heads-up is all that is needed:
> *"Going to update the EER diagram — will push when done."*

**2. Pull the latest version.**
```bash
git pull origin main
```
Always work from the most recent commit. Editing a stale copy is the most common source of lost work.

---

### While Editing

**3. Open and edit in MySQL Workbench.**
- Open `youtube_creator_management.mwb`.
- Save regularly with `Cmd+S` / `Ctrl+S`.
- Workbench automatically creates `*.mwb.bak` backup files — these are excluded by `.gitignore` and should never be staged or committed.

---

### After You Finish

**4. Stage and commit only the model file.**
```bash
# Stage the model file — not the .bak
git add youtube_creator_management.mwb

# Write a descriptive commit message
git commit -m "feat(eer): add Analytics entity with FK to Video"

# Push to the shared branch
git push origin main
```

**5. Let the group know you have pushed.**
> *"Done and pushed — safe to pull."*

---

### Before Your Next Session

**6. Always pull before opening the file again**, even if you pushed recently.
```bash
git pull origin main
```

---

### Quick Checklist

**Before editing**
- [ ] Announced intent in group chat
- [ ] Ran `git pull origin main`
- [ ] Confirmed no one else has the file open

**After editing**
- [ ] Saved the file in Workbench
- [ ] Staged only `youtube_creator_management.mwb` (not `*.mwb.bak`)
- [ ] Committed with a clear, descriptive message
- [ ] Pushed to `origin main`
- [ ] Notified the group that it is safe to pull

---

*Last updated: October 2025*
