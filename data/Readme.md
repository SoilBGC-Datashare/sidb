# How to add entries to the data folder

This folder contains both data and metadata. There is one folder for each incubation study, which contains a `yaml` file with metadata, and the data is stored in a comma separated file `csv`. The name of each folder is follows the following convention: `AuthornameYEARJournalAbbrv`.

## The metadata file
The metadata file is simply a text file that includes all relevant information about the incubation study. The yaml format is both human and machine readable, so it is very easy to write all relevant information about a study in these files. You can inspect the available entries for examples on how to write yaml metadata files.

Each file must contain the following basic information:

```yaml
citationKey: Smith2017SBB
doi: 10.1016/2017.03.025.2
entryAuthor: John Stewart
entryCreationDate: 2014-02-19
```

In the `yaml` format, each separate field has a name followed by : and a value. The `citationKey` field is simply an ID to cite or identify the name of each entry. It has the same convention as the name of the folder for each particular entry. The `doi` field is the digital object identifier for the publication where the data was originally obtained. This doi can be used to automatically retrieve information for other databases such as Mendeley. The `entryAuthor` field is the name of the person who created the entry. `entryCreationDate` is the data at which the entry was created and uploaded in the database. This date follows the convention YYYY-MM-DD.

In `yaml` it is possible to create hierarchies with different type of information. This is very useful to store diverse fields related to the research sites where the soils were sampled for the incubation. For each metadata file, it is required to include a `siteInfo` field as follows

```yaml
siteInfo:
    studySite: central Piedmont region of North Carolina, USA
    ecosystemType: forest
    climate: temperate
    soilType: Alfisol
    texture: mixed clay mineralogy
    coordinates:
         latitude: 36.6166667
         longitude: -79.150
```

Notice that there is an indentation pattern in this example. Indentation is used by `yaml` to create subfields within a field. So, `studySite` is a subfield of `siteInfo`, and `latitude` is a subfield of `coordinates`. You can create subfields for any field in case you need to add additional information such as different study sites with different climates. More subfields can be added to the `siteInfo` subfield as necessary.

Another important field that must be added is the `incubationInfo`

```yaml
incubationInfo:
    desc: "Soils were incubated at three different temperatures: 4, 22, and 40 degrees celcius as well as ambient and elevated CO2"
    treatments:
        - temperature
        - moisture
        - CO2
    incubationTime:
        time: 48
        units: days
```

In this example, the `incubationInfo` field has a subfield with a description `desc` on how the incubations were carry out. This is very important information to document details about the incubation experiment. It also includes the subfield `treatments` that lists the different variables that were modified by the treatments. Notice that each treatment is preceded by a `-`, which indicates that each element corresponds to a list.

The last field that must be added is the `variables`. This field contains, in order of appearance, the variables in the `.csv` file that is included in the same folder with the incubation data.

```yaml
variables:
        V1:
          name: time
          units: days
        V2:
          name: T1
          temperature: 4
          moisture: 30
          CO2: 400
          units: "mg CO$_2$ g^{-1} soil day^{-1}"
          desc: "CO2 production rate measured at 4 degrees celsius, 30 % vwc, and 400 ppm"
        V3:
          name: T2
          temperature: 22
          moisture: 10
          CO2: 800
          units: "mg CO$_2$ g^{-1} soil day^{-1}"
          desc: "CO2 production rate measured at 22 degrees celsius, 10 % vwc, and 800 ppm"
```

The number of variables `V` in this field must correspond to the number of variables in the `.csv` file. 
