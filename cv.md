---
title: Curriculum Vitae
layout: default
use_fontawesome: true
---

# test dynamic hiding 2
<div class="container">
    <div class="row">
        <div class="d-none d-md-block col-md-6 col-lg-6 col-xl-6" style="margin-bottom: 10%;"> <!-- desktop: hide on screens smaller than md) -->
            <iframe src="https://docs.google.com/gview?url=gatesdupont.github.io/attachments/DupontCV.pdf&embedded=true" style="width:100%; height:100%;" frameborder="0">
            </iframe>
        </div>
        <div class="d-sm-none col-12" style="margin-bottom: 10%;"> <!--  mobile: hide on screens larger than sm -->
            <iframe src="https://docs.google.com/gview?url=gatesdupont.github.io/attachments/DupontCV.pdf&embedded=true" style="width:100%; height:100%;" frameborder="0">
            </iframe>
        </div>
        <div class="col-12 col-sm-0 col-md-6 col-lg-6 col-xl-6" style="margin-bottom: 10%;">
            <img width="100%" height="100%" src="{{ site.baseurl }}/images/alaska.jpeg">
        </div>
    </div>
</div>
