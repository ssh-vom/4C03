#import "@preview/shadowed:0.3.0": shadow

// --- Colors ---
#let c-ink        = rgb("#24292e")
#let c-muted      = rgb("#586069")
#let c-rule       = rgb("#eaecef")
#let c-code-bg    = rgb("#f6f8fa")
#let c-code-bord  = rgb("#d1d5da")

// Terminal/Dark Mode Colors
#let c-term-bg    = rgb("#0d1117")
#let c-term-head  = rgb("#161b22")
#let c-term-bord  = rgb("#30363d")
#let c-term-shad  = rgb("#00000044")

// Callout Colors
#let c-obj-bg     = rgb("#f1f8ff")
#let c-obj-bord   = rgb("#0366d6")
#let c-obj-text   = rgb("#005cc5")

#let c-res-bg     = rgb("#f0fff4")
#let c-res-bord   = rgb("#28a745")
#let c-res-text   = rgb("#22863a")

// --- Document Variables ---
#let course     = "COMPSCI 4C03: Computer Networks"
#let assignment = "Assignment 2: Peer-to-Peer File Synchronizer"
#let instructor = "Prof. Rong Zheng"
#let author     = "Shivom Sharma"
#let student_id = "400332395"

// --- Page Setup ---
#set page(
  paper: "us-letter",
  margin: (top: 1in, bottom: 1in, left: 1in, right: 1in),
  header: [
    #set text(size: 9pt, fill: c-muted, font: "Fira Sans")
    #grid(columns: (1fr, auto), align(left)[#assignment], align(right)[#author])
    #v(0.2em)
    #line(length: 100%, stroke: 0.5pt + c-rule)
  ],
  footer: context [
    #set text(size: 9pt, fill: c-muted, font: "Fira Sans")
    #align(center)[— #counter(page).display() —]
  ]
)

// --- Typography ---
#set text(font: "Fira Sans", size: 11pt, fill: c-ink)
#set par(justify: true, leading: 0.7em, spacing: 1.2em)
#set heading(numbering: "1.")

// --- Heading Styles ---
#show heading: set text(font: "Fira Code")

#show heading.where(level: 1): it => {
  v(2em)
  text(size: 16pt, weight: "bold")[#it]
  v(0.4em)
  line(length: 100%, stroke: 1pt + c-rule)
  v(1em)
}

#show heading.where(level: 2): it => {
  v(1.5em)
  text(size: 13pt, weight: "bold", fill: c-ink)[#it]
  v(0.6em)
}

#show heading.where(level: 3): it => {
  v(1em)
  text(size: 11.5pt, weight: "bold", fill: c-muted)[#it]
  v(0.4em)
}

// --- Code Blocks ---
#show raw: set text(font: "IBM Plex Mono", size: 8.5pt)
#show raw: set par(leading: 0.6em, justify: false)

#show raw.where(block: true): it => {
  v(0.5em)
  block(
    fill: c-code-bg,
    stroke: 1pt + c-code-bord,
    inset: (x: 12pt, y: 10pt),
    radius: 4pt,
    width: 100%,
    breakable: true,
  )[#it]
  v(0.5em)
}

// --- Helper Functions ---
#let test_code(file_path, lang: "python") = raw(
  read(file_path), lang: lang, block: true,
)

#let macos_dots() = [
  #box(circle(radius: 3.5pt, fill: rgb("#ff5f56"))) #h(3pt)
  #box(circle(radius: 3.5pt, fill: rgb("#ffbd2e"))) #h(3pt)
  #box(circle(radius: 3.5pt, fill: rgb("#27c93f")))
]

#let evidence_figure(path, cap) = {
  v(1em)
  figure(
    shadow(dx: 0pt, dy: 6pt, blur: 14pt, fill: c-term-shad)[
      #block(
        fill: c-term-bg,
        stroke: 1pt + c-term-bord,
        radius: 6pt,
        width: 100%,
        clip: true,
      )[
        // Fake Terminal Header
        #block(
          fill: c-term-head, 
          width: 100%, 
          inset: (x: 10pt, y: 8pt), 
          stroke: (bottom: 1pt + c-term-bord)
        )[
          #macos_dots()
        ]
        // The Screenshot
        #block(inset: 2pt)[#image(path, width: 100%)]
      ]
    ],
    caption: cap,
  )
  v(1em)
}

#let test_case_block(title: content, objective: content, design: content, results: content) = [
  #heading(level: 2, numbering: none)[#title]
  #v(0.5em)
  
  #grid(
    columns: (1fr),
    row-gutter: 1.2em,
    
    // Objective Box
    block(
      fill: c-obj-bg,
      stroke: (left: 4pt + c-obj-bord),
      inset: (x: 1.2em, y: 1em),
      width: 100%,
      radius: (right: 3pt),
    )[
      #text(weight: "bold", fill: c-obj-text)[Objective:] #h(0.2em)
      #text(fill: c-ink)[#objective]
    ],
    
    // Design Body
    block[
      #text(weight: "bold", size: 11.5pt, font: "Jetbrains Mono NL")[Test Design]
      #v(0.5em)
      #design
    ],
    
    // Results Box
    block(
      fill: c-res-bg,
      stroke: (left: 4pt + c-res-bord),
      inset: (x: 1.2em, y: 1em),
      width: 100%,
      radius: (right: 3pt),
    )[
      #text(weight: "bold", fill: c-res-text)[Results:] #h(0.2em)
      #text(fill: c-ink)[#results]
    ]
  )
  #v(1.5em)
]

// ── Document Body ────────────────────────────────────────────────────────────

#align(center)[
  #v(2em)
  #text(size: 22pt, weight: "bold", font: "IBM Plex Sans")[#assignment]
  #v(0.8em)
  #text(size: 14pt, fill: c-muted)[#course]
  #v(1.5em)
  #line(length: 60%, stroke: 1pt + c-rule)
  #v(1.5em)
  #block[
    #text(size: 13pt, weight: "bold")[#author] \
    #v(0.4em)
    #text(size: 11pt, fill: c-muted)[Student ID: #student_id] \
    #v(0.8em)
    #text(size: 11pt, fill: c-muted)[Instructor: #instructor]
  ]
  #v(3em)
]
#outline()


= Test Cases and Results

This document aims to summarize the methodology that I followed to design my
test cases to ensure that the code was working in the proper manner
end-to-end. I utilized my tmux windows to run the code with multiple peers,
and also utilized the unittest framework for python to test code where it made
sense to.
#evidence_figure("assets/end-to-end.png", "End-to-end terminal test setup")

#pagebreak()

#test_case_block(
  title: [1. Local File Info (get_file_info)],
  objective: [Verify that get_file_info() returns the expected local file metadata.],
  design: [
    I create a temporary test.txt file, then call get_file_info(), and verify that the file appears in the returned structure. The file is removed during cleanup so the test is repeatable.
    #test_code("../test_get_file_info.py")
  ],
  results: [
    The test passes confirming the file format matches.
  #evidence_figure(
    "assets/test_get_file_info.png",
    "get file info test passing",
  ) 
],
)

#v(1.5em)

#test_case_block(
  title: [2. Next Available Port (get_next_avaliable_port)],
  objective: [Verify that the peer selects the next free port when preferred port is occupied.],
  design: [
    The tracker and peer were both started with port 8000 on the same host, to see if the next sequential port 8001 was used.
  ],
  results: [
    We can see that the perr binds to port 8001 in the terminal screenshot.
    #evidence_figure("assets/test_next_avilable_port.png", "Peer selects next available port when initial port is occupied")
  ],
)

#pagebreak()

#test_case_block(
  title: [3. Initialization (\_\_init\_\_)],
  objective: [Verify correct initialization of FileSynchronizer state and sockets.],
  design: [
    I instantiated FileSynchronizer with known arguments and asserted key fields and socket setup values.
    #test_code("../test_init.py")
  ],
  results: [
    We can see the assertions passing with the test, meaning the initialization has the proper expected values listed in the test code.
    #evidence_figure("assets/test_init_success.png", "Initialization test output")
  ],
)

#pagebreak()

#test_case_block(
  title: [4. Serving Files (process_message)],
  objective: [Verify that process_message() returns the requested file with the expected Content-Length header.],
  design: [
    I spun up a socket client and server interaction. The client sends "test.txt\\n"; the server processes it via process_message(), then responds with Content-Length plus file bytes.
    #test_code("../test_process_message.py")
  ],
  results: [
    The client receives the correct header format and exact file content. We are able to see that it parses the exact \<size\> bytes.
    #evidence_figure("assets/test_process_message_result.png", "process_message() returns header and file payload")
  ],
)

#pagebreak()

#test_case_block(
  title: [5. Discovering and Retrieving Files (sync)],
  objective: [Verify that sync() discovers missing files and retrieves them from peers.],
  design: [
    Three peers start with different files (FileA.txt, FileB.txt, FileC.txt). After connecting with the tracker, and starting up, the peers should 
  sync and then have the same files with all the same data. We test this using the cat command, as well as ls.
    #evidence_figure("assets/original_file_setup_each_peer.png", "Initial file setup for each peer")
    #evidence_figure("assets/file_discovery_and_download.png", "Discovered and downloading")
  ],
  results: [
  The final directory shows that the content matches in each peer.
    #evidence_figure("assets/sync_result_discover_and_retrieve.png", "All content matches")
  ],
)

#pagebreak()

#test_case_block(
  title: [6. Overwriting Outdated Files (sync)],
  objective: [Verify that sync() overwrites an older local copy when a newer peer version exists.],
  design: [
    Peer A and Peer B start with the same filename but different content and mtimes. Peer A holds the newer version. Peer B runs sync() using a tracker response that points to Peer A as the latest source.
    #test_code("../test_sync_overwrite.py")
  ],
  results: [
    Peer B's file content is replaced with Peer A's content, and Peer B's file mtime is updated to the newer timestamp.
  #evidence_figure("../assets/overwrite_result.png", "Overwriting result with sync()")
  ],
)

#pagebreak()

#test_case_block(
  title: [7. Failure Handling],
  objective: [Verify graceful behavior under tracker/peer timeout or disconnect scenarios.],
  design: [
    I tested two major cases in this section, the first being a peer disconnecting during file transfer, ensuring
    that there were no partial files leftover and that there was a graceful exit. The second case being a check
    to see if tracker failure occurred properly on timeout.
    #test_code("../test_failure_peer_disconnect.py")
    #test_code("../test_failure_tracker_timeout.py")
  ],
  results: [
    We can see that the test passes, where we don't leave any partial traces and tracker failure properly occurs.
  #evidence_figure("../assets/peer_disconnect_test.png", "Peer disconnect partway result")
  #evidence_figure("../assets/tracker_failure_test.png", "Tracker failure test result")
  ],
)
