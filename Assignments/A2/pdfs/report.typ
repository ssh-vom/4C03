#import "@preview/shadowed:0.3.0": shadow

// ── Gruvbox Dark palette ──────────────────────────────────────────────────────
#let gb-bg0-hard  = rgb("#1d2021")   // darkest background
#let gb-bg0       = rgb("#282828")   // main background
#let gb-bg1       = rgb("#3c3836")   // raised surface / card bg
#let gb-bg2       = rgb("#504945")   // subtle border / divider
#let gb-bg4       = rgb("#7c6f64")   // muted elements
#let gb-fg        = rgb("#ebdbb2")   // primary foreground
#let gb-fg2       = rgb("#d5c4a1")   // secondary foreground
#let gb-red       = rgb("#cc241d")
#let gb-red-bright= rgb("#fb4934")
#let gb-green     = rgb("#98971a")
#let gb-green-bright=rgb("#b8bb26")
#let gb-yellow    = rgb("#d79921")
#let gb-yellow-bright=rgb("#fabd2f")
#let gb-blue      = rgb("#458588")
#let gb-blue-bright=rgb("#83a598")
#let gb-purple    = rgb("#b16286")
#let gb-purple-bright=rgb("#d3869b")
#let gb-aqua      = rgb("#689d6a")
#let gb-aqua-bright=rgb("#8ec07c")
#let gb-orange    = rgb("#d65d0e")
#let gb-orange-bright=rgb("#fe8019")
// ─────────────────────────────────────────────────────────────────────────────

#set page(
  paper: "us-letter",
  margin: (top: 0.5in, bottom: 0.5in, left: 0.75in, right: 0.75in),
  fill: gb-bg0,
)

#set text(font: "IBM Plex Sans", size: 11pt, hyphenate: false, fill: gb-fg)

#show heading.where(level: 1): it => text(fill: gb-yellow-bright, weight: "bold")[#it]
#show heading.where(level: 2): it => text(fill: gb-aqua-bright,   weight: "bold")[#it]
#show heading.where(level: 3): it => text(fill: gb-green-bright,  weight: "bold")[#it]

#show strong: it => text(fill: gb-orange-bright, weight: "bold")[#it.body]

#set heading(numbering: "1.")
#set par(justify: true, spacing: 1.2em, leading: 0.75em)
#show raw: set par(leading: 0.55em, spacing: 0.65em, justify: false)
#show raw.where(block: true): it => block(
  fill: gb-bg0-hard,
  stroke: 1pt + gb-bg2,
  inset: (x: 12pt, y: 10pt),
  radius: 4pt,
  width: 100%,
)[#text(font: "IBM Plex Mono", size: 8.5pt, fill: gb-fg2)[#it]]

// Project Details
#let course = "COMPSCI 4C03: Computer Networks"
#let assignment = "Assignment 2: Peer-to-Peer File Synchronizer"
#let instructor = "Instructor: Prof. Rong Zheng"
#let author = "Name: Shivom Sharma"
#let student_id = "Student ID: 400332395"
#let test_code(file_path, lang: "python") = {
  v(0.3em)
  raw(read(file_path), lang: lang, block: true)
}

// Block for structuring test cases according to grading rubric
#let test_case_block(title: str, objective: str, design: content, results: content) = {
  return block(
    width: 100%,
    stroke: 1.5pt + gb-bg2,
    inset: 12pt,
    fill: gb-bg1,
    radius: 6pt,
    breakable: true
  )[
    #text(weight: "bold", size: 12pt, fill: gb-yellow-bright)[#title] \
    #v(0.5em)
    #text(fill: gb-orange-bright, weight: "bold")[Objective: ]
    #text(objective, font: "IBM Plex Serif", size: 10pt, fill: gb-fg2) \
    #v(0.8em)
    #text(fill: gb-orange-bright, weight: "bold")[Test Design:] \
    #block(inset: (left: 10pt))[
      #text(fill: gb-fg)[#design]
    ]
    #v(0.8em)
    #text(fill: gb-orange-bright, weight: "bold")[Results:] \
    #block(inset: (left: 10pt))[
      #text(fill: gb-fg)[#results]
    ]
  ]
}

#align(center)[
  #text(size: 20pt, weight: "semibold", fill: gb-yellow-bright)[#assignment]
  #v(0.2em)
  #text(size: 12pt, weight: "medium", fill: gb-aqua-bright)[#course]
  #v(0.4em)
  #text(size: 10pt, fill: gb-fg2)[#author] \
  #text(size: 10pt, fill: gb-fg2)[#student_id] \
  #text(size: 10pt, fill: gb-fg2)[#instructor] \
]

#v(2em)
#figure(
  shadow(dx: 0pt, dy: 0pt, blur: 2pt, fill: gb-bg0-hard, spread: -2pt)[
    #image("assets/end-to-end.png", width: 100%)
  ], caption: [End to End Terminal Test Setup])
= Test Cases and Results
#block(
  fill: gb-bg1,
  stroke: 1.5pt + gb-yellow,
  inset: 8pt,
  radius: 4pt,
)[
  #text(fill: gb-yellow-bright, weight: "bold")[Note: ]
  #text(fill: gb-fg2)["This report documents the test cases and their execution results verifying the requirements of the File Synchronizer assignment based on the provided rubric."]
]

#pagebreak()

#test_case_block(
  title: "1. Local File Info (`get_file_info`)",
  objective: "Verify that the `get_file_info()` method correctly returns file information in the local directory.",
  design: [
    The test was designed to create a test file, while checking to see if we get the right data shape, removing the file once we are done.
    #test_code("../test_get_file_info.py")
  ],
  results: [

    The results show that the tests passed for the 
    
    // #figure(
    //   image("assets/get_file_info_result.png", width: 100%), caption: [get_file_info() Output],
    // ) <fig-get_file_info_result>
  ]
)
#pagebreak()

#v(1em)

#test_case_block(
  title: "2. Next Available Port (`get_next_available_port`)",
  objective: "Verify that the `get_next_available_port()` method correctly returns the next available port for the peer.",
  design: [
  I ran a peer and the tracker on the same port 8000, to see if the next available port is grabbed
    Describe how you tested port allocation. For example, testing sequential port binding or simulating ports already in use.
  ],
  results: [
  The next port in sequential order 8001 was used by the peer, proving that the functionality was
  correct.
  #figure(
    shadow(dx: 0pt, dy: 0pt, blur: 2pt, fill: gb-bg1, spread: -2pt)[
      #image("assets/test_next_avilable_port.png", width: 100%)],
    caption: [Results of running with same port],
  ) <fig-get_next_available_port>
],
)
#pagebreak()

#v(1em)

#test_case_block(
  title: "3. Initialization (`__init__`)",
  objective: "Verify the complete initialization of the `FileSynchronizer` class.",
  design: [
    For this test I scaffolded the project to initial a FileSynchronizer object and ran the passing
  test with asserts for the expected values.
    #test_code("../test_init.py")
  ],
  results: [

  We can see in the image below the test passes successfully ensuring we match the properties.
  #figure(
    shadow(dx: 0pt, dy: 0pt, blur: 2pt, fill: gb-bg0-hard, spread: -2pt)[
      #image("assets/test_init_success.png", width: 100%)
    ], caption: [Initialization test success])
]
)

#pagebreak()

#test_case_block(
  title: "4. Serving Files (`process_message`)",
  objective: "Verify that `process_message()` properly returns the requested file with the correct header to a peer.",
  design: [
    Detail how you simulated a peer requesting a specific file. Explain the structure of the request message you sent and how the peer is expected to handle it.

  #test_code("../test_process_message.py")
  ],
  results: [
    Confirm that the receiving peer got the correct file content along with the expected HTTP-like response headers.

  #figure(
    shadow(dx: 0pt, dy: 0pt, blur: 2pt, fill: gb-bg0-hard, spread: -2pt)[
      #image("assets/test_process_message_result.png", width: 100%)
    ], caption: [process message test success])
  ]
)

#v(1em)

#test_case_block(
  title: "5. Discovering and Retrieving Files (`sync`)",
  objective: "Verify that `sync()` discovers and retrieves new files from other peers.",
  design: [
    For this test, what I did was creating a peer1/ , peer2/, and peer3/ directory, each with their own
  respective file: "FileA.txt", "FileB.txt", and "FileC.txt". Then when connecting the new peer we can see 
  the to show this works then, we can demonstrate that each pair ends up with all the files.
  #figure(
    image("assets/original_file_setup_each_peer.png", width: 100%),
    caption: [],
  ) <fig-original_file_setup_each_peer>

  #figure(
    image("assets/file_discovery_and_download.png", width: 100%),
    caption: [],
  ) <fig-file_discovery_and_download>

],
  results: [
    We can see in the images below that this occurs, each file is there and has the same metadata at the end.
  #figure(
    image("assets/sync_result_discover_and_retrieve.png", width: 100%),
    caption: [],
  ) <fig-sync_result_discover_and_retrieve>

  ]
)

#v(1em)

#test_case_block(
  title: "6. Overwriting Outdated Files (`sync`)",
  objective: "Verify that `sync()` overwrites a local file if a newer version exists on another peer.",
  design: [
  #test_code("../test_sync_overwrite.py")
    This test involves setting up two peers and the server in a test script
  ],
  results: [
    Provide evidence that the file was updated on Peer B, matching Peer A's content and timestamp.
  ]
)

#v(1em)

#test_case_block(
  title: "7. Failure Handling",
  objective: "Verify that the implementation gracefully handles tracker and peer timeout/failure scenarios.",
  design: [
    Detail the tests for connection timeouts or unexpected drop-offs. Examples: terminating the tracker unexpectedly, or terminating a peer midway through a request.
  ],
  results: [
    Show that the peer logs the failure and continues running without a fatal crash or handles the exception cleanly.
  ]
)
