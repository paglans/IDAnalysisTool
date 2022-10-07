# IDAnalysisTool

The main goal of this tool is to be easy to use and to provide enough information about the insertion devices at the Advanced Light Source to be able to compare their performance before and after the ALS-U upgrade. That said, it the results should be general enough for other uses as well. 

All calculations are based on the equations in the 'Orange Book', http://xdb.lbl.gov.

There are other tools around that provide more accurate results, for example:

* Full install of SPECTRA, code + web: https://spectrax.org/spectra/
* Full version of SRW: https://github.com/ochubar/SRW
* Online version of SRW: https://www.sirepo.com/light#/home

## Installation

1. cd into Documents/Wavemetrics/Igor Pro 8 User Files/User Procedures (on a Mac, probably somehwere similar on Windows)
   * The code seems to run under Igor 7, but the panel looks ugly since 7 does not know about latex.
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
1. The Flux and Brightness data are in the Fn and Bn waves, respectively. They are 2D waves with the first harmonic in column 0, third harmonic in column 1, fifth harmonic in column 2, and the 7th harmonic in column 3. To add the third harmonic to an existing graph, use AddToGraph Fn[][1] vs energies[][1]. I believe this has to be done from the command line -- the menu options will not pick up the waves correctly.

## Suggested work flow

1. First create a system for 1.9 GeV. Tweak the photon energy until either the K value or the B-field corresponds to the desired value. 
1. Add a second system and set the storage ring energy to 2.0 GeV. Tweak the photon energy until either the K value or the B-field corresponds to the value suggested by ALS-U.
** If a calculation for a different polarization is desired, tweak the photon energy until the B-field is 80% (CP), or 70% (LV) of the B-field for horizontal polarization. 
** Unless measured data is available, then aim for those values.
1. Be aware that the tabulated values in most places are for the ID hard stop, which is at a smaller gap (larger B and K) than the minimum operational gap. Example, for the the BL 6.0.1 IVID: current B max = 1.033 T and K max = 2.878, at the hard stop. The *operational* B = 0.952 T and K = 2.67. 
