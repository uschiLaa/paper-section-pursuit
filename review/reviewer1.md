Reviewer: 1

Comments to the Author
<p>The paper “Hole or grain? A Section Pursuit Index for Finding Hidden Structure in Multiple Dimensions” discusses an approach to apply a novel form of section projection pursuit to high dimensional data for finding density anomalies close to the center of the data.</p>
<p>This is an interesting and intriguing idea with obvious use cases. The application of the slice-section tour to the two-Higgs-doublet model might be my favorite example in a long time.</p>
<p>There are a few items that should be addressed before a publication:</p>
<p>Required revisions</p>
<ul>
<li>make the manuscript less dependent on the Laa, Cook, Valencia 2019 manuscript. The definition of slices has to stand on its own. Given that the slices are a fundamtentally important part of this manuscript, their definition should not be just stuffed into the notation section of 3.1.</li>
<li>A sketch of the slices and the binning (maybe of the settings that turn out to be working well in practice?) would help with making the notation more palatable. Even after re-reading the paper several times I am not sure about whether the binning is cylindrical or spherical in nature. Binning is initially only defined on the projected observations - but clearly is used in a form expanded to the orthogonal space, because otherwise no inside and outside slice counts can be defined.</li>
<li>it’s indices not indexes</li>
<li>last line section 3.2 on indices: index equality is a non-sequitur. Please motivate why this is of interest.</li>
<li>The thickness of the slice h in the parameter gets dropped from the indices - but there’s a clear dependence on it as seen in the list of practical aspects to consider in section 5.1. This should be discussed earlier in more detail.</li>
<li>There’s a lot of different ways on how an index to test for differences in densities between inside and outside slides would work. For example, a log ratio should also work similarly, and might have nicer (more statistical) properties than the difference. Provide more motivation for the form of the index besides the Gous and Buja paper. The decision to use Gous and Buja first and a generalized form later makes the section a bit awkward. The flow would be better when the generalized form is used right away (with more discussion and motivation).</li>
<li>Figure 3: the color shadings for the figures are nice and work intuitively, but actual numbers in a legend would help with establishing an intuition for the range of the index</li>
<li>Equation 8 is nice, but stays very abstract - could we get an example with numbers?</li>
<li>Generalized index - this section needs some work. On the one hand it feels somewhat repetitive - deriving the noise a second time in 3.6.3 for the special case of q=1 seems like exactly the same as the discussion in 3.5. The additional considerations of 3.6.1. regarding a kernel would go better in an overall discussion. The kernel density comes out of nowhere and doesn’t seem to go anywhere either.</li>
<li>Adding text in axis labels besides the notation would be helpful in understanding this rather notation heavy paper (e.g. figs 4, 5, 6).</li>
<li>index in practice: visualizing an indication for hyperspherical data in the examples would be beneficial to assess the effect of this constraint in practice. How many observations were excluded from the olive-oil data? Show that in the scatterplots of the projected data</li>
<li>expand discussion of the data generation of sets A and B in the paper. The datasets also ony show holes - an example on how a grain would show up would be also interesting. Unless of course, the focus of the paper is indeed on holes (as the examples suggest), in which case the introduction and the title might have to be adjusted somewhat.</li>
</ul>
