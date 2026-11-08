| Term | Meaning |
|---|---|
| Utility | A long-running command or application managed as a movable tmux resource, such as `htop`, `lazygit`, a log tail, REPL, file manager, or debugger. |
| Registered utility | A utility definition stored in configuration. It may accept arguments and define defaults, scope, launch behavior, colors, and lifecycle policy. |
| Ad hoc utility | A utility launched from the command line or chooser without first adding a permanent utility definition. It is still assigned to a session and can be managed, borrowed, returned, and terminated. |
| Instance | One running occurrence of a utility. Multiple instances may come from one registered definition. |
| Home session | The session assigned to an instance as its normal/full-window home. |
| Home window | The window occupied by an instance in its home session. A utility occupies a full window in its home session. |
| Working session/window | The session/window into which a pane or utility is borrowed. |
| Pane | A tmux pane. Borrowing a pane moves the existing pane; it does not restart its process. |
| Borrow | Move an existing pane or utility window into a working context. |
| Borrowed pane | A pane currently away from its home location and tracked by the manager. |
| Borrowed utility | A managed utility instance currently displayed outside its home window/session. |
| Resource identity | Stable manager identity for an instance, independent of its current tmux pane ID, window index, or session name. |
| Instance ID | Unique identity for one running instance. |
| Scope | Whether an instance is shared across user windows or belongs to one user window. |
| Layout | A collection of borrowed resources and their arrangement in a target window. |
| Borrowed-only layout | A saved arrangement containing only manager-tracked borrowed resources. Ordinary panes are excluded. |
| Selector | Interactive popup interface for choosing utilities, layouts, sessions, panes, and actions. |
