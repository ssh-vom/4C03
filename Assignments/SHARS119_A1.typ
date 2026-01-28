#set page(
  paper: "us-letter", margin: (top: 1in, bottom: 1in, left: 1in, right: 1in),
)

#set text(font: "IBM Plex Sans", size: 10pt, hyphenate: false)

#set heading(numbering: "1.")
#set par(justify: true, spacing: 1.1em, leading: 1.4em)

#let course = "SHARS119: Computer Networks"
#let assignment = "Assignment 1"
#let due = "Due: Jan 30, 2026"
#let instructor = "Instructor: Prof. Zheng"
#let author = "Name: Shivom Sharma"
#let student_id = "Student ID: 400332395"

#let question_block(number: int, question: str, answer: content) = {
  return block(
    stroke: 1pt, inset: 8pt, fill: rgb(245, 245, 245), radius: 4pt,
  )[
    #strong("Question " + str(number) + ":") #text(question, font: "IBM Plex Serif", size: 9pt)
    #v(0.8em)
    #strong("Answer: ") #answer
  ]
}
#align(center)[
  #text(size: 20pt, weight: "semibold")[#assignment]
  #v(0.2em)
  #text(size: 12pt, weight: "medium")[#course]
  #v(0.4em)
  #text(size: 10pt)[#author]
  #text(size: 10pt)[#student_id]
  #text(size: 10pt)[#instructor]
  #text(size: 10pt)[#due]
]

= Basic HTTP GET/response interaction

#highlight(
  strong("Note: ") + "All answers assume that the favicon.ico requests are ignored.",
)
#question_block(
  number: 1,
  question: "Is your browser running HTTP version 1.0 or 1.1? What version of HTTP is the server running?",
  answer: [
    We can observe based on the image and the response as well as request,
    the client and the server are utilizing HTTP version 1.1.
    
    #figure(
      image("assets/HTTP_Protocol_Version.png", width: 80%), caption: [HTTP Protocol Version from Server and Client],
    ) <fig-http_protocol_version>
  ]
)

#question_block(
  number: 2,
  question: "What is the IP address of your computer? Of the www.cas.mcmaster.ca server?",
  answer: [
    *Computer IP Address*: 192.168.2.17\
    *McMaster University IP Address*: 130.113.68.10
    
    These can be seen in the image below based on the GET request where the source
    is the Computer, and the destination is McMaster.
    
    #figure(
      image("assets/source_destination_ip.png", width: 80%), caption: [Source and Destination IP],
    ) <fig-source_destination_ip>
  ]
)

#question_block(
  number: 3,
  question: "What is the status code returned from the server to your browser?",
  answer: [
    The status code was a 200 OK message.
    
    #figure(
      image("assets/status_code_200_ok.png", width: 80%), caption: [Status code of GET Response],
    ) <fig-status_code_200_ok>
  ]
)
#question_block(
  number: 4,
  question: "When was the HTML file that you are retrieving last modified at the server?",
  answer: [
    The file was last modified on:
    
    #align(center)[
      #box(stroke: 1pt, inset: 3pt)[
        Fri, Jan 16, 2026 20:10:32 GMT
      ]
    ]
    
    #figure(
      image("assets/Last_Modified_Photo.png", width: 80%), caption: [Last Modified],
    ) <fig-last_modified_photo>
  ]
)

#question_block(
  number: 5,
  question: "How many bytes of content are being returned to your browser?",
  answer: [
    #align(center)[
      #box(stroke: 1pt, inset: 3pt)[
        88 Bytes Received
      ]
    ]
    
    #figure(
      image("assets/file_length.png", width: 80%), caption: [File data in bytes],
    ) <fig-file_length>
  ]
)

= The HTTP CONDITIONAL HTTP GET/response interaction

#question_block(
  number: 6,
  question: "How many HTTP GET requests were sent?",
  answer: [
    #figure(
      image("assets/conditional_http.png", width: 80%), caption: [Conditional HTTP GET and Refresh],
    ) <fig-conditional_http>
    
    #figure(
      image("assets/2_get_requests.png", width: 80%), caption: [GET Requests],
    ) <fig-2_get_requests>
    
    There were 2 GET requests sent based on the image above.
  ]
)

#question_block(
  number: 7,
  question: "How many HTTP response messages were received?",
  answer: [
    There were 2 HTTP responses received, 1 from each GET request.
    
    #figure(
      image("assets/2_http_responses.png", width: 80%), caption: [HTTP Responses],
    ) <fig-2_http_responses>
  ]
)

#question_block(
  number: 8,
  question: "If multiple response messages were received, what are the difference between them?",
  answer: [
    The difference between the requests were that the first message responded with a
    200 OK, providing the entire payload, whereas the second request contained a "Not
    Modified" 304 code.
  ]
)

#question_block(
  number: 9,
  question: "If instead of clicking the \"refresh\" button, you re-enter the URL in the browser or simply enter return when the URL is highlighted, answer Q6 – Q8.",
  answer: [
    #figure(
      image("assets/pressing_return.png", width: 80%), caption: [Pressing Enter instead of Refreshing],
    ) <fig-pressing_return>
    
    - Question 6: There was a single GET request sent
    - Question 7: There was a single HTTP response received
    - Question 8: This time there was no secondary no modified response, just the
      single 200 OK response, this means there was only a single request for the
      resource on the initial load, and entering the same link didn't make a new
      request for the content.
  ]
)

= Retrieving Long Documents

#question_block(
  number: 10,
  question: "How many HTTP GET request messages did your browser send? Which packet number in the trace contains the GET message for the Bill or Rights?",
  answer: [
    There was only a single GET request made for the bill of rights.
    
    #figure(
      image("assets/Get_request_bill_of_rights.png", width: 80%), caption: [GET Request for Bill of Rights],
    ) <fig-get_request_bill_of_rights>
    
    The packet number was 104 for the GET request, meaning that is when the request
    packet was sent from.
    
    #figure(
      image("assets/Packet_Number.png", width: 80%), caption: [Packet Number of GET Request],
    ) <fig-packet_number>
  ]
)

#question_block(
  number: 11,
  question: "Which packet number in the trace contains the status code and phrase associated with the response to the HTTP GET request?",
  answer: [
    The packet that carried the status code and phrase was packet 106, this is
    verified since it contains the first [0-1439] bytes of the payload, and the HTTP
    header occurred within the first 17 bytes.
  ]
)

#question_block(
  number: 12,
  question: "What is the status code and phrase in the response?",
  answer: [
    The status code and phrase in the response is a 200 OK
  ]
)

#question_block(
  number: 13,
  question: "How many data-containing TCP segments were needed to carry the single HTTP response and the text of the Bill of Rights?",
  answer: [
    There were 4 separate segments required to carry the message they spanned frame
    106,107,108,111
  ]
)

= HTTP Authentication

#question_block(
  number: 14,
  question: "What is the server's response (status code and phrase) in response to the initial HTTP GET message from your browser?",
  answer: [
    The first request response that can be noted from the GET request is a 401
    Authorization Required.
    
    #figure(
      image("assets/First Request Response.png", width: 100%), caption: [Authentication First Request Response],
    ) <fig-first-request-response>
  ]
)

#question_block(
  number: 15,
  question: "When your browser's sends the HTTP GET message for the second time, what new field is included in the HTTP GET message?",
  answer: [
    In the second image we can see that the request contains an additional field
    named *Authorization* which contains a token that is stored in cleartext encoded
    base64 format, of the username and password.
    
    #figure(
      image("assets/second_request_response.png", width: 80%), caption: [Second Request Response],
    ) <fig-second_request_response>
  ]
)
