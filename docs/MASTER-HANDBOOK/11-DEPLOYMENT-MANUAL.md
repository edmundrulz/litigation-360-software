# 11 Deployment Manual

## Purpose
Defines repeatable deployment steps for Litigation 360.

## Root Path
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

## Backend Start
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend
npm start

## Frontend Start
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend
npm run dev

## Frontend Build
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend
npm run build

## Deployment Rule
Every deployment requires backup, rollback, build verification, backend health verification, UI testing, and report creation.
