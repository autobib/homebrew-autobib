# How to bump a formula

Updating a formula to a new upstream release involves three steps: changing the formula text, building and testing bottles, and releasing the bottles.

## Opening a PR with formula change

There are three ways to do this:

1. _(Recommended)_ Trigger the `formula-bump` workflow on this repo (write access required).
2. Run `brew bump-formula-pr` with appropriate command-line options within a local clone of the tap.
3. Edit the relevant formula, updating the top-level `url` and `sha256` fields to reflect the new upstream release.
    Then open a pull request (fork the repo if necessary).

If using option 1, the resulting PR will have the `auto-pull` label applied to it automatically.
This label is intended for simple formula bumps like this and can be applied manually if using option 2 or 3.
It only has an effect if the PR is not from a fork and the name of the source branch matches the glob pattern `bump-*`.

Bottling and testing will start automatically on the new PR through the `tests` workflow.

### The `formula-bump` workflow

Two inputs are required:

- `formula` — the formula name (e.g. `autobib`).
- `version` — the new upstream version (e.g. `0.6.1`)

To run the `formula-bump` workflow, use the [web UI](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/manually-run-a-workflow) or GitHub CLI, like the following:

```sh
gh workflow run formula-bump.yml -f formula=autobib -f version=0.6.1
```

If using the web UI, make sure you run the workflow on the `main` branch.

The workflow runs `brew bump-formula-pr` with the supplied inputs, which edits the formula and opens a PR.
It also applies the `auto-pull` label to the PR automatically.

It uses a personal access token owned by @autobib-brew-bot, instead of the default `GITHUB_TOKEN`.
This is because actions taken by the default token would not trigger the `tests` workflow.

## Bottling

This runs automatically on every push inside the PR.
It runs `brew test-bot` on each of the three most recent macOS editions, and on Linux.
The bottles built are uploaded as artifacts.

## Releasing the bottles

The release stage is triggered by applying the `pr-pull` label to the PR (Triage role or higher required) after the `tests` workflow has successfully completed.
In most cases, this will be done automatically by the `auto-pull` workflow.

### The `auto-pull` workflow

The `auto-pull` workflow is run upon the completion of the `tests` workflow, if all of the following conditions are met:

- the name of the source branch is of the form `bump-*`;
- the source branch is on this repo (_i.e._ not a fork);
- the completed run of the `tests` workflow was triggered by a [pull request event](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#pull_request);
- the PR is open;
- the PR has the `auto-pull` label.

If the triggering run of the `tests` workflow has a [conclusion](https://docs.github.com/en/rest/guides/using-the-rest-api-to-interact-with-checks#about-check-runs) of `success`, `skipped`, or `neutral`, and the PR is in a `CLEAN` [merge state](https://docs.github.com/en/graphql/reference/pulls#enum-mergestatestatus), then the `auto-pull` label is replaced with the `pr-pull` label.

If the triggering run of the `tests` workflow has a conclusion that isn't listed above, then the `auto-pull` label is removed from the PR.

Otherwise, the labels are left unchanged.

The `auto-pull` workflow performs the label changes using a personal access token owned by @autobib-brew-bot.

### Manual labelling

The label changes can also be done manually. Applying or removing a label requires the [Triage role](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization) or higher on the repository.

### The `release` workflow

Applying the `pr-pull` label triggers the `release` workflow, which runs `brew pr-pull`.
This releases the bottle artifacts, pushes the formula change to the main branch along with a new commit containing the new bottles' hashes, and deletes the PR's source branch.

## Security considerations

Since the workflows result in the publication of formula updates and new bottles, we must make sure they cannot be triggered without sufficient access privileges, and that an untrusted contribution (such as a pull request from a fork) cannot subvert them into making unauthorised changes.

We enforce two rules.

1. Write-access workflows can only be triggered by trusted parties.

    The `formula-bump`, `auto-pull`, and `release` workflows modify the contents of the repo directly or perform actions that cause content changes through automation.
    For a user to trigger any of the three workflows directly or transitively, they must have either the Triage role or higher (in order to apply the `auto-pull` or `pr-pull` label) or write access to the repository (in order to dispatch a workflow).

2. Write-access workflows only run on the default branch.

    This ensures the workflows will not use any poisoned cache, as the default branch can only restore cache created on itself.

    The `formula-bump` and `auto-pull` workflows use the `pr-automation` environment, which is only allowed in runs on the `main` branch.
    The `release` workflows only run on the default branch, as it only has the [`pull_request_target`](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#pull_request_target) event trigger.

We also rely on [GitHub's policies](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#workflows-in-forked-repositories) on secrets and `GITHUB_TOKEN`'s permissions in workflow runs on forks.
