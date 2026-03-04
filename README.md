# TODO

I like to keep a todo list in my projects. This is a plugin to keep them pretty and usable. It functions on any files named 'TODO'. The following features are included:

- Command 'NewTask' to create a new task
- `]]` and `[[` bindings to jump between tasks
- Bindings <leader>{m, u, n, c} to {mark, unmark, jump to next, mark complete} tasks
- Some syntax highlighting


## Syntax

The following example syntax explains how tasks are set up

```
WIP|DONE
1. Task title
    * Incomplete subtask
    * Another incomplete subtask
        * But this one
        * Has some sub-sub-tasks
    | The completed subtasks look like this
    * If a task has NB in it, it is marked as extra important
    * Your current task (marked with <leader>m) has a marker on it     ← NEXT
    * Use <leader>n to jump to the next task
    * Use <leader>u to unmark them
    * Use <leader>c to change a task from complete (*) to incomplete (|)
```
