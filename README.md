MOOCchat
========

MOOCchat is a SaaS app for integrating peer learning/peer discussion
into MOOCs and similar settings.

This document gives an overview of how to set up experiments/activities
with MOOCchat.  Partial URLs are given for all paths, so that if the
app is hosted on `http://moocchat.herokuapp.com`, the path
`/tasks/welcome` refers to `http://moocchat.herokuapp.com/tasks/welcome`.

## Data Model and Terminology

User Roles:

* A Learner is a person in a course who participates in peer instruction
activities.  
* A Cohort is a group of learners, e.g., the enrollees in a course.  A
learner can belong to multiple cohorts.
* An Instructor is an instructional staff member or researcher who sets
up peer instruction activities and can also do anything a Learner can do
(for example, test-drive an activity).
* An Administrator administers the use of the system and can also do
everything that Learners and Instructors can do.

Objects:

* A Question is an opportunity for a learner to respond to something,
via multiple choice, open ended text, or whatever.
* An Activity Schema is a list of Questions that may feature some peer
instruction, for example, a quiz review session.
* A Condition describes how a learner or group of learners interacts
with an Activity Schema (set of questions).  The Condition consists of a
set of page views based on Templates.  Specifically, a condition
consists of a sequence of zero or more prologue pages, a sequence of one
or more body pages that is repeated for each question in the Activity
Schema, and a sequence of zero or more epilogue pages.

## Creating Templates

Templates should be complete legal HTML 5 pages.

At the moment, we store the raw HTML of the pages verbatim, so you can
author your templates in whatever environment you want and then
cut-and-paste the HTML.

To see a list of existing templates and a skeletal UI for creating new ones by
copying and pasting raw HTML, visit `/templates`.

You can incorporate inline CSS styles in the template, or use a `<link>`
element to point to an external stylesheet.

### Displaying a question and answer choices

Templates are processed through `erb`, which allows the values of Ruby
variables and expressions to be interpolated into the HTML.  
The `erb` notation for
interpolating the result of evaluating the Ruby expression `expr`
is `<%= expr %>`.  Ruby instance variable
names begin with `@`.

Below is a line-numbered example of the `<body>` of a template keyed to
the following explanation.

(1) `@submit_to` - the URL for form submission that will cause the next page
in the sequence to be displayed.  See the next subsection on Learner
Navigation.  Example: `<form action="<%= @submit_to %>">` will
generate something like `<form action="/tasks/32/next_page">`.  Do not
try to construct the submit URL manually.

(3) `@question` is the text of the current question.  

(10) `@answers` is an array of strings representing the possible
answers; you can iterate over it with `each`.  `@correct_answer_index`
is the zero-based index of which answer is the correct one.

(11, 18) The variable `@u` is a hash
that stores any user-defined state information associated with *this
learner*; you can name elements of this hash in your forms to cause data
to be collected or displayed.  *Only* form fields named `u[...]` will be
persisted and logged.  

(21) If the hidden form field `next_question` is present and has any nonblank
value, the question counter will be advanced so that the next page in
the flow will consume a new question.  You use this if a single pass
through the activity involves answering more than one question, for
example, a basic question followed by a transfer question.

(23) `timer(sec)` is a macro that creates a JavaScript countdown timer
initialized to `sec` seconds, and starts counting it down.  The macro
provides only the text.  When the timer reaches zero, it will cause the
form-submit button on the page's single form to be "clicked".  


```
  1 <form action="<%= @submit_to %>">
  2   <!-- display current question and answer choices -->
  3   <div class="question">
  4     <div class="questionText"> 
  5       <%= @question %>
  6     </div>
  7     <p>Select the best answer:</p>
  8     <div class="answers">
  9       <!-- capture learner's answer as choice number, 0..n-1  -->
 10       <% @answers.each_with_index do |answer, index| %>
 11         <input type="radio" value="<%= index %>" name="u[response]"> <%= answer %>
 12       <% end %>
 13     </div>
 14   </div>
 15   <!-- collect free-text explanation from learner -->
 16   <div class="explanation">
 17     <p>Please explain your answer (will be seen by instructor)</p>
 18     <input type="textarea" name="u[explanation]"> <br>
 19   </div>
 20   <!-- make future pages in flow show next question -->
 21   <input type="hidden" name="next_question" value="true">
 22   <!-- 5-minute timer and submit button -->
 23   <%= timer(300) %>
 24   <input type="submit" value="Ready to Continue">
 25 </form>
```

### Showing a chat room and/or showing other learners' responses

(3) `@data` is an *array of hashes*, where each element is a hash of
one learner's user data (collected by form fields named
`u[...]`).  Here it's used to display what answers and explanations the
other learners gave; its keys are the same as those of `u[...]`.  

(4) `@me` is the index of the array corresponding to *this* learner.
`@u['foo']` is therefore a synonym for `@data[@me]['foo']`.  *BUT
(important)* to *persist* collected data, you must use form fields named
`u[...]`.

(8) `chat()` is a macro that creates a chatroom.  (It listens to the
channel whose name is the value of the `@chat_group` variable.)  


```
  1 <form action="<%= @submit_to %>">
  2   <p>Here are the answers your peers gave:</p>
  3   <% @data.each_with_index do |other, index| %>
  4     <% next if index == @me %>
  5     <p>Student <%= index %> selected choice <%= other['response'] %> because:</p>
  6     <p> <%= other['explanation'] %>
  7   <!-- chat room -->
  8   <p>Please discuss your answer with others</p>
  9   <div id="chat"> <%= chat() %> </div>
 10   <%= timer(300) %>  <input type="submit" value="Request to end chat">  
```

### Learner experience of template flow

When a template is first displayed to the learner, any element with id
`interstitial` is first hidden. 

Each template must contain exactly one form with exactly one Submit
button.  When that button is pressed, the `interstitial` element is
revealed, and should display a message to the effect that "You'll
proceed to the next step as soon as all learners in your group are
ready."  You can use CSS to reveal a `<div>`, float the element in a
lightbox, or whatever.  

The page will then background-poll the server until all learners have
pressed the button, at which point all learners will be advanced to the
next template page.

If the template also displays a timer, the expiration of the timer will
cause the form to be submitted automatically.  The timer has no other
special functionality.

In either case, once all learners in a given chat group have submitted
their forms (either explicitly or by expiration of timers), the group as
a whole will be served the next page in the flow.

As described above, the presence of the `next_question` hidden form
element determines whether the next usage of `@question` (and its
corresponding `@answers`) will use the same question or a new one.  The
body portion of the condition will be repeated while questions remain.

### Additional template elements

These will be less frequently used but are listed here for completeness.

* `@task_id` - an identifier for a data structure that associates a
specific Learner, Condition, and Activity Schema, and stores all state
related to that learner.  Useful to display for debugging purposes.
* `@counter` - an integer tracking the page number in the overall
activity, starting from 1 for the first prologue page.  For example, a
task with 1 prologue page, 2 epilogue pages, and a 4-page sequence for
each of three questions has 1+2+(3*4)=15 total pages, so counter values
will range from 1 to 15.
* `@subcounter` - a *zero-based* counter tracking the page number within
the current 
sequence (prologue, body, epilogue).  E.g., for the
preceding example, its successive values would be 0, 0,1,2,3, 0,1,2,3,
0,1,2,3, 0,1.
* `@where` - one of the three strings `prologue`, `body`, or `epilogue`,
indicating where we are in the current condition.  Can be used, e.g., in
conjunction with `@subcounter` and/or `@task_id` to style page elements
accordingly by giving them CSS classes based on these variables' values,
as in `<body class=<%= @where + "-" @subcounter %>>', giving class names
such as `prologue-0`, `body-2`, etc.
* `@chat_group` - a string that identifies the chat group this
learner is in; think of it as a channel.  If empty, it means the learner
has not yet been assigned to a group.