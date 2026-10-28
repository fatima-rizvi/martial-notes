> Team 20: Fatima Rizvi and Michael Yanez
> Note: All work below is our own. This prompt, which was made to be used by GitHub copilot, was written entirely on our own. The prompt instructions were based off of the Project Step 3 Draft Version assignment instructions. The project overview came directly from our team's Project Proposal.


You are a technical writer. Your job is to create a single readme for this whole repository. The readme will be in the repo root. These are your instructions and task parameters:
- The readme must contain the following:
  - project title (Martial Notes)
  - the authors
  - a brief description of the project (extrapolated from the overview below,and the project files). Note that this is only the database and the application interface for the database, not the actual client that users will interact with.
  - installation and dependency instructions (mysql-connector-python, the minimum python version required (determined by the code), and mysql) 
  - how to run the project (set up mysql, apply the DDL, configure the test runner, run the script)
  - a description of the expected output and what it shows.
  - a section for citations for me to fill out.
- The readme should allow any user who reads it to run this application without needing any guesswork
- It should include database setup steps and the description to run the python modules. You can center the steps around the assumption that the user will be using mysql. 

Be concise and clear. Do not use overly technical language. Format any commands to be copy and paste-able. Don't touch any other files. Pause if you have any questions for me.

Project overview:
"Martial Arts is a discipline consisting of dozens of arts, including but not limited to Muay Thai, Jiu Jitsu, Taekwondo, Karate, Kick Boxing, and Judo. It’s a popular sport, for example brazilian jiu jitsu alone has 6 million practitioners in 2026 (Binder). Each martial art has its own style and moves, with some overlap between certain arts. Boxing has 6 basic punches, and 3 main defense moves (Legends Boxing).  Brazilian Jiu Jitsu has many techniques, with beginners focusing on fundamental positions, escapes, submissions, sweeps, and takedowns (Gates). And yet, while each art can be distilled into core techniques, they can combine each of those techniques with various footwork to achieve an infinite number of combinations. The sheer number can be overwhelming. One common recommendation for students is to take notes on the moves they learn in class, and then to study them further on their own at home. They may take notes on a piece of paper, or in the notes app on their phone. These notes cannot be easily organized, or easily reviewed. For the initial implementation, we expect the database to track approximately 6 martial art types and about 100 move records with StudySession and Event records growing as the application is used. A database driven application with a Python application tier will be able to collect the names and descriptions of moves, categorize them by martial arts type, and allow users to study moves with a “study” mode that rotates through them in a randomized order. That application will allow for easy organization and lookup of moves, and provide an improved study experience that will accelerate a student’s learning. Users would input as many martial arts types as they are training, which could be anywhere from one to four, or even more. Since “moves” in our application would encompass both individual moves (ex: jabs, chokes, blocks, etc) and combos, each user would be expected to easily log dozens or even hundred of moves in the application."