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

To see a list of existing templates and a UI for creating new ones by
copying and pasting raw HTML, visit `/templates`.

### CSS

You can incorporate inline CSS styles in the template, or use a `<link>`
element to point to an external stylesheet.

### Special variables in templates

Templates are processed through `erb`, which allows the values of Ruby
variables and expressions to be interpolated into the HTML.  
The `erb` notation for
interpolating a value is `<%= expression %>`.  Ruby instance variable
names begin with `@`, so to interpolate the value of variable `@name`,
your markup might look like this:

```html
<p class="greeting">Hello, <%= @name %>! </p>
```

The following variables are available in a template.  Identifiers
without `@` are actually method calls that dynamically generate a value.

* `@submit_to` - the URL for form submission that will cause the next page
in the sequence to be displayed.  See the next subsection on Learner
Navigation. 
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
* `@u` - a hash (associative array) containing any state you want to
store.  See Learner Navigation.

### Learner Navigation

FIXME: the following is a PROPOSAL for how this should work, since not
all of this is implemented yet!!

Each page served to the learner must provide the learner a control to
advance to the next page.  This control can be selectively enabled under
the control of a timer, to enforce spending a minimum or maximum amount
of time on a page.

Interpolating `<%= submit(text,min,max) %>` generates a "go to next
step" control with the following properties:

* `text` is a single or double quoted string for the text that will
appear in the button (if omitted, name is "Continue")
* The button will be inactive until `min` seconds have elapsed (if
omitted, assumed to be zero)
* The form will be automatically be submitted after `max` seconds if the
learner hasn't pressed the button (if omitted, assumed to be 5 minutes)
* The button's element ID is `submit`; this is used by the timer logic below.

Interpolating `<%= countdown_from(seconds) %>` where `seconds` is an
integer displays a JavaScript-based timer in that location on the page
whose behavior is connected to the above button (by referencing its
element ID of `submit`).

(TBD: info about CSS class of timer element(s) for styling)

