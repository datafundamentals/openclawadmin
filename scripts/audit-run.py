#!/usr/bin/env -S /Users/petecarapetyan/work/primary/openclawadmin/.venv/bin/python3
"""
SecurityCouncil Audit Pipeline
Runs the full audit: collect → sync → audit → report

Usage:
    python3 audit-run.py               # full automated pipeline (omits ports)
    python3 audit-run.py --skip-collect  # skip remote collection (manual mode)

    Manual mode workflow:
        1. ssh pete@<vm> and run ./collector/collect.sh
        2. Run this script with --skip-collect

Dependencies:
    pip install litellm python-dotenv

Configuration:
    Copy .env.example to .env and set ANTHROPIC_API_KEY and model strings.
"""

import os
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

from dotenv import load_dotenv
import litellm

# ── Paths ─────────────────────────────────────────────────────────────────────

REPO_DIR = Path(__file__).resolve().parent.parent
SCRIPTS_DIR = REPO_DIR / "scripts"
PROMPTS_DIR = REPO_DIR / "prompts"
ARTIFACTS_DIR = REPO_DIR / "vm_artifacts"
BASELINE_DIR = REPO_DIR / "vm_baseline" / "artifacts.baseline"
SECTIONS_DIR = REPO_DIR / "vm_reports" / "sections"
REPORTS_DIR = REPO_DIR / "vm_reports"

# ── Config ────────────────────────────────────────────────────────────────────

load_dotenv(REPO_DIR / ".env")

VM_USER = os.environ.get("VM_USER", "pete")
VM_IP   = os.environ.get("VM_IP",   "192.168.64.3")
VM_DIR  = os.environ.get("VM_DIR",  "/home/pete/openclawadmin")

MODELS = {
    "configuration": os.environ.get("AUDIT_MODEL_CONFIGURATION", "claude-sonnet-4-6"),
    "dependency":    os.environ.get("AUDIT_MODEL_DEPENDENCY",    "claude-sonnet-4-6"),
    "cost_usage":    os.environ.get("AUDIT_MODEL_COST_USAGE",    "claude-sonnet-4-6"),
    "exposure":      os.environ.get("AUDIT_MODEL_EXPOSURE",      "claude-sonnet-4-6"),
    "aggregator":    os.environ.get("AUDIT_MODEL_AGGREGATOR",    "claude-sonnet-4-6"),
}

# ── Helpers ───────────────────────────────────────────────────────────────────

def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def build_prompt(prompt_path: Path, files: dict[str, Path]) -> str:
    """Combine a prompt file with inlined artifact contents."""
    parts = [read(prompt_path), "\n---\nARTIFACT FILE CONTENTS:\n"]
    for label, path in files.items():
        parts.append(f"\n=== {label} ===\n")
        if path.exists():
            parts.append(read(path))
        else:
            parts.append(f"[FILE NOT FOUND: {path}]\n")
    return "".join(parts)


def call_llm(model: str, prompt: str) -> str:
    response = litellm.completion(
        model=model,
        messages=[{"role": "user", "content": prompt}],
    )
    return response.choices[0].message.content


def run(cmd: list[str]) -> None:
    result = subprocess.run(cmd, check=True)
    if result.returncode != 0:
        sys.exit(result.returncode)

# ── Pipeline steps ────────────────────────────────────────────────────────────

def step1_collect():
    print("Step 1: Running collector on VM...")
    run(["ssh", f"{VM_USER}@{VM_IP}",
         f"cd {VM_DIR} && ./collector/collect.sh"])


def step2_sync():
    print("Step 2: Pulling artifacts...")
    run([str(SCRIPTS_DIR / "sync-from-vm.sh")])


def step2b_validate():
    print("Step 2b: Validating artifacts...")
    run([str(SCRIPTS_DIR / "validate-artifacts.sh")])


def step2c_drift():
    print("Step 2c: Checking drift...")
    result = subprocess.run([str(SCRIPTS_DIR / "check-drift.sh")])
    if result.returncode == 2:
        print("Drift check error — aborting.", file=sys.stderr)
        sys.exit(2)
    # exit 0 (no drift) or 1 (drift detected) both continue to auditors


def step3_auditors() -> dict[str, str]:
    print("Step 3: Running auditors...")
    SECTIONS_DIR.mkdir(parents=True, exist_ok=True)

    auditors = {
        "configuration": {
            "prompt": PROMPTS_DIR / "configuration-auditor.txt",
            "files": {
                "vm_baseline/artifacts.baseline/config.json": BASELINE_DIR / "config.json",
                "vm_artifacts/config.json":                   ARTIFACTS_DIR / "config.json",
            },
        },
        "dependency": {
            "prompt": PROMPTS_DIR / "dependency-auditor.txt",
            "files": {
                "vm_baseline/artifacts.baseline/packages.txt": BASELINE_DIR / "packages.txt",
                "vm_artifacts/packages.txt":                   ARTIFACTS_DIR / "packages.txt",
            },
        },
        "cost_usage": {
            "prompt": PROMPTS_DIR / "cost-usage-auditor.txt",
            "files": {
                "vm_baseline/artifacts.baseline/usage.json": BASELINE_DIR / "usage.json",
                "vm_artifacts/usage.json":                   ARTIFACTS_DIR / "usage.json",
            },
        },
        "exposure": {
            "prompt": PROMPTS_DIR / "exposure-auditor.txt",
            "files": {
                "vm_baseline/artifacts.baseline/ports.txt":    BASELINE_DIR / "ports.txt",
                "vm_baseline/artifacts.baseline/firewall.txt": BASELINE_DIR / "firewall.txt",
                "vm_artifacts/ports.txt":                      ARTIFACTS_DIR / "ports.txt",
                "vm_artifacts/firewall.txt":                   ARTIFACTS_DIR / "firewall.txt",
            },
        },
    }

    outputs = {}
    for name, cfg in auditors.items():
        print(f"  Running {name} auditor...")
        prompt = build_prompt(cfg["prompt"], cfg["files"])
        output = call_llm(MODELS[name], prompt)
        out_path = SECTIONS_DIR / f"{name}.md"
        out_path.write_text(output, encoding="utf-8")
        outputs[name] = output

    return outputs


def step4_aggregator(sections: dict[str, str]) -> Path:
    print("Step 4: Running report aggregator...")

    section_labels = {
        "configuration": "Section 4.1 Configuration Auditor",
        "dependency":    "Section 4.2 Dependency Auditor",
        "cost_usage":    "Section 4.3 Cost & Usage Auditor",
        "exposure":      "Section 4.4 Exposure Auditor",
    }

    parts = [
        read(PROMPTS_DIR / "report-aggregator.txt"),
        "\n---\nAUDITOR SECTION OUTPUTS:\n",
    ]
    for key, label in section_labels.items():
        parts.append(f"\n=== {label} ===\n{sections[key]}\n")

    parts.append(f"\n=== vm_artifacts/metadata.json ===\n")
    parts.append(read(ARTIFACTS_DIR / "metadata.json"))

    prompt = "".join(parts)
    report = call_llm(MODELS["aggregator"], prompt)

    timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H-%M-%SZ")
    report_path = REPORTS_DIR / f"security-council-report-{timestamp}.md"
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    report_path.write_text(report, encoding="utf-8")

    return report_path


def step5_summary(report_path: Path) -> None:
    print("Audit completed")
    print(f"Report written to {report_path.relative_to(REPO_DIR)}")

# ── Entry point ───────────────────────────────────────────────────────────────

def main():
    skip_collect = "--skip-collect" in sys.argv
    os.chdir(REPO_DIR)
    if not skip_collect:
        step1_collect()
    else:
        print("Step 1: Skipping remote collection (--skip-collect)")
    step2_sync()
    step2b_validate()
    step2c_drift()
    sections = step3_auditors()
    report_path = step4_aggregator(sections)
    step5_summary(report_path)


if __name__ == "__main__":
    main()
