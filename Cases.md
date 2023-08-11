| Data?         | URLResponse?          | Error?    | Representable state |
| -----------   | --------------------- | --------- | --------------------------------------------- |
| nil           | nil                   | nil       | <span style="background:red"> invalid </span> |
| nil           | URLResponse           | nil       | <span style="background:red"> invalid </span> |
| nil           | HTTPURLResponse       | nil       | <span style="background:red"> invalid </span> |
| value         | nil                   | nil       | <span style="background:red"> invalid </span> |
| value         | nil                   | value     | <span style="background:red"> invalid </span> |
| nil           | URLResponse           | value     | <span style="background:red"> invalid </span> |
| nil           | HTTPURLResponse       | value     | <span style="background:red"> invalid </span> |
| value         | URLResponse           | value     | <span style="background:red"> invalid </span> |
| value         | HTTPURLResponse       | value     | <span style="background:red"> invalid </span> |
| value         | HTTPURLResponse       | nil       | <span style="background:green"> valid </span> |
| nil           | nil                   | value     | <span style="background:green"> valid </span> |