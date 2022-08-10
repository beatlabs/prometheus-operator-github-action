# Prometheus Operator GitHub Action

## Introduction
This simple GitHub Action allows to run [po-lint](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/linting.md) on kubernetes [prometheus operator](https://github.com/prometheus-operator/prometheus-operator) CRDs.

## Usage
```yaml
name: Check PrometheusRule CRDs
on:
  pull_request:

jobs:
  polint:
    name: Prometheus operator lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: beatlabs/prometheus-operator-github-action@v1
        with:
          path: './rules'
          exclude: '.*test.*'
```
