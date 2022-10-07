# Bitcoin Miner

Group Members: Aseem Baranwal, Debi Prasad Das

### Outline:

We have implemented the Bitcoin Miner Project using **Erlang’s Actor Model.** bitcoin is
required to have a specific number of leading 0’s given as input by the boss (If 3 is given as input,
then 3 leading 0’s in the hash value or more than that value.
Eg. : Found: "0004839af087eb4f0c88809af2b915056d9f0e1b90815d7346b894230e8a14f”)
We used SHA- 256 algorithms to hash the random string generated in our code. In addition, we used the IP address for remote communication between Server [server] and the Client [worker].

### Implementation Details:

1. First, we should run the Server(server.erl)
   So, in the terminal we start with the command:
   ```erl -name server@[IPAddress] -setcookie [CookieName]```
   Similarly for client-side(worker.erl) for Distributed Implementation terminal Command would be:
   ```erl -name worker@[IPAddress] -setcookie [CookieName]```
   The cookie name should be the same on both the server and client-side
2. We compile the server using the command: c(server).
   This will compile the server.erl file on the server side.
3. We compile the client using the command: c(worker).
   This will compile the worker.erl file on the client side when we test for Distributed implementation.
4. Once the server file(server.erl) is compiled successfully. We will start the server on Terminal1 using command: ```server:start()```
   It will ask 3 things as input :
   i) Enter the number of 0s to find on the bitcoin:
   ii) Enter the number of Bitcoins to be mined:
   iii) Enter the number of processes to be spawned by the server:
   Using these inputs will be critical to generate the desired output.
5. Enter the values on the Terminal1 and Server(server) will start mining coins through the
   processes spawned by it without any help from the Client(worker).
6. Meanwhile Client(worker) can also join the Server(server) and take part in mining. For achieving this, in Terminal 2 where we ran the command:
   ```erl -name worker@[IPAddress] -setcookie [CookieName]```
   We then run the command:
   ```c(worker).```
   After that, we will run the command: ```erl -name worker@[IPAddress] -setcookie [CookieName]```
   IP Address refers to the IP address of the server. Once the above command is run, the client will also join the server in mining bitcoins.
7. In order to achieve Distributed Implementation, we need to follow the below things:
   i) Compile the server using the command on Terminal 1: c(server).
   ii) Start the server on the terminal using the command: server:start().
   iii) It will ask the things mentioned in Step no. 4.
   iv) Then Enter the number of processes to be spawned by the server: 0 since we don’t need any spawn processes or server to mine the coins. We need only the Client(worker) to mine the coins and send them back to sever the Bitcoin found.
   v) Compile the Client side(worker.erl) on Terminal2 using command: c(worker).
   vi) Then start the client using the command: ```worker:start(“{IPAddress}”).```
   Now the client will start mining the Bitcoins.
8. File Structure:
   Inside Project - 1 we have 2 files – server.erl and worker.erl which are Server and Client respectively.

   **Server(server.erl)**: The server’s duty is to start the server on a node and start mining coins through the processes(actors) spawned by it, depending on the
   input that we give on the terminal. If we give the Number of processes(actors) to be spawned by the server as 0, then no processes(actors) will be spawned. If
   we give 3 or 4 or 6 then that many numbers of processes(actors) will be spawned by the server. A client(worker) can also join in mining through Step no. 6
   mentioned above. The actors on the client will behave in the same way as the actors on the server side. Any number of clients may participate in mining. The
   mining of bitcoins will continue and will be printed on the server side till it matches the required value of bitcoins to be mined given by the user on the server
   side.

   ***Client(worker.erl)***
   The client can participate in mining by establishing a connection to the server using the command
   given in Step 6. After the connection is established then actors on the client side will start mining
   coins.

9. Project WorkFlow
   o The server will take input: The number of zeroes to match on the hashed string so that it can be called as a bitcoin, the number of bitcoins to be mined and a number of actors to be spawned by the server.
   o The server spawns’ actors depending on the input given by the user and starts mining bitcoins.
   o If an actor shuts down, then the work assigned to it will be given to another actor spawned by the server.

   o Random strings (Example: 224cjbRbj, RTYUIO47chg, etc.) are generated and appended to “ddas1 ;a.baranwal; ” and hashed using the SHA-256 algorithm.
   The hash it generates needs to have leading zeroes specified by the user. If it is present, then it gets displayed by the server as Bitcoin found and prints it as
   well as the actor’s id who found it. The client can also join in mining bitcoins.
   o Inside the start function in the server, we have a controller function that takes care of the total number of bitcoins found and prints it, and spawns the
   desired number of processes given as input by the user.
   o In a Distributed implementation, the server spawns 0 actors. The client connects and starts mining bitcoins spawning its own actors. Once a bitcoin is found
   it sends back to the server and the server prints on the terminal. And client continues mining the bitcoins.
   o The total process ends when we find the required number of bitcoins specified by the user.
   o At last, we calculate the CPU Time, Real-Time, and CPU Time/Real Time to get how many
   cores were effectively used in the computation.

### Results:
Work Unit
The Ideal Number of processes to be run in both server as well as Client is equal to (Number of Cores * 4). This ensures all the cores are used efficiently to mine bitcoins faster. In our project, every actor can generate a random string, computes the hash, mine the bitcoins using the SHA-256 Algorithm, and sends that bitcoin back to the server to be printed on the terminal. Each actor runs till the server gets the desired number of bitcoins. If the desired number of bitcoins are found, then all actors get killed. The actor on finding a bitcoin sends the coin back to the server and waits for the response from the server on whether to hash any more coins or not. In our code, the user enters max number of workers to be spawned as max 32 as it is the ideal number of processes that can be run.
We chose this work unit because –
i) It avoids the repeated generation of the same string across all the workers and finds the desired number of bitcoins faster.
ii) It is scalable as different workers get different workloads. We also tried the max K value (number of leading zeroes to be in the hashed string so that it will be a bitcoin) in our code as 8 and we found 1 bitcoin.
But we failed to find Bitcoins for K value as 9.

We reached the following results in a full working scenario with two processes from the server and 3 processes from the client.

### The result of running your program for input 4
Input given

```Enter the number of 0s to find on the bitcoin: 4
Enter the number of Bitcoins to be mined: 50
Enter the number of processes to be spawned by the server: 32

The ratio of CPU time to REAL time.
CPU Time: 98328000 microseconds
Real Time: 13666000 microseconds
Number of cores effectively used = CPU Time/Real time = 7.
```

The coin with the most 0s you managed to find.
We mined coins with 8 leading zeroes resulting in 1 BitCoin
resulting in 3 hrs.
We executed on Macbook Air M2 Chip with configuration: 8-core CPU and on Asus ROG i5 9th gen CPU
The largest number of working machines you were able to run your code with was 5.
We were able to run our code on 6 different systems and they all were able to mine bitcoins simultaneously. This can also go up to a greater number of different machines.

The client ids of the 3 machines are:
```
1. <13773.109.0>
2. <13773.116.0>
3. <13773.114.0>
4. <13773.118.0>
5. <13773.120.0>