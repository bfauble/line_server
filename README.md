**How does your system work? (if not addressed in comments in source)**

The system works by taking the file and dividing it up into smaller chunks using the unix command 'split -l 10000'.
This will create as many 10,000 line files necessary to make up the entirety of the full file.
That way the search time for a specific line is greatly reduced for large files with
a huge amount of lines. These are put into a temporary directory to be parsed on server start.
Upon running the server, a hash is constructed of the file names that reside in the temporary folder with an index key
based on the order of the file alphabetically created by 'split -l'.
When a line is passed via the url, that number is checked against the total number of lines, which was captured using
the unix command 'wc -l' on server start, then parsed to match the appropriate file key, then the appropriate line number in that specific file or return a 413 status if the line number is larger than the total or less than 1.

Example (line: 10,005, file = files[line / 10000], line = file.each_line.take(line % 10000).last)

This way the files aren't kept open so the server doesn't crash when too many files are simultaneously
open.

**How will your system perform with a 1 GB file? a 10 GB file? a 100 GB file?**

System nearly as fast for all sizes of files due to the largest file search being only 10,000 lines.
I've parsed 1,000,000,000 lines with the majority of responses below 5ms, so provided there aren't
operating system or disk space issues with having several thousand files in a directory, I would expect
the access time to stay low, though the startup time for the server would increase for larger files.

**How will your system perform with 100 users? 10000 users? 1000000 users?**

With the default connection cap of 1024, the server can handle thousands of users at once,
but as the amount of users go up, the likelihood of timeouts would increase and the server
would essentially become DDoSed. This could be alleviated by increasing the amount of servers
and putting some sort of load balancer in front of the server, but currently this is not
implemented.

**What documentation, websites, papers, etc did you consult in doing this assignment?**

- http://ruby-doc.org/core-2.2.2/
- http://www.sinatrarb.com/documentation.html
- http://stackoverflow.com
- http://stackoverflow.com/questions/2650517/count-the-number-of-lines-in-a-file-without-reading-entire-file-into-memory
- https://en.wikipedia.org/wiki/Split_%28Unix%29

**What third-party libraries or other tools does the system use? How did you choose each library or framework you used?**

- Sinatra
  - lightweight web framework. Limited overhead and without a lot of unnecessary libraries etc as you would have with rails. Simple to setup and get a webserver running.
- wc
  - Far better optimized for counting the lines in a file compared to ruby, increase startup time of server.
- split
  - Traversing large files greatly increases the amount of time spent looking up a particular line in the file. Split works much faster than a ruby implementation would to separate out files into a set line size.
- thin
  - Lightweight web server, supports multiple connections vs default WEBrick server. Popular with a lot of documentation and examples.

**How long did you spend on this exercise? If you had unlimited more time to spend on this, how would you spend it and how would you prioritize each item?**

I spent roughly 4 hours on the project. With more time, I would focus on the load balancing
issue of the server to help account for larger amounts of users and also research into a, possibly,
better line amount per file to optimize the lookup time. I think the current configuration with 10,000
lines per file is adequate from a user's perspective and I don't think cutting down another ms or two
would improve the user's experience as much as avoiding DDoS situations due to the server being unable
to handle the amount of requests it is receiving.

**If you were to critique your code, what would you have to say about it?**

I think the big criticism for the code is that it's not setup very well to be extended. With the
functionality being so simple, the necessity of additional libraries didn't seem very necessary
so the file parsing and webserver communications are all being handled by the same object. The
file parsing logic should be separated out into it's own class to separate concerns and make future
expansion easier without the need for more refactoring.
