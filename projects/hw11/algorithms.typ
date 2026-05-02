#let lru(refs, frame-size) = {
  let timeline = ()
  let faults = range(refs.len()).map(_ => false)
  for (index, ref) in refs.enumerate() {
    // The last value is the most recently used, the first is least used
    let current-frames = if index == 0 { () } else { timeline.at(index - 1) }

    if ref in current-frames {
      // Move the page to be the most-recently used
      let _ = current-frames.remove(current-frames.position(f => f == ref))
    } else {
      // There's a fault!
      faults.at(index) = true
      // Evict the least-recently used reference
      if current-frames.len() == frame-size {
        let _ = current-frames.remove(0)
      }
    }
    current-frames.push(ref)

    timeline.push(current-frames)
  }
  (timeline: timeline, faults: faults)
}

#let fifo(refs, frame-size) = {
  let timeline = ()
  let faults = range(refs.len()).map(_ => false)
  for (index, ref) in refs.enumerate() {
    // The last value is the most recently used, the first is least used
    let current-frames = if index == 0 { () } else { timeline.at(index - 1) }

    if ref not in current-frames {
      faults.at(index) = true
      if current-frames.len() == frame-size {
        let _ = current-frames.remove(0)
      }
      current-frames.push(ref)
    }

    timeline.push(current-frames)
  }
  (timeline: timeline, faults: faults)
}

#let clock(refs, frame-size) = {
  let timeline = ()
  let faults = range(refs.len()).map(_ => false)

  // Internal state to persist across references
  let current-frames = () // Will store pairs of (page: int, ref-bit: int)
  let pointer = 0

  for (index, ref) in refs.enumerate() {
    let is-fault = false

    // Check if the page is already in memory
    let existing-idx = current-frames.position(f => f.page == ref)

    if existing-idx != none {
      // Hit: Set the reference bit to 1
      current-frames.at(existing-idx).ref-bit = 1
    } else {
      // Miss: Page Fault
      is-fault = true
      faults.at(index) = true

      if current-frames.len() < frame-size {
        // Space available: Just add the page with ref-bit 1
        current-frames.push((page: ref, ref-bit: 1))
      } else {
        // Memory full: Perform Clock replacement
        let found = false
        while not found {
          if current-frames.at(pointer).ref-bit == 0 {
            // Replace this page
            current-frames.at(pointer) = (page: ref, ref-bit: 1)
            found = true
            // Move pointer for next time
            pointer = calc.rem(pointer + 1, frame-size)
          } else {
            // Give second chance: Clear bit and move pointer
            current-frames.at(pointer).ref-bit = 0
            pointer = calc.rem(pointer + 1, frame-size)
          }
        }
      }
    }

    // Save a snapshot of just the page numbers for the timeline
    timeline.push(current-frames.map(f => f.page))
  }

  (timeline: timeline, faults: faults)
}

#let optimal(refs, frame-size) = {
  let timeline = ()
  let faults = ()
  let current-frames = ()

  for (index, ref) in refs.enumerate() {
    let is-fault = false

    if ref not in current-frames {
      is-fault = true // Page Fault

      if current-frames.len() < frame-size {
        current-frames.push(ref)
      } else {
        // Optimal Logic: Find the page needed furthest in the future
        let future-refs = refs.slice(index + 1)
        let max-dist = -1
        let replace-idx = 0

        for (i, frame) in current-frames.enumerate() {
          let dist = future-refs.position(r => r == frame)

          if dist == none {
            // Page is NEVER used again. Perfect candidate for eviction.
            replace-idx = i
            break // We can't get a distance longer than infinity
          } else if dist > max-dist {
            max-dist = dist
            replace-idx = i
          }
        }

        // Functionally update the frame in place
        current-frames = current-frames
          .enumerate()
          .map(((i, v)) => if i == replace-idx { ref } else { v })
      }
    }

    timeline.push(current-frames)
    faults.push(is-fault)
  }

  (timeline: timeline, faults: faults)
}
