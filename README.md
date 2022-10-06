# IDAnalysisTool

The main goal of this tool is to be easy to use and to provide enough information about the insertion devices at the Advanced Light Source to be able to compare their performance before and after the ALS-U upgrade. That said, it the results should be general enough for other uses as well. 

All calculations are based on the equations in the 'Orange Book', http://xdb.lbl.gov.

There are other tools around that provide more accurate results, for example:


## Installation

1. cd into Documents/Wavemetrics/Igor Pro 8 User Files/User Procedures (on a Mac, probably somehwere similar on Windows)
1. Download the directories Misc and IDAnalysis, either
  * by directly downloading the directories, or
  * type 'git clone https://github.com/paglans/IDAnalysisTool.git'
1. Start Igor
1. Go to File -> Open File -> Procedure...
1. Navigate to the directory in the first point above, go into IDAnalysis, and open IDAnalysis.ipf
1. Compile
1. On the Igor Pro command line, type 'CreateIDAnalysis()', hit enter.

## Usage

By following the steps above, there should now be a panel running titled IDAnalysis. Suggested order of operations:
1. Click 'New System'
1. Enter a name
1. If you want prefilled values: select your inserstion device from the popup menu to the right of the new system button.
1. Edit any values you'd want to be different from default. For example, run the ring at 2.0 GeV instead or 1.9 GeV, or adjust the Photon energy to reach a desired B-field.
1. Click either Plot brightness or Plot flux. Or both. :-) Harmonics 1, 3, 5, and 7 are plotted by default.
1. Changing, for example, the Photon energy at this point will modify the graph in question in real time.
1. At this point, you are in 'Igor land' and can use standard Igor commands to modify the graphs to your liking.

