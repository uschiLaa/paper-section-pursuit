# Reponse to review

We thank the AE and referees for the thorough review of our paper. Following the
suggestions, we have made major changes to the structure, reduced dependency on
our previous work in Laa, Cook, Valencia 2019, and extended the discussion to
clarify the limitations of the method. Below we summarize the two reviews and
detail how each point has been addressed in the revision.

### Reviewer 1:

**Required revisions:**

- **make the manuscript less dependent on the Laa, Cook, Valencia 2019, include
  sketch:**
  + we have extended the introduction of slicing and added diagrams adapted from
    Laa, Cook, Valencia 2019.
- **binning is not fully clear, sketch would help:**
  + We have reworked the discussion of the binning (also including suggestions
    made by reviewer 2). For better understanding of the radial binning we have
    added a new diagram. We have also added a summary paragraph that details the
    relationg between slicing, projecting and binning.
- **indices vs indexes**
  + Indexes is the common term that is used in projection pursuit literature, actually when Cook, Buja and Cabrera (1993) "Projection Pursuit Indexes Based on Orthonormal Function Expansions" JCGS, tried to use indices the copy editor insisted the correct term was indexes.
- **line section 3.2 on indices: index equality is a non-sequitur. Please motivate why this is of interest.**
  + We have rephrased the statement to point out why this is important. (If the equality is not given, we should pick the appropriate index definition.)
- **The thickness of the slice h in the parameter gets dropped from the indices.**
  + Yes, the index depends on h, epsilon, but for simplicity of notation its better to leave these as properties of A.
- **Index definition structure, alternative index definitions, e.g. log-ratio**
  + We have streamlined the index definition section and moved the discussion of
    alternatives to the conclusions and discussion section of the paper. We have
    slightly extended the discussion, including a reference to log-ratios as
    suggested by the referee. An implementation and comparison of these methods
    is however beyond the scope of this work.
- **Figure 3: add legend**
  + The numbers for each bin are not interesting here, and its just a distraction to add a legend. The main point of the figure is read from the relative shade of the various bins. 
- **Equation 8: add example with numbers**
  + We have added some explicit values at the end of the subsection. Note that
    this is now Equation 11 (N_S). 
- **Generalised index section needs to be reworked**
  + We have changed the structure and reworked the discussion to avoid repetition.
    The text from the 'additional considerations' subsection has been reworked and
    was moved to the discussion.
- **Fig 4, 5, 6: add text in axis labels**
  + To avoid cluttering the plots we have extended the caption to provide text
    names for the variables for easier understanding of what are now Figures 6-8.
- **index in practice: How many observations were excluded from the olive-oil data? Show that in the scatterplots of the projected data**
  + We do not remove any observations from the olive-oil data itself, but points are dropped
    from the large set of points that fill up the full parameter space to evaluate the model
    predictions. First, we only want to sample points inside the hypersphere, and second we
    filter points based on the predicted group to generate holes in this data that are then
    identified via the section pursuit algorithm.
- **more on data generation**
  + We have added an appendix that details how the data of Set A and B were simulated.

### Reviewer 2:

- **Structure:**
  + We have reworked the structure of the paper, such that the definition
    of the index is now covered in Section 3, and all practical aspects that rely
    on an assumed underlying distribution are now discussed in Section 4. We decided
    that generalising the discussion towards any underlying distribution would
    be distracting in this work but might be interesting enough to be covered in
    a future article. 

- **Re notation:**
  + We have corrected the description of A as a basis for the 
    projected space rather than a projection matrix
  + We now use capital F to denote a CDF
  + We prefer keeping R instead of using rho because it is easier to read, given
    that p, which looks like rho, also appears in the same equation.
  + We decided that adding hats would make the notation more difficult to read, and really isn't necessary for a reader to grasp the ideas. 
  + We have clarified the usage of the terms slice and section and added diagrams to help with intuition, see Section "Grand tour and slice tour". You're right in the sense that using orthogonal distance makes the slices shell-like. But slice is the better description for the task being tackled, and the appearance of points inside the slice in the slice tour looks like the object has been sliced.
  + We already use symbols S and C to indicate points inside and outside the slice.
  
- **Rotation invariance and trimming**
  + the reason that rotation invariance is
    important here is that we need to make assumptions about how the section
    is expected to differ from the slice, which is used in defining their
    separate weights (Eq. 9). We have clarified this in the paper. 
  
- **Spherical trimming costs and benefits**
  + The referee is correct that the effect of shaving is radical, in
    particular when starting from a full hypercube in high dimensions. Note
    however that it is not as drastic as it might seem. We have added more justification in the paper.
    
- **Radial binning**
  + We agree that the radial binning is interesting in general, and have somewhat generalized its introduction. A fully general discussion, as sketched by the referee, is beyond the scope of this paper. It is a good idea for, perhaps, a separate article and if the reviewer was interested in collaborating on making the idea more general and extensible, we could be convinced to work on it.
    
- **Equation 8 needs to be derived (p11 of the review)**
  + This was derived in the slice tour paper and is an exact result, not using
    any of the approximations considered by the referee. We now reproduce this
    derivation in the appendix.
  
- **NS for olive oil data (p12 of review)**
  + Indeed the number of data points within a thin slice is negligible, and the slice display is not useful for the visualisation of this data itself. Instead, the slice display and section pursuit are used to understand the decision boundaries of a classification model. Since this is visualised as the classification of samples across the parameter space, the original number of points can be controlled by the user and was adjusted to obtain a feasible number of points inside the slice.
  
- **Description of reweighting is not clear**
  + This has been rewritten to avoid misunderstandings.
  
- **Epsilon threshold radial dependence (p15)**
  + We thank the referee for noticing the issue. Indeed the delta and epsilon
    depend on the radial boundaries of the bin, but we had dropped the index in
    the notation. The implementation was however correct, and we have now
    added the i index in the equations and updated the description to point out
    this radial dependence.
  
- **Generalised index as separate section (p16)**
  + Within the new structure of Sections 3 and 4 it makes sense to keep the
    generalised index as part of Section 3, while discussing the epsilon
    threshold together with other practical aspects in Section 4.
    
- **Application section (p17)**
  + We have moved the PDFSense application to the appendix, but decided to
    keep the 2HDM application in the main text, as supported by Referee 1.
    
#### Minor details (p18)
- **Definition of S1 and S2 unclear**
  + Indeed theses are defined via two different projection planes, we now state
    this explicitly in the text and adapted the wording to specify that the
    planes are *centered* at the origin.
    
- **Data generation of sets A and B**
  + The details explaining the data generation have been added as an appendix.
  
- **Critique of "needles in a haystack"**
  + (There was a similar comment from Reviewer 1.) Yes, you are right, and we have re-written the text to de-emphasize use of the term. We have used it once, because it is related to high-density and we think help gets that message across. 

- **Figure 5, maybe also 2, 4: make it easier to distinguish lines by making them thicker and maybe using different linetypes**
  + We have increased the line thickness in these Figures (now 4, 6, 8) and also use different linetypes in the case of smooth functions (Figs 4 and 8).
  
- **Radius vs thickness**
  + We have replaced thickness by radius when referring to h, since indeed 2h would be considered the thickness and h the radius.