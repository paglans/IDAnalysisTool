# IDAnalysisTool

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
1. Click either Plot brightness or Plot flux. Or both. :-)
