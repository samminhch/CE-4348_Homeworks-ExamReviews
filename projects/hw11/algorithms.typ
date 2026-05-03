#let lru(refs, frame-size) = {
  let (timeline, faults, frames) = ((), (), ())

  for ref in refs {
    let hit = ref in frames
    if hit {
      // Re-order: Move hit to the end (most recent)
      frames = frames.filter(f => f != ref) + (ref,)
    } else {
      // Remove the least-recent frame (least-recent)
      if frames.len() >= frame-size { frames = frames.slice(1) }
      frames.push(ref)
    }
    timeline.push(frames)
    faults.push(not hit)
  }
  (timeline: timeline, faults: faults)
}

#let fifo(refs, frame-size) = {
  let (timeline, faults, frames) = ((), (), ())
  for ref in refs {
    let hit = ref in frames
    if not hit {
      if frames.len() >= frame-size { frames = frames.slice(1) }
      frames.push(ref)
    }
    timeline.push(frames)
    faults.push(not hit)
  }
  (timeline: timeline, faults: faults)
}

#let clock(refs, frame-size) = {
  let (timeline, faults, frames, ptr) = ((), (), (), 0)

  for ref in refs {
    let hit-idx = frames.position(f => f.page == ref)
    if hit-idx != none {
      frames.at(hit-idx).ref-bit = 1
      faults.push(false)
    } else {
      faults.push(true)
      if frames.len() < frame-size {
        frames.push((page: ref, ref-bit: 1))
      } else {
        // Step through the clock
        while frames.at(ptr).ref-bit == 1 {
          frames.at(ptr).ref-bit = 0
          ptr = calc.rem(ptr + 1, frame-size)
        }
        frames.at(ptr) = (page: ref, ref-bit: 1)
        ptr = calc.rem(ptr + 1, frame-size)
      }
    }
    timeline.push(frames.map(f => f.page))
  }
  (timeline: timeline, faults: faults)
}

#let optimal(refs, frame-size) = {
  let (timeline, faults, frames) = ((), (), ())

  for (index, ref) in refs.enumerate() {
    let hit = ref in frames
    if not hit {
      if frames.len() < frame-size {
        frames.push(ref)
      } else {
        // Find index with furthest next use
        let future = refs.slice(index + 1)
        let distances = frames.map(f => {
          let pos = future.position(r => r == f)
          if pos == none { float.inf } else { pos }
        })

        // Find the index of the maximum distance
        let replace-idx = distances
          .enumerate()
          // sort the distances
          .sorted(key: it => it.last())
          // get the largest distance
          .last()
          // get the index
          .first()
        frames.at(replace-idx) = ref
      }
    }
    timeline.push(frames)
    faults.push(not hit)
  }
  (timeline: timeline, faults: faults)
}
