---
description: Generate inline comments and annotations
agent: build
---

Generate yml file in the current file with format as below:

```yml
version: 2

models:
  - name:
    description:
    meta:
      owner:
      individual_sme:
    columns:
      - name:
        mode:
        type:
        description:
```

And then based on tab separated value below and fill the columns, if the
description is empty then generate description based on the column name, type,
and "models.name". Keep "models.name", "models.description", "meta.owner" and
"meta.individual_sme" empty. Put "mode" to be "NULLABLE" if it is not specified
in the tab separated value, otherwise use the mode specified in the tab
separated value.
