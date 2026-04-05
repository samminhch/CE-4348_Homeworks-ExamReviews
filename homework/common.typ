#import "@local/callouts:0.1.0": question
#import "@preview/codly:1.3.0": *

#let problem(number, body) = [
  #figure(
    kind: "Problem",
    supplement: [Problem],
    numbering: n => number,
    [
      #set align(left)
      #set enum(numbering: "(A)")
      #question(title: [= Problem #number], body)
    ],
  )
  #label("problem:" + str(number))
]
#let code(file, title: auto, title-full: true) = {
  let title = if title == auto {
    if title-full { file } else { file.split("/").last() }
  } else { title }
  codly(header: [#title], header-cell-args: (align: center))
  raw(read(file), lang: file.split(".").last(), block: true)
}
