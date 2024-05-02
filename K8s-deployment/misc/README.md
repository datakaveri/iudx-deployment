# Custom kubectl Function

## Overview

This repository contains a custom shell function for the `kubectl` command. The function adds an additional layer of confirmation prompts before executing potentially destructive commands, specifically for deleting namespaces.

## Functionality

The custom `kubectl()` function behaves as follows:

- When the user attempts to delete a namespace (`delete namespace` or `delete ns`), it prompts for confirmation before proceeding.
- If the deletion command includes the `--all` flag, it requires the user to explicitly type "delete all namespace" to confirm.
- If the user confirms the deletion, the function executes the `kubectl` command with the provided arguments.
- If the user chooses not to proceed with the deletion, it cancels the operation.

## Installation

To use this custom `kubectl()` function, follow these steps:

1. Copy the provided function code.
2. Open your shell configuration file (e.g., `.bashrc`, `.bash_profile`, `.zshrc`).
3. Paste the function code at the end of the file.
4. Save the file and reload your shell configuration (`source ~/.bashrc` or `source ~/.zshrc`).
5. Now, whenever you use the `kubectl` command to delete a namespace, the custom function will intercept the command and prompt for confirmation.

## Usage

Simply use the `kubectl` command as you normally would. When deleting namespaces, the function will prompt for confirmation based on the conditions mentioned above.

## Example

```
$ kubectl delete namespace my-namespace
You are trying to delete a namespace. Do you want to proceed? (yes/no): yes
namespace "my-namespace" deleted
```

```
$ kubectl delete ns --all
You are trying to delete all namespaces. Please type 'delete all namespace' to confirm:
```
