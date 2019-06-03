

LAB BEAST part 2 – Confirming whether a molecular clock can be reliably estimated
=================================================================================
The shapes of phylogenetic trees reflect biological processes occurring on wide-ranging timescales, from as little as few weeks in rapidly evolving microbes to millions of years for macroevolutionary processes such as speciation. Regardless of the scale, being able to calibrate trees (i.e. to put a time-scale on them) and to date key events is an important part of understanding the dynamical processes that gave rise to the phylogenetic patterns we observe. Central to this idea of tree calibration and dating is the concept of a *molecular clock*: the stochastic but regular accumulation of nucleotide substitutions through time. Where these substitutions are accumulating fast enough to be picked up within sampling intervals, such populations are referred to as measurably evolving (Drummond et al. 2003) and molecular clocks can be directly estimated from genetic sequence data. 

Many disease-causing organisms, especially RNA viruses but also bacteria and some DNA viruses, have been shown to be measurably evolving (Biek et al, 2015). However, how do you know that this holds true for a given pathogen genomic data set? ####Before we are attempting to estimate a molecular clock from our data using BEAST, we should confirm that the data contain sufficient signal to do so. #### The BEAST output in TRACER does not generally give us reliable indication in that respect: the program will always attempt to fit a molecular clock if we asked it to do so and will produce an estimate whether or not there is a genuine signal of measurable evolution in the data. 


Testing for a molecular clock signal using TempEst

A standard way to check for ‘clock-like’ evolution in your data is to check whether there is an accumulation of substitutions over time, i.e. whether tree tips corresponding to samples collected later in time are more genetically divergent from the tree root (which represents the most recent common ancestor, mrca) than tips with earlier dates. What we need to test for such a pattern is a phylogenetic tree with dated tips. Importantly, this tree needs to have branches measured in genetic distance, not time, so it can’t be a tree estimated using a method already assuming a molecular clock (like BEAST). For this exercise, we will be looking at data set of genomes for the bacterial pathogen Borrelia burgdorferi, the agent of Lyme disease. 

You are provided with a Maximum Likelihood (ML) tree based on 23 B. burgdorferi s.s. genomes (main chromosome only, excluding data for the plasmids).  These samples were collected from a single site in Scotland during two time points, 1997 and 2013, so sixteen years apart. Because sampling was done at the same location both times, we can expect these isolates to be highly related. The key question is whether the isolates sampled at the later date are more genetically divergent from the root compared to the earlier isolates. In other words, whether we see in an increase in root-to-tip divergence over time, consistent with a molecular clock. 

The program we’ll use to test for a clock-like in the tree is called TempEst (Rambaut et al. 2016) and has been written by some of the same people who developed BEAST. Open the program and import the ML tree of the Borrelia genomes (“Bbss_SubTree.nwk”). In the ‘Sample Dates’ tab you will see the names of the 23 isolates containing the year of sampling at the end. Similar to setting up a BEAST analysis in BEAUti, we need to extract the date information from the names using the ‘Guess Dates’ option. The dates are the last part of the name and the prefix is an underscore so specify this before hitting OK. Make sure the dates look correct in the Date column. Click the ‘Tree’ tab to take a look at the tree and then the ‘Root-to-tip’ tab to examine the pattern. 

What would your conclusion be at this point – do you see evidence for measurable evolution and a molecular clock?

It is worth considering what the root of the tree is that we are using as the reference point for calculating the root-to-tip divergence. TempEst expects a rooted tree and will use whatever root position it is provided with in the imported tree. In the current case, the tree had been previously rooted using an outgroup (other B burgdorferi s.s. genomes that fell outside of our clade of 23 genomes and that were subsequently removed). However, it is possible that we got the estimation of the root position wrong and that alternative root nodes should be considered. Clicking the ‘best-fitting root’ option on the top left provides a way to do this based on a range of criteria such as maximising the R2 of the correlation (all options produce the same outcome for our data but this is not always the case). 

What would you conclude from the current plot? Can you give a first approximation of the molecular clock rate and the date of the most recent common ancestor?

It is worth emphasising that the purpose of TempEst is not to estimate the molecular clock rate – you would still do this properly in program BEAST. But it gives a useful indication whether there is any clock-like signal in your sequence data, how much variation there is, and which sequences may be behaving very differently from the rest. If you don’t see a positive relationship between sampling date and genetic divergence at this stage, trying to estimate a clock rate in BEAST is probably not valid. 


Examining the reliability of the molecular clock estimate obtained in BEAST

To save time, you won’t be asked to set up a BEAST analysis of the Borrelia data set and are instead provided with the log files of a finished run. Import the log file (“Bbss_chr_ucln.const.log”) into TRACER and examine the results for the clock rate. The analysis was done using a relaxed molecular clock model (Drummond et al. 2007)  and the parameter to look for is called ‘mean rate’. 

How fast is B. burgdorferi evolving according to these results?


As mentioned previously, BEAST will always attempt to estimate a clock rate. So how confident can we be that this rate estimate is really based on information contained in our data and not a spurious result? The most common way to assess this, is to test whether similar rate estimates could have been obtained from the same data if the date information was not informative. Randomising the dates of the sequences should achieve exactly that and is therefore a standard way to examine the reliability of the estimated clock rate. If we repeat the analysis with multiple data sets in which dates have been randomised and obtain values that are not overlapping with the original rate estimate, we can be confident that the originally estimated rate is a genuine product of our data and that it is statistically supported.

You are provided with the results from five such replicates with randomised dates (created with an R package called TipDatingBeast, which makes generating the alternative input files quick and easy, ). These log files are called ‘Bbss_chr_ucln.const.rep1.log’, ‘…rep2.log’, etc. Add them to the original log file in Tracer and examine the mean rate parameter. By highlighting all six files at the same time you can compare their highest posterior densities, which reflects the level of uncertainty around the mean parameter estimate. I would recommend using the ‘Marginal Density’ tab on the right for a visual comparison. 

What do you conclude from these results regarding the clock rate of B burgdorferi? Does the original rate estimate look distinct from its counterparts with randomised dates?

The methods outlined here are generally applicable to any pathogen genomic data set (or subgenomic data). While most RNA viruses can be expected to be measurable evolving, especially if full genomes can be used, this is not always the case. Processes such as recombination for example can impact the relationship between sampling time and root-to-tip divergence in spurious ways. For double-stranded DNA viruses, Firth et al () demonstrated that only some of the available genomic data sets exhibited measurable evolution. 

Some general rules and recommendations:

•	You should always assess the data for clock-like behaviour in TempEst before setting up a BEAST analysis. Even if the majority of the data exhibit the expected positive correlation, visual inspection is a good way to identify outliers. Such outliers might be attributable to errors in the data (such as a wrong date) or other processes (e.g. recombination). These outliers should be dealt with, either by correcting the data (where it is possible) or by removing them (if this can be justified). 

•	If the data look well behaved in TempEst, it should be fine to move ahead with a molecular clock analysis in BEAST. If they are not, or if the expected positive correlation can only be achieved under certain assumptions (e.g. best fitting root options), the BEAST analysis should be approached with caution. Confirming that the clock rate obtained is robust using the randomised date procedure or related techniques (Rieux and Khatchikian 2017) might be a good idea.

•	If the data don’t appear to contain sufficient temporal signal, several options could be considered. Expanding the time span of sampling for example (i.e. maximising the number of years between the oldest and most recent sample) might allow to reveal an increase in divergence over time, even if the data are generally noisy or the pathogen is evolving very slowly. Alternatively, more reliable clock rates might be available from previous studies of the same or related organisms and could be included as prior information in BEAST to guide the temporal calibration. 



References

Biek, R., Pybus, O. G., Lloyd-Smith, J. O., & Didelot, X. (2015). Measurably evolving pathogens in the genomic era. Trends in Ecology & Evolution, 30(6), 306–313. http://doi.org/10.1016/j.tree.2015.03.009
Drummond, A. J., Pybus, O. G., & Rambaut, A., Forsberg, R and A G Rodrigo (2003). Measurably evolving populations. Trends in Ecology & Evolution Vol.18 No.9, 481-488. http://doi.org/10.1016/S0169-5347(03)00216-7
Drummond, A. J., Ho, S. Y. W., Phillips, M. J., & Rambaut, A. (2006). Relaxed phylogenetics and dating with confidence. PLoS Biology, 4(5), 699–710. http://doi.org/10.1371/journal.pbio.0040088

Rambaut, Lam, de Carvalho & Pybus (2016). Exploring the temporal structure of heterochronous sequences using TempEst. Virus Evolution 2: vew007. http://dx.doi.org/10.1093/ve/vew007

Rieux, Adrien, and Camilo E. Khatchikian. (2017). "TipDatingBeast: An R package to assist the implementation of phylogenetic tip‐dating tests using BEAST." Molecular Ecology Resources 17, no. 4: 608-613. http://doi.org/10.1111/1755-0998.12603

