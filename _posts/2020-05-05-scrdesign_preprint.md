---
title: "Preprint now on bioRxiv: Towards optimal sampling design for SCR"
layout: post
published: true
thumbnail: /images/thumbnails/thumbnail_scrdesign.jpg
use_code: true
---

<i>This preprint represents the work from the first chapter of my Master's thesis.</i>

<center>
  <div>
    <img src="{{ site.baseurl }}/images/banners/banner_slVis.png" style="width:100%;">
  </div>
</center>

<br>

## Towards optimal sampling design for SCR

After lots of time coding & writing, our preprint on optimal sampling design for SCR is now live!

[some image]

Motivation: In reality, landscapes are logistically challenging to sample, and pre-existing design heuristics don't easily apply.

Solution: We propose a genetic algorithm to optimize any sensible, criteria-based objective function to produce near-optimal sampling designs.

<center>
  <img src="https://pbs.twimg.com/media/EV74eRaXkAAgf_K?format=jpg&name=4096x4096" alt="Figure 1: Optimal designs tested" style="width:25vw;">
</center>

<br>

Our approach, implemented in `oSCR`, explicitly incorporates information about a species of interest & logistic constraints, bringing clarity & flexibility to decision-making for SCR design generation.

<center>
  <img src="https://pbs.twimg.com/media/EV75VOdXsAA51Z_?format=jpg&name=4096x4096" alt="Figure 2: Design generation code" style="width:40vw;">
</center>

<br>

We generated ‘optimal’ designs using the algorithm and evaluated them, via simulation, across a set of realistic constraints, including variation in: effort, study area shape, and density pattern.

<center>
  <img src="https://pbs.twimg.com/media/EV75P5hXsAAJeQB?format=jpg&name=4096x4096" alt="Figure 3: Examples of tested landscapes" style="width:25vw;">
</center>

<br>

Bottom line: our designs perform as well as existing recommendations, but with far more flexibility to be applied in any landscape, and further, they appear robust to spatial variation in density. 

<center>
  <img src="https://pbs.twimg.com/media/EV75ZhqXkAAzKG8?format=jpg&name=4096x4096" alt="Figure 4: Simulation results" style="width:25vw;">
</center>

We hope that by developing this tool and making it freely available and easy to use, SCR studies will be better designed, allowing researchers, practitioners, and managers to make the most of their resources, and in turn, improve their monitoring efforts!

