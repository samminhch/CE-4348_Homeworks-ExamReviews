#import "@local/callouts:0.1.0": question

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