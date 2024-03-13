# README for the robot framework template

## Development guide

For example, to create a new test instance for the login page, create a new file in the Testcases folder and add the running script to robot.yaml.
```bash
    python -m robot -d Log -r ${REPORT NAME} -o ${OUTPUT NAME} -l ${LOG NAME} --variable env:${ENV Testcases/NAME OF FILE}.robot
```

### Suggested directory structure

The directory structure given by the template:

```
├── devdata
├── keywords
│   └── keywords.robot
├── libraries
│   └── MyLibrary.py
├── resources
│   └── variables.py
```

where

- `devdata`: A place for all data/material related to development, e.g., test data. Do not put any sensitive data here!
- `keywords`: Robot Framework keyword files.
- `libraries`: Python library code.
- `resources`: Define your resources in a centralized place. For example the robot variables can be defined in here. Do not put any sensitive data here!
- `tasks.robot`: Robot Framework task suite - high-level process definition.

In addition to these, you can create your own directories (e.g. `bin`, `tmp`). Add these directories to the `PATH` or `PYTHONPATH` section of `robot.yaml` if necessary.

Logs and artifacts are stored in `output` by default - see `robot.yaml` for configuring this.

Learn how to [handle variables and secrets](https://robocorp.com/docs/development-guide/variables-and-secrets/secret-management).

### Additional documentation

See [Robocorp Docs](https://robocorp.com/docs/) for more documentation.
