# GIT BRANCHING PROTOCOL

Protected branches:

main
- Stable production-ready code only.

develop
- Active tested integration branch.

feature/*
- New features.

bugfix/*
- Normal bug fixes.

hotfix/*
- Emergency production fixes.

security/*
- Security patches.

release/*
- Final release preparation.

## Standard Feature Workflow

git checkout develop
git pull
git checkout -b feature/name-of-feature

After coding:

git status
git add .
git commit -m "Add name of feature"
git push origin feature/name-of-feature

Never commit directly into main.
