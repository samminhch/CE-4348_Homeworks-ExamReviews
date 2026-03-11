#import "@local/templates:0.2.1": assignment

#let homework-num = 6
#show: assignment.with(
  title: if type(homework-num) == int {"Assignment #" + str(homework-num)} else {homework-num},
  course: (
    number: "CE-4348",
    section: "001",
    name: "Operating System Concepts",
  ),
  author: (
    name: "Minh Nguyen",
    email: "mdn220004@utdallas.edu",
  ),
  instructor: (
    name: "Hossein Pedram",
    email: "hossein.pedram@utdallas.edu",
  ),
  styles: (
    title: (fonts: "Calistoga"),
    heading: (size: 0.75em, fonts: "Calistoga"),
    body: (fonts: "Comic Neue"),
    mono: (fonts: "Maple Mono"),
  ),
)

#if type(homework-num) == int {
  include "homework/hw-" + str(homework-num) + ".typ"
} else {
  include "homework/" + lower(homework-num).replace(" ", "-") + ".typ"
}
