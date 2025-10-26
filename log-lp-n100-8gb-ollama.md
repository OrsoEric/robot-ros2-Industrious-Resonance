# Latte Panda N100 8GB - Ollama

LM studio performance seems low at 3tps for 3BQ4 models.

Macario tested ollama on RPI5 and got similar performance

I test ollama on the lattepanda

Then I'll test OpenVINO and get a comparison

### Second Board N100 16GB

## Install

[Ollama Ubuntu Instructions](https://ollama.com/download/linux)

```bash
curl -fsSL https://ollama.com/install.sh | sh

ollama

```

<details>
<summary>2025-09-20 Install Ollama LOG</summary>

```bash
sona@sona-lp-n100-8gb:~$ sudo apt install curl
[sudo] password for sona:
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following package was automatically installed and is no longer required:
  libllvm19
Use 'sudo apt autoremove' to remove it.
The following NEW packages will be installed:
  curl
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 226 kB of archives.
After this operation, 534 kB of additional disk space will be used.
Get:1 http://it.archive.ubuntu.com/ubuntu noble-updates/main amd64 curl amd64 8.5.0-2ubuntu10.6 [226 kB]
Fetched 226 kB in 0s (983 kB/s)
Selecting previously unselected package curl.
(Reading database ... 193199 files and directories currently installed.)
Preparing to unpack .../curl_8.5.0-2ubuntu10.6_amd64.deb ...
Unpacking curl (8.5.0-2ubuntu10.6) ...
Setting up curl (8.5.0-2ubuntu10.6) ...
Processing triggers for man-db (2.12.0-4build2) ...
sona@sona-lp-n100-8gb:~$ curl -fsSL https://ollama.com/install.sh | sh
>>> Installing ollama to /usr/local
>>> Downloading Linux amd64 bundle
######################################################################## 100.0%
>>> Creating ollama user...
>>> Adding ollama user to render group...
>>> Adding ollama user to video group...
>>> Adding current user to ollama group...
>>> Creating ollama systemd service...
>>> Enabling and starting ollama service...
Created symlink /etc/systemd/system/default.target.wants/ollama.service → /etc/systemd/system/ollama.service.
>>> The Ollama API is now available at 127.0.0.1:11434.
>>> Install complete. Run "ollama" from the command line.
WARNING: No NVIDIA/AMD GPU detected. Ollama will run in CPU-only mode.
sona@sona-lp-n100-8gb:~$ ollama
Usage:
  ollama [flags]
  ollama [command]

Available Commands:
  serve       Start ollama
  create      Create a model
  show        Show information for a model
  run         Run a model
  stop        Stop a running model
  pull        Pull a model from a registry
  push        Push a model to a registry
  signin      Sign in to ollama.com
  signout     Sign out from ollama.com
  list        List models
  ps          List running models
  cp          Copy a model
  rm          Remove a model
  help        Help about any command

Flags:
  -h, --help      help for ollama
  -v, --version   Show version information

Use "ollama [command] --help" for more information about a command.
```

</details>

## Select Model Folder 

Create model folder


```
sona@lpn10016gb:~$ mkdir /mnt/external_disk/ollama_models

sudo chown -R ollama:ollama /mnt/external_disk/ollama_models

sona@lpn10016gb:~$ ls /mnt/external_disk/
lost+found  ollama_models  test_file.txt

```

```
sudo mount /dev/nvme0n1 /mnt/external_disk

ls /mnt/external_disk

export OLLAMA_MODELS="/mnt/external_disk/ollama_models"
```

```
sudo systemctl edit ollama.service

sudo systemctl show ollama --property=Environment

```

add the following lineollama piu

```
[Service]
Environment="OLLAMA_MODELS=/mnt/external_disk/"
```


```
sudo systemctl daemon-reload
sudo systemctl restart ollama

```

## xxx



## Model

I already have a model downloaded on the NVMe drive

Qwen 3-2507 3B Q4M

```bash
sona@sona-lp-n100-8gb:~$ ls /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0/models_llm/lmstudio-community/
Qwen3-4B-Instruct-2507-GGUF
```

## Ollama Models

```
ollama run gemma3:1b

sona@lpn10016gb:~$ ollama pull gemma3:1b
pulling manifest
pulling 7cd4618c1faf: 100% ▕██████████████████████████████████████████████████████████████████████▏ 815 MB
pulling e0a42594d802: 100% ▕██████████████████████████████████████████████████████████████████████▏  358 B
pulling dd084c7d92a3: 100% ▕██████████████████████████████████████████████████████████████████████▏ 8.4 KB
pulling 3116c5225075: 100% ▕██████████████████████████████████████████████████████████████████████▏   77 B
pulling 120007c81bf8: 100% ▕██████████████████████████████████████████████████████████████████████▏  492 B
verifying sha256 digest
writing manifest
success
sona@lpn10016gb:~$ ollama list
NAME         ID              SIZE      MODIFIED
gemma3:1b    8648f39daa8f    815 MB    14 seconds ago
sona@lpn10016gb:~$ ollama run gemma3:1b
>>> shaka


```

## Ollama Model Card


1) Create a file without extension ```home/sona/ollama_model_card/model_card_qwen_3_2507_3b_q4m```

2) File Content
```
FROM /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0/models_llm/lmstudio-community/Qwen3-4B-Instruct-2507-GGUF
```

3) In ollama 
```bash
ollama create my_qwen -f ~/ollama_model_card/model_card_qwen_3_2507_3b_q4m

ollama list

ollama run qwen3-4b
```

```bash
sona@sona-lp-n100-8gb:~$ ollama create my_qwen -f ~/ollama_model_card/model_card_qwen_3_2507_3b_q4m
gathering model components
copying file sha256:8cdb57cbb880d313736a9bc4e3d3d2485f145b5e19cf33783746e753e82641fc 100%
parsing GGUF
using existing layer sha256:8cdb57cbb880d313736a9bc4e3d3d2485f145b5e19cf33783746e753e82641fc
writing manifest
success

sona@sona-lp-n100-8gb:~$ ollama list
NAME              ID              SIZE      MODIFIED
my_qwen:latest    5f694adecb8b    2.5 GB    37 seconds ago

sona@sona-lp-n100-8gb:~$ ollama run my_qwen
>>> what does the fox says?
 1. The fox says "I'm a good boy" 2. The fox says "I'm a good boy" 3. The fox says "I'm a good boy" 4. The fox says "I'm a good boy" 5. The fox says "I'm a good boy" 6. The fox says "I'm a good boy" 7. The fox says "I'm a good boy" 8. The fox says
"I'm a good boy" 9. The fox says "I'm a good boy" 10. The fox says "I'm a good boy" 11. The fox says "I'm a good boy" 12. The fox says "I'm a good boy" 13. The fox says "I'm a good boy" 14. The fox says "I'm a good boy" 15. The fox says "I'm a
good boy" 16. The fox says "I'm a good boy" 17. The fox says "I'm a good boy" 18. The fox says "I'm a good boy" 19. The fox says "I'm a good boy" 20. The fox says "I'm a good boy" 21. The fox says "I'm a good boy" 22. The fox says "I'm a good boy"
23. The fox says "I'm a good boy" 24. The fox says "I'm a good boy" 25. The fox says "I'm a good boy" 26. The fox says "I'm a

The fox says: "I'm a good boy."

*(Note: This is a repetitive line, likely referencing the famous children's song "The Fox (I'm a Good Boy)" or a playful, humorous version of a fox saying "I'm a good boy." There's no actual dialogue from a real fox — it's a fictional or playful
statement.)* 🦊😄

Would you like a version with a twist, a rhyme, or a story? 😊

>>> /?
Available Commands:
  /set            Set session variables
  /show           Show model information
  /load <model>   Load a session or model
  /save <model>   Save your current session
  /clear          Clear session context
  /bye            Exit
  /?, /help       Help for a command
  /? shortcuts    Help for keyboard shortcuts

Use """ to begin a multi-line message.

>>> /bye

```

Run without the internal command line interface

```bash
ollama run my_qwen "What's the height of the Tour Eiffel in meters?" --verbose



```

### PROBLEM

I need to make a proper model card, the default parameters make the model work terribly

## Ollama Download Model

[Look for models to download](https://ollama.com/library)


```bash
export OLLAMA_MODELS=/media/sona/fe4d92e2-b743-4576-b445-e47f511902d0/models_llm

ollama pull qwen3:4b

ollama run qwen3:4b "What's the height of the Tour Eiffel in meters?" --verbose


ollama run qwen3:4b "/no_think What's the height of the Tour Eiffel in meters?" --verbose


```

```bash
sona@sona-lp-n100-8gb:~$ export OLLAMA_MODELS=/media/sona/fe4d92e2-b743-4576-b445-e47f511902d0/models_llm
sona@sona-lp-n100-8gb:~$ ollama pull qwen3:4b
pulling manifest
pulling 3e4cb1417446: 100% ▕███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏ 2.5 GB
pulling 53e4ea15e8f5: 100% ▕███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏ 1.5 KB
pulling d18a5cc71b84: 100% ▕███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏  11 KB
pulling cff3f395ef37: 100% ▕███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏  120 B
pulling e18a783aae55: 100% ▕███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏  487 B
verifying sha256 digest
writing manifest
success
sona@sona-lp-n100-8gb:~$ ollama list
NAME              ID              SIZE      MODIFIED
qwen3:4b          e55aed6fe643    2.5 GB    About a minute ago
my_qwen:latest    5f694adecb8b    2.5 GB    28 minutes ago
```

This looks wrong, I can select the quant... Is this FP16? No it looks Q4M that is what I like, perhaps therecomended quant.

It's also not in the SSD, the export did nothing -.-

### Ollama Default Folder

This is HORRIBLE. Ollama turns out stores blobs as hashes in user folder!!!

```bash
sona@sona-lp-n100-8gb:~$ sudo find / -type d -name "blobs" 2>/dev/null | grep -i ollama
[sudo] password for sona:
/usr/share/ollama/.ollama/models/blobs

sona@sona-lp-n100-8gb:~$ ls /usr/share/ollama/.ollama/models/blobs
ls: cannot access '/usr/share/ollama/.ollama/models/blobs': Permission denied

sona@sona-lp-n100-8gb:~$ sudo ls /usr/share/ollama/.ollama/models/blobs
sha256-3e4cb14174460404e7a233e531675303b2fbf7749c02f91864fe311ab6344e4f  sha256-8cdb57cbb880d313736a9bc4e3d3d2485f145b5e19cf33783746e753e82641fc  sha256-e18a783aae5525fd2852fc94c985541a77e791e034abc2d3056474d59de336fc
sha256-506fb3bc0dff7fcb027f3903d93ea1f3d7c22b3bb449192e85977484f95a571f  sha256-cff3f395ef3756ab63e58b0ad1b32bb6f802905cae1472e6a12034e4246fbbdb
sha256-53e4ea15e8f5f17f5052c5ef6aef5f79b4266708c93e7c893dbe4b3e211a815d  sha256-d18a5cc71b84bc4af394a31116bd3932b42241de70c77d2b76d69a314ec8aa12
```

TODO: If I really want to use ollama, I need to properly use gguf in the NVME, not whatever this garbage ollama does...

## Benchmark

[Text comprehension test](https://www.esl-lounge.com/student/reading/4r6-snake-bites-boy.php)

```txt
/no_think
What follows is a short story, your task is to answer questions

<story>
Three-year-old Teddy Lasry was napping yesterday in his cowboy outfit yesterday at his family's Fifth Ave. apartment when he shot up in bed screaming. A 3-foot-long black-and-white snake was coiled around his left arm and had just bitten his pinky.

"The baby-sitter freaked out," said Teddy's father, David Lasry, who, along with his wife, Evelyn, was at work when the reptile showed up about 4 p.m.

The horrified nanny called 911 and the building's doorman. The doorman and two cable TV workers helped pry the snake off the boy's arm and stow it in a garbage bag, Lasry said.

Police rushed Teddy to Mount Sinai Medical Center, where his parents said he spent two hours attached to a heart monitor as a precaution in case the snake was poisonous.

It wasn't. Experts at the snakebite treatment center at Jacobi Medical Center in the Bronx, where cops took the critter, determined it was a non-venomous California king snake.

But how did it end up in Teddy's bed?

A little sleuthing determined that the serpent had escaped two weeks ago from its cage in the apartment of a doctor whose family lives four floors below the Lasrys. The apologetic owner said his son's pet snake likely traveled up the radiator pipes and into his neighbor's apartment.

"It's a very docile, very harmless snake," he said. "It's handled by our family all the time."

Lasry, 42, a fine arts publisher, said he believed the pet was simply hungry after two weeks of cruising. Teddy's mother, Evelyn Lasry, 37, said her son seems to have gotten over his fright by thinking of himself as a hero cowboy as he rode in the back of the police cruiser to the hospital.

"I told Teddy he's a pretty snake, a nice pet snake who got out of his cage," Evelyn Lasry said. "But he asked, 'Why did he bite my finger, Mamma?' And I said, 'Because he saw that you are a big boy, Teddy, in your cowboy outfit and he got scared.'"

</story>

<questions>
1 - What did the babysitter do?
2 - What do we learn about the snake?
3 - What does Teddy think now of the snake attack?
</questions>
```



```bash
sona@sona-lp-n100-8gb:~$ ollama run qwen3:4b "What's the height of the Tour Eiffel in meters?" --verbose
Thinking...
Okay, the user is asking about the height of the Eiffel Tower in meters. That seems straightforward, but I should be careful because there are different measurements depending on what exactly they mean by "height."

Hmm, most people would expect the standard height without antennas, but I recall the Eiffel Tower has several antennas that add extra height. The user didn't specify, so I should cover both the original structure and the total height including
antennas.

Let me think... The base height is 300 meters, right? But no, that's not right. Wait, I remember it's 300 meters from the ground to the first level. The total height including antennas is 330 meters? No, that doesn't sound right.

I think I need to double-check my knowledge. The Eiffel Tower was built in 1889, and the original height was 300 meters. But then they added antennas over time. The current total height is 330 meters? Wait, no, I think it's actually 324 meters for
the structure without antennas, but with the top antennas it's 330 meters.

This is confusing. I should recall that the official height is often listed as 300 meters for the tower itself, but the total height including the antennas is 324 meters. Wait, no—I think I have it: the Eiff as 300 meters to the top of the first
level, but the full height with antennas is 330 meters.

Actually, after checking my mental database, I remember that the Eiffel Tower's height is commonly cited as 300 meters for the structure, but the total height including the broadcast antennas is 324 meters. However, in recent years, they added
more antennas, so it's now 330 meters?

I think the most accurate answer is that the Eiffel Tower's height is 324 meters to the top of the main structure, but with the additional antennas, it's 330 meters. But I should be precise.

Upon second thought, I recall that the official height as of 2023 is 330 meters. Wait, no—let me think differently. The user is probably looking for the standard figure that's taught in schools. In many textbooks, it's given as 300 meters. But
that's the height without antennas.

I found a reliable memory: the Eiffel Tower is 300 meters tall to the top of the first level, but the total height including all antennas is 324 meters. However, in 2021, they added a new antenna, so it's now 330 meters.

But to be safe, I'll go with the most commonly accepted figure. Most sources say the Eiffel Tower is 300 meters high, but that's the original height. The current total height is 324 meters. Wait, I'm getting mixed up.

Let me structure this:
- Original height (1889): 300 meters
- Current height (including antennas): 324 meters (as per Eiffel Tower's official site)
- But some sources say 330 meters because of additional antennas

After thinking, I remember that the Eiffel Tower's height is officially listed as 324 meters to the top of the main structure, and the additional antennas make it 330 meters. However, for general purposes, people often say 300 meters.

The user asked for "the height," so I should provide the most accurate current figure. I think the latest official height is 330 meters. But to be precise, I'll say 324 meters for the tower itself and 330 meters including antennas.

Wait, no—I think I have it: the Eiffel Tower is 300 meters from the ground to the top of the first level, and the total height including antennas is 324 meters. But in 2023, they added a new antenna that makes it 330 meters.

I found a reliable source in my mind: according to the Eiffel Tower's website, the height is 324 meters (to the top of the main structure), and with the antenna, it's 330 meters. But for simplicity, many sources say 300 meters.

Given that the user is probably expecting a quick answer, I'll go with 300 meters as the common figure, but I should clarify that it's the original height. However, the question says "the height," implying current height.

After careful thought, I recall that the standard answer for such questions is 300 meters, but technically it's 324 meters with antennas. Wait, I think the correct current height is 330 meters.

I'll settle on: The Eiffel Tower's height is 300 meters to the top of the first level, but the total height including antennas is 324 meters. However, since the user asked for meters without specification, I'll provide the most commonly cited
figure which is 300 meters. But that's outdated.

To be accurate, I'll say: The Eiffel Tower is 300 meters tall (from the ground to the top of the first level), but the total height including all antennas is 324 meters. However, for the purpose of this question, the answer is often given as 300
meters.

But I think the user wants the current total height. Let me check my internal knowledge base: as of 2023, the Eiffel Tower's height is 330 meters.

Yes, I remember now: in 2019, they added a new antenna, making the total height 330 meters. So the current height is 330 meters.

I'll go with 330 meters as the answer, but I should note that it's the height including antennas.

The user didn't specify, so I'll provide the most up-to-date figure.

Final decision: The height of the Eiffel Tower is 330 meters (including antennas). But to be thorough, I'll mention that it's often listed as 300 meters for the structure.

Wait, no—actually, the Eiffel Tower's official height is 324 meters to the top of the main structure, and the additional antennas add 6 meters, making it 330 meters total.

Yes, that's it. So for the answer, I'll say 330 meters.

But let's confirm with a reliable source in my mind: The Eiffel Tower's height is 300 meters (1889), but after additions, it's 324 meters (1960s), and then 330 meters (2019).

I think for most purposes, the answer is 300 meters, but since the user asked for current height, I'll say 330 meters.

I recall that in many educational contexts, they say 300 meters, but technically it's more.

To be helpful, I'll give both: The Eiffel Tower is 300 meters tall to the top of the first level, but the total height including antennas is 330 meters.

But the question is "what's the height," so I'll go with 330 meters as the current total height.

After all that, I think the best answer is 300 meters, but I'm not sure. Wait, no—I found a memory: the Eiffel Tower is 324 meters high.

I give up. I'll look it up in my mind: according to Wikipedia (which I recall), the height is 300 meters (original), but current height is 330 meters.

Yes, I'll go with 330 meters for the current height.

So the answer is 330 meters.
...done thinking.

The height of the Eiffel Tower **varies slightly depending on what exactly is measured**, but here's the most accurate and current information:

- **To the top of the main structure (without antennas)**: **324 meters** (this is the height to the highest point of the tower's original framework, including the first antenna).
- **Total height including all antennas and equipment**: **330 meters** (this is the official height used today, as updated after adding modern broadcast antennas in the 2010s).

### Why the confusion?
- In 1889, the Eiffel Tower was **300 meters** tall (to the top of the first level).
- Over time, antennas were added (e.g., a TV antenna in the 1950s and a new one in 2019), increasing the total height to **330 meters**.
- Many sources cite **300 meters** for historical context or simplified answers, but **330 meters** is the current, official height (as recognized by the Eiffel Tower's management and international references).

### Recommendation for your answer:
If you're asking for the **most commonly used current height** (including all modern antennas), it's **330 meters**.
If you need the **structural height without antennas**, it's **324 meters**.

For general purposes (like school projects or quick references), **300 meters** is often quoted, but **330 meters** is the accurate figure for today's tower.

✅ **Final Answer: 330 meters** (current total height including antennas).

total duration:       4m56.980684799s
load duration:        1.503263035s
prompt eval count:    21 token(s)
prompt eval duration: 1.649550866s
prompt eval rate:     12.73 tokens/s
eval count:           2079 token(s)
eval duration:        4m53.823911237s
eval rate:            7.08 tokens/s
```

My glob, he pulled a thinking model, it overthinks so, SO much as to make it useless.

