---
title: "Preprint now on bioRxiv: Towards optimal sampling design for SCR"
layout: post
published: true
thumbnail: /images/thumbnails/thumbnail_scrdesign.jpg
use_code: true
---
<i>This preprint represents the work from the first chapter of my Master's thesis.</i>

<!--- FOR ALTMETRICS --->
<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>

<!--- Banner --->
<div class="row">
  <!--- Paper title --->
  <div class="col-10">
    <img src="{{ site.baseurl }}/images/banners/banner_scrdesign.png" style="width:100%;">
  </div>
  <!--- Altmetric --->
  <div class="col-2">
    <div data-badge-details="right" data-badge-type="donut" data-doi="10.1101/2020.04.16.045740" class="altmetric-embed"></div>
  </div>
</div>

<br>

<!--- Summary --->
## Summary

<br>

<div class="row content-row">
<div class="col-12 col-sm-5 image-wrapper">
      <img src="{{ site.baseurl }}/images/Designs.jpg" alt="Basic (2sigma) SCR design">
</div>
<div class="col-12 col-sm-7">
  <h1 style="font-size:1.5vw;">
    <p>Spatial capture-recapture (SCR) has emerged as the industry standard to estimate animal density. The precision of such estimates is dependent fundamentally on the sampling design, but despite this knowledge, SCR design remains poorly understood.</p>  
   </h1>
</div>
</div>
<hr>

<br>

<div class="row content-row">
<div class="col-12 col-sm-5 image-wrapper">
      <img src="https://pbs.twimg.com/media/EV74eRaXkAAgf_K?format=jpg&name=4096x4096" alt="Figure 1: Optimal designs tested">
</div>
<div class="col-12 col-sm-7">
  <h1 style="font-size:1.5vw;">
    <p>Motivation: In reality, landscapes are logistically challenging to sample, and pre-existing design heuristics don't easily apply.</p>
    <p>Solution: We propose a genetic algorithm to optimize any sensible, criteria-based objective function to produce near-optimal sampling designs.</p>  
   </h1>
</div>
</div>
<hr>

<br>

<div class="row content-row">
<div class="col-12 col-sm-5 image-wrapper">
        <img src="https://pbs.twimg.com/media/EV75VOdXsAA51Z_?format=jpg&name=4096x4096" alt="Figure 2: Design generation code">
</div>
<div class="col-12 col-sm-7">
   <h1 style="font-size:20px;">
     <p>Our approach, implemented in <a href="https://github.com/jaroyle/oSCR">oSCR</a>, explicitly incorporates information about a species of interest & logistic constraints, bringing clarity & flexibility to decision-making for SCR design generation.</p>  
  </h1>
</div>
</div>
<hr>

<br>

<div class="row content-row">
<div class="col-12 col-sm-5 image-wrapper">
        <img src="https://pbs.twimg.com/media/EV75P5hXsAAJeQB?format=jpg&name=4096x4096" alt="Figure 3: Examples of tested landscapes">
</div>
<div class="col-12 col-sm-7">
  <h1 style="font-size:20px;">
    <p>We generated ‘optimal’ designs using the algorithm and evaluated them, via simulation, across a set of realistic constraints, including variation in: effort, study area shape, and density pattern.</p>  
  </h1>
</div>
</div>
<hr>

<br>

<div class="row content-row">
<div class="col-12 col-sm-5 image-wrapper">
        <img src="https://pbs.twimg.com/media/EV75ZhqXkAAzKG8?format=jpg&name=4096x4096" alt="Figure 4: Simulation results">
</div>
<div class="col-12 col-sm-7">
  <h1 style="font-size:20px;">
    <p>Bottom line: our designs perform as well as existing recommendations, but with far more flexibility to be applied in any landscape, and further, they appear robust to spatial variation in density.</p> 
    <p>We hope that by developing this tool and making it freely available and easy to use, SCR studies will be better designed, allowing researchers, practitioners, and managers to make the most of their resources, and in turn, improve their monitoring efforts!</p>
  </h1>
</div>
</div>
<hr>

<br>

<div class="content-row row">
<div class="col-12 col-sm-7">
  <h1 style="font-size:20px;">
    <p>Download the paper from <a href="https://www.biorxiv.org/content/10.1101/2020.04.16.045740v1">bioRxiv</a>, and defintely check out the discussion on Twitter!</p>
  </h1>
</div>
<div class="col-12 col-sm-5">
  <blockquote class="twitter-tweet"><p lang="en" dir="ltr">Our preprint on <a href="https://twitter.com/hashtag/scrdesign?src=hash&amp;ref_src=twsrc%5Etfw">#scrdesign</a> is live! [a thread, 1/n]<br><br>&quot;Towards optimal sampling design for spatial capture-recapture&quot; <br>Myself, Andy Royle (<a href="https://twitter.com/andyroyle_pwrc?ref_src=twsrc%5Etfw">@andyroyle_pwrc</a>), Ali Nawaz, &amp; Chris Sutherland (<a href="https://twitter.com/chrissuthy?ref_src=twsrc%5Etfw">@chrissuthy</a>), with support from <a href="https://twitter.com/snowleopards?ref_src=twsrc%5Etfw">@snowleopards</a>, <a href="https://twitter.com/PantheraCats?ref_src=twsrc%5Etfw">@PantheraCats</a> <a href="https://t.co/ouxUECODWa">https://t.co/ouxUECODWa</a></p>&mdash; Gates Dupont (@gatesdupont) <a href="https://twitter.com/gatesdupont/status/1251870793346285573?ref_src=twsrc%5Etfw">April 19, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>
</div>


