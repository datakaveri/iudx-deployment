# Custom kubectl Function

## Overview

This repository contains a custom shell function for the `kubectl` command. The function adds an additional layer of confirmation prompts before executing potentially destructive commands, specifically for deleting namespaces.

## Functionality

The custom `kubectl()` function behaves as follows:

- When the user attempts to delete a namespace (`delete namespace` or `delete ns`), it prompts for confirmation before proceeding.
- If the user confirms the deletion, the function executes the `kubectl` command with the provided arguments.
- If the user chooses not to proceed with the deletion, it cancels the operation.
- If the deletion command includes the --all flag, it informs the user that deleting all namespaces is not allowed and cancels the operation.
## Installation

To use this custom `kubectl()` function, follow these steps:

1. Create a new file and copy the provided function into that file `k8s-ns-del-prevention.sh`.
2. Ensure the file has execute permissions: `chmod +x k8s-ns-del-prevention.sh`.
3. Add the path of that file to your shell configuration file (e.g., `.bashrc`, `.bash_profile`).
   
   ```
   source ~/k8s-ns-del-prevention.sh
   ```
4. Save the file and reload your shell configuration using the below command:
   
   ```
   . ./.bashrc
   ```
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
Deleting all namespaces is not allowed. Operation cancelled.
```
