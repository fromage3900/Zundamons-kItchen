# TODO - Zundamon's kItchen (GitHub Build) Bootstrap

## Step 0: Decision (chosen)
- [x] Use **text-friendly** Roblox exports for GitHub builds: rbxlx/rbxmx + code-as-text (diffable)

## Step 1: Repository scaffolding
- [x] Create repo directory structure plan
- [x] Add root docs (`README.md`, `CONTRIBUTING.md`)
- [x] Add `.github/` templates and CI workflow

## Step 2: Roblox source export readiness
- [ ] Create `source/` folder and document expected export mapping
- [ ] Add `.gitignore` rules to ignore `workspace/` outputs (done)

## Step 3: Cooperative dev hygiene
- [x] Add PR checklist in `.github/pull_request_template.md`
- [x] Add coding + architecture review checklist (`docs/review-checklist.md`)
- [x] Add patch notes template
- [x] Add style guide (`docs/style-guide.md`)

## Step 4: “clean commit when ready”
- [ ] Ensure scaffold is committed as the first commit
- [ ] Provide exact git commands to run locally

## Step 5: First export + first comprehensive review
- [ ] Export current experience from Studio into `source/`
- [ ] Commit exports
- [ ] Perform a comprehensive code/architecture review using `docs/review-checklist.md`

