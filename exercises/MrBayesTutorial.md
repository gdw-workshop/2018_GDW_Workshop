Genomics of Disease in Wildlife Mr. Bayes Tutorial
==================================================

## What is MrBayes?

MrBayes is a command-line driven software package for Bayesian estimation of phylogenetic trees and evolution parameters that can be downloaded, installed, and run from personal computers or servers.  


## Ok.  Lets begin!

First…about today’s dataset:

This file is an alignment of two subtypes of retrovirus sequences (puma lentivirus A and puma lentivirus B) from bobcats (Lynx rufus) and mountain lions (Puma concolor) from three geographic locations in the US…California, Colorado, and Florida.  Each entry in the alignment represents one viral sequence from a single individual and is named according to the following nomenclature…viral subtype (A vs. B), host species (Lru vs Pco), arbitrary animal ID, date of sample collection (you’ll need to refer back to this information at the end).

I’ve selected a short, informative region of the genome for this exercise (rather than the full viral genomes) in order to shorten the amount of time it takes to run the file in Mr. Bayes.  However, the same process can work with any length of alignment assuming the alignment is accurate, and that you have enough computational power (and patience) to run larger datasets.

Typical questions that could be asked with this type of dataset using todays analysis include: 

Are viral genotypes (phylogenetic clustering) correlated to host species?
Is there evidence of cross-species transmission of PLVA?  …of PLVB?
Are the viral populations geographically structured?  …temporally structured?


## Let’s start with the computer work.  

Download the all of the files from the following folder and place them in the GDW_Data

https://drive.google.com/drive/folders/1T5N3vGdl8YYiLSFsm8vxrxph0JRhCEgy?usp=sharing

Open a terminal window and cd to GDW_Data.

```

# start Mr. Bayes

> mb
```

If Mr. Bayes started properly you should now see some information about the version of Mr. Bayes you are using and that the prompt has changed.
```
# load today’s dataset (note: there are two very similar .nex files so please use this one first)

MrBayes > execute PLVAB_aln_mb.nex 
```

You should now see some summary information about the dataset.
```

# view the help menu to see all of the parameter groups that are available to customize for analyses.  

MrBayes > help
```

The list may seem a bit overwhelming but in reality only a few parameters need to be modified for a basic analysis.  In the parameter list, the commands used to modify each parameter are on the left, while the options for that parameter are in the middle column, and the current setting for each parameter is listed in the right collumn.  More information about many of the parameters can be obtained by typing (for example) *help lset*.
```

MrBayes > help lset

# You should see something that looks like this:


Default model settings:                                                       
                                                                                 
   Parameter    Options                               Current Setting            
   ------------------------------------------------------------------            
   Nucmodel     4by4/Doublet/Codon/Protein            4by4                         
   Nst          1/2/6/Mixed                           1                         
   Code         Universal/Vertmt/Mycoplasma/                                     
                Yeast/Ciliates/Metmt                  Universal                         
   Ploidy       Haploid/Diploid/Zlinked               Diploid                         
   Rates        Equal/Gamma/LNorm/Propinv/                                       
                Invgamma/Adgamma                      Equal                         
   Ngammacat    <number>                              4                         
   Nbetacat     <number>                              5                         
   Omegavar     Equal/Ny98/M3                         Equal                         
   Covarion     No/Yes                                No                         
   Coding       All/Variable/Noabsencesites/                                     
                Nopresencesites                       All                         
   Parsmodel    No/Yes                                No                         
   ------------------------------------------------------------------    
```
For today’s tutorial we will modify a few parameters of the likelihood and nucleotide parameters (using *lset*) and some of the parameters that set how the sampling should be performed during the MCMC run (using *mcmcp*).  All parameters are modified using the same pattern that is described below.

```
MrBayes > lset nucmodel=codon nst=6 rates=invgamma
```

### Q1: What parameters did we just modify, what did we change them to, and why would we choose these values?

```
# Now you check to see that your current list of parameters priors match what you entered:

MrBayes > help lset

Default model settings:                                                       
                                                                                 
   Parameter    Options                               Current Setting            
   ------------------------------------------------------------------            
   Nucmodel     4by4/Doublet/Codon/Protein            Codon                         
   Nst          1/2/6/Mixed                           6                         
   Code         Universal/Vertmt/Mycoplasma/                                     
                Yeast/Ciliates/Metmt                  Universal                         
   Ploidy       Haploid/Diploid/Zlinked               Diploid                         
   Rates        Equal/Gamma/LNorm/Propinv/                                       
                Invgamma/Adgamma                      Invgamma                         
   Ngammacat    <number>                              4                         
   Nbetacat     <number>                              5                         
   Omegavar     Equal/Ny98/M3                         Equal                         
   Covarion     No/Yes                                No                         
   Coding       All/Variable/Noabsencesites/                                     
                Nopresencesites                       All                         
   Parsmodel    No/Yes                                No                         
   ------------------------------------------------------------------    
```

Now let’s look at the MCMC paramaeters…

```
# view MCMC parameters
MrBayes > help mcmcp
```

I’d like to make mention of a few of the parameters listed to help explain how Mr. Bayes works.  Nchains is the number of MCMC chains that are sampling the parameter space throughout the run.  The default of 4 chains means that 4 separate MCMC instances are occurring simultaneously for each run.  Each chain stars from a different random starting tree and samples different parameter values (such as tree topology, branch lengths, substitution rates, etc.) at each step and navigates the parameter space by moving toward values that increase the likelihood of the data given the sampled parameter values.  

### Q2: Why are multiple chains used to sample the parameter space during an analysis in Mr. Bayes?

The *mcmcp* command is used to modify the mcmc parameters prior to starting the run. 

```
# View default mcmc parameter settings

MrBayes > help mcmcp

# change some parameters for today’s analysis

MrBayes > mcmcp ngen=20000 samplefreq=200 diagnfreq=500 burninfrac=0.20
```

Here, we have changed the number of steps in the MCMC chain to 20,000, will be sampling every 200 steps in the chain, and will be comparing the similarity/difference of the tree samples between the two runs every 500 steps in the chain.  We also set the burn-in period equal to 20% of the total samples collected.  

### Q3: What the hell is *burn-in*?

Ok.  Now lets check to see that all of the parameters we wanted to change were indeed set to the values we wanted.

```
MrBayes > help mcmcp
```
If everything looks good we can start the run with the mcmc command…

```
MrBayes > mcmc 
```
During the run, you will see updated output printed to the terminal depending on the frequency requested (*mcmc printfreq* command was left at default here but can be changed).  The current state of the chain (# of the most recent sampled step) is listed in the first column.  The next 8 columns are the log likelihood values for each sampled state for each of the 4 chains…with an asterisk separating the chains for each of the two independent runs.  The values listed in square brackets correspond to the cold chain, while the parentheses are used for the hot chains.  If the hot and cold chains are efficiently, you should see that the position of the cold chain moves throughout the run.  If the cold chain gets stuck in one position too long you can either extend the length of the run (increase the number of steps in the MCMC chain), or lower the temperature difference between chains (using the *mcmcp temp* command) to increase the efficiency with which the swapping between cold and hot chains occur.

After every n=diagnfreq generations, *Average deviation of split frequencies:* will print to the terminal.  This value is generated by comparing the similarity of the tree samples between the two independent runs and is an indication of whether or not the chains are converging on the similar posterior estimates.  The lower the number gets, the better the two runs are converging on the same tree estimates.   According to the Mr. Bayes manual, values below 0.05 indicate *adequate* convergence for many analyses, while values below 0.01 indicate *very good* convergence.

Ok.  Let Mr. Bayes run.  The run will continue until n=ngen steps has been reached or until the average deviation of split frequencies is equal to *stopval*…one of the mcmcp parameters.

Given the short time we have for this tutorial today I’ve got files for you to work with for the remainder of the tutorial that are from this same dataset but were run ngen=1,000,000 steps.



## Open another terminal tab or window.  

Load the following file into Mr. Bayes: PLVAB_aln_mb_2.nex. (Can you remember how to do this?)

Now we will summarize the sampled parameter from the two independent runs in order to generate estimated values that fit our data.

```
# summarize sampled parameters

MrBayes > sump

# summarize sampled trees

MrBayes > sumt
```

Now there should be a file with the original input file name with the extension *con.tre*, which is the consensus phylogenetic tree that contains credibility values (posterior support statistic for nodes/branch points), and branch lengths (in units of substitutions per site).

Open FigTree, another program in the GDW_Apps directory and use File>Open to select the *con.tre* file.

In the menu on the left go to *Node Labels* and select *prob* under the *Display* to view the support values for each node.  

Q4: What does *prob* stand for here and why is this important in how trees like this are interpreted?

Here’s the list of questions I mentioned earlier that could be answered by an approach like what you just did in this exercise…what would be your answer to these questions based on the tree you just produced?

Are viral genotypes (phylogenetic clustering) correlated to host species?
Is there evidence of cross-species transmission of PLVA?  …of PLVB?
Are the viral populations geographically structured?  …temporally structured?






## Brief answers to the above questions…

A1: We just set the primary data-type of our alignment to *codon* (vs. protein or non-coding nucleotides), set the nucleotide substitution model to the general-time reversible model (*nst=6*), and we allowed the rate of substitutions to vary according to a gamma distribution with some invariable sites (*invgamma*).  

A2: Take a look at the following fictionalized parameter space where the x- and y-axes are combinations of parameter values and the z-axis is the likelihood of the nucleotide alignment given the values.  In this example, there are n=3 separate chains sampling the parameter space.

![alt text](https://github.com/gdw-workshop/2018_GDW_Workshop/blob/master/likelihoodlandscape2.png "likelihood landscape")

Having multiple chains simultaneously sampling the parameter space makes it more likely that the absolute maximum likelihood (highest hill on the landscape) will be found.  This is accomplished by two mechanisms.  First, more of the parameter space can be sampled since 4 chains starting from 4 different *locations* are moving independently across the space.  Second, it allows chains to *swap* from one position on the landscape to another if the latter is in an area of higher likelihood.  This allows chains stuck on a local optimum (i.e. the green chain above) to explore other areas on the landscape by *jumping* the valleys between different hills.

A3: At the start of each MCMC analysis, individual posterior parameter estimates are more dependent on the starting location (which if you recall is random!) than on what is most likely based on the alignment, model of substitution, etc.  However, as the length of the chain grows, the posterior parameter estimates become more and more accurate in reflecting the *true* values.  Therefore, the when using Bayesian MCMC approach to estimate phylogenetic trees and their associated parameters, the early samples are called *burn-in* and are discarded from downstream analyses.

A4:  *prob* (or sometimes ‘post prob’) stands for *posterior probability* which is the support value assigned to branch points/nodes on Bayesian trees.  In short, this can be thought of as the fraction of the sampled trees (after discarding burnin) that contain that given branch point.  This value is analogous to the *bootstrap* value from Maximum Likelihood or Neighbor-Joining tree building methods.  Higher values indicate stronger support for a given branch point and for the ordering of tips into groups on either side of that node.  
