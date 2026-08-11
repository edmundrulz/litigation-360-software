"use strict";

module.exports = {
  root: true,
  env: {
    node: true,
    jest: true,
    es2021: true,
  },
  extends: ["eslint:recommended"],
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "script",
  },
  ignorePatterns: [
    "node_modules/",
    "coverage/",
  ],
  rules: {
    "no-console": "off",
  },
};