#import "@local/templates:0.2.3": assignment

#let homework-num = sys.inputs.at("hw-number", default: 11)
#let is-numeric(n) = type(n) == int or type(n) == float or regex("\\d+") in n

#show: assignment.with(
  title: if is-numeric(homework-num) {
    "Assignment #" + str(homework-num)
  } else { homework-num },
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

#set raw(theme: "evergarden-winter.tmTheme")
#show raw.where(block: true): it => block(
  fill: rgb("#1e2528"),
  inset: 8pt,
  radius: 5pt,
  text(fill: rgb("#f8f9e8"), it),
)

#if is-numeric(homework-num) {
  let num-str = str(homework-num)
  include (
    "homework/hw-"
      + if homework-num < 10 { "0" + num-str } else { num-str }
      + ".typ"
  )
} else {
  include "homework/" + lower(homework-num).replace(" ", "-") + ".typ"
}
