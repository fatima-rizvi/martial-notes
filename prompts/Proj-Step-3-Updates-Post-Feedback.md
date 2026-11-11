> Team 20: Fatima Rizvi and Michael Yanez
> Note: All work below is our own. These prompts, which were made to be used by GitHub copilot, were written entirely on our own. The changes proposed by the prompts are the ones we got in our feedback that we decided to implement. After passing the first prompt through the agent, it went through each decision one by one and paused to ask clarifying questions on each step to ensure that it was implementing it correctly. After passing through the second prompt, the agent returned a plan to format the values when they get printed, and then I prompted the agent with "Implement the plan". It then updated the test runner.

Prompt 1:
These are the decisions I am deciding to make. Let's walk through them step by step. You tell me your proposed implementation, and I will decide if I want it to be implemented that way or if it should be done differently. Do not implement without my approval:

- Update the README set up documentation to include how to run the DDL.sql
- Add ordering to the result queries where appropriate
- Update the queries to return entity record names and not just the IDs
- Use aliases for the column names when returning the results
- Add spacing between sections to the CLI output by using newlines to improve readability
- Update the martial arts used in the test runner (on the call get_events_for_martial_art) to one that actually has events associated with it.

Prompt 2:
Is there a way to make the CLI output easier to read? Specifically, the parts saying "datetime.timedelta" and "datetime.datetime". What would it be? Do not implement.
