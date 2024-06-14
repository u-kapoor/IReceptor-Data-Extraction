# Loading all of the necessary libraries
f = "setup.R"; for (i in 1:10) { if (file.exists(f)) break else f = paste0("../", f) }; source(f)
suppressMessages(library(data.table))
                                
# Initial directories
                                
filepath = "C:/Users/..." # Set to a folder with all of the extracted zip files from IReceptor.com
outDir = "C:/Users/..." # Set to the desired output csv folder
sequence_freq_limit = 5 # Set to desired frequency cutoff, default is 5
filelist = list.files(path=filepath)
gc()

# Extract data from each file zip

for (i in 1:length(filelist)) {
    setwd(filepath)
    start = Sys.time() # Tracking the time to pull and aggregate dataset
    file = filelist[i]
    data = fread(cmd = paste0('unzip -cq ',file), select = c('sequence'))
    aggregated = data %>% group_by(sequence) %>% summarize(count=n())
    aggregated = subset(aggregated, count >= sequence_freq_limit)
    aggregated = arrange(aggregated, desc(count))
    setwd(outDir)
    write.csv(aggregated, paste0(gsub('.zip','',file),'.csv'), row.names=FALSE)
    end = Sys.time()
    print(paste0('The file ', filelist[i], ' took: ', end - start, ' seconds'))
    }
