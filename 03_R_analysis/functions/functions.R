# ==============================================================================

# FUNCTIONS USED IN THE GENETIC ANALYSIS PRACTICAL @ THE UNIVERSITY OF HULL

# ==============================================================================

# iNEXT_plot: plot sample accumulation estimates
# created specifically for the data generated for this practical
# runs iNEXT on correctly structured data and creates a plot

# this is designed specifically with the students in mind
# few 2nd year students are expected to deal with base R in this manner
# it removes the (terrifying) complexity of data manipulation in base R
# and delivers the plot required

iNEXT_plot = function(df, colours){
  
  # transpose the data for use in iNEXT:
  df = as.data.frame(t(df))
  
  # set the limb namess:
  limbs = c('left leg', 'right leg', 'left arm', 'right arm')
  
  # subset the data by limb:
  l_leg = df[grep('LL', colnames(df))]
  r_leg = df[grep('LR', colnames(df))]
  l_arm = df[grep('AL', colnames(df))]
  r_arm = df[grep('AR', colnames(df))]
  
  # deal with missing colours variable:
  if(missing(colours)) {
    colours = c('red', 'gold', 'green', 'lightblue')
    names(colours) = limbs
  } else {
    colours = colours}
  
  # make a list of data frames per limb to feed into iNEX:
  body_parts = list(l_leg, r_leg, l_arm, r_arm)
  # add names to list for dictionary indexing:
  names(body_parts) = limbs
  
  # create the iNext object for the data:
  iNEXT_object = iNEXT(body_parts,
                       q = 0, datatype = 'incidence_raw',
                       endpoint = 40,
                       knots = 80)
  
  # set the y min and max of the plot:
  y_levels = c()
  
  # loop through iNEXT object data by limb:
  for(limb in names(body_parts)){
    # extracting estimates 1:10 for the limb:
    inext_subset = iNEXT_object$iNextEst[[limb]][38:48,]
    # add max and min values for estimated OTUs per limb from the iNEXT object:
    y_levels = c(y_levels, min(inext_subset$qD), max(inext_subset$qD))
  }
  y_max = max(y_levels)
  y_min = min(y_levels)
  
  # make the empty plot with only axis labels:
  plot(1, 1, cex = 0,
       ylim = c(y_min, y_max),
       xlim = c(1, 10),
       las = 1,
       ylab = 'OTUs detected',
       xlab = 'Samples',
       axes = F,
       cex.lab = 1.2)
  
  # add axes and box border:
  axis(1, at = c(0:10), lwd = 0, lwd.ticks = 1)
  axis(2, las = 1, lwd = 0, lwd.ticks = 1)
  
  box()
  
  # make list for percentage total estimated OTUs detected per limb @ 3 samples
  limb_perc = c()
  
  # loop through iNEXT object data by limb:
  for(limb in names(body_parts)){
    # extracting estimates 1:10 for the limb:
    inext_subset = iNEXT_object$iNextEst[[limb]][38:48,]
    # plot lines with colours:
    lines(inext_subset$t, inext_subset$qD, col = colours[limb])
    # calculate percentage total estimated OTUs to 2dp:
    limb_text = round(inext_subset[3,]$qD/inext_subset[10,]$qD * 100, 2)
    # make it a string for legend:
    limb_text = paste(limb, ' (', limb_text, '%)', sep = '')
    # add string to list for percentage total estimated OTUs
    limb_perc = c(limb_perc, limb_text)
  }
  
  # add vertical dashed line at 3 samples:
  abline(v = 3, lty = 2)
  
  # include legend with line colours and percentage of OTUs detected:
  legend('bottomright', bty = 'n', legend = limb_perc, col = colours, lty = 1)
}


