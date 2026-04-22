# Common Workflows

Use these flows when you want the shortest path through the most common kite operations.

## Bootstrap An Existing Repository

Install assets on the host, then finish the workflow inside the container:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- .
kite doctor .
kite install speckit .
kite status .
```

Use this flow when you want the workspace files first and the bundled Spec Kit workflow after the container is ready.

## Refresh From A Local kite Checkout

Compare a target repository against a local clone of this repository:

```bash
kite doctor --source-dir /path/to/kite .
kite update workspace --source-dir /path/to/kite --dry-run .
kite update workspace --source-dir /path/to/kite --merge .
```

This is the safest path when you are iterating on kite itself and want to test the current checkout instead of downloading from GitHub.

## Run Pre-Merge Verification

Use the feature status screen, then run the guards that block merge-readiness:

```bash
kite feature .
kite test --profile full .
kite audit .
kite verify feature .
```

`kite verify feature` checks branch cleanliness, merge conflicts, and active Speckit task completion. The extra `test` and `audit` steps are useful when you want the same verification profile that `kite release prepare` uses.

## Prepare And Publish A Release

Run release preparation on the feature branch:

```bash
kite release prepare --bump minor .
```

After the feature branch merges to the default branch, publish the release:

```bash
kite release publish --bump minor --confirm .
```

Omit `--confirm` or add `--dry-run` when you want a preview instead of writing version, changelog, commit, and tag changes.

## Explain The Speckit Stage To The Team

Use `kite explain` when you need a plain-language explanation of the current lifecycle step:

```bash
kite explain plan
kite explain test
```

This is useful for onboarding or for non-technical collaborators who need the intent of a stage without opening the underlying prompt or workflow files.
