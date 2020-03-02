# How to add entries to the data folder

This folder contains all entries in the database. Within each subfolder there are three files containing time series data (`timeSeries.csv`), site level data (`initConditions.csv`), and the metadata (`metadata.yaml`) for each incubation study. The metadata file has the extension `.yaml`, while the time series and site level data are stored in comma separated format with the extension `.csv`. The name of each subfolder follows the convention: `AuthornameYEARJournalAbbrv`.

## The metadata file
The metadata file is simply a text file that includes all relevant information about the incubation study. The yaml format is both human and machine readable, so it is very easy to write all relevant information about a study in these files. You can inspect the available entries for examples on how to write yaml metadata files.

Each file must contain the following basic information:

```yaml
citationKey: # Unique identifier in the format: LastnameYearJOURNAL (journal may be abbreviated)
doi:  # DOI of the publication where data is published
entryAuthor: # First and last name of the person who entered the data in this file
entryCreationDate: # Date when the data was entered in this file. Format: YYYY-MM-DD
contactName:  # First and last name of contact person (may be the principal investigator supervising the entryAuthor)
contactEmail: # Email of the contact person
entryNote: # Any notes or comments related to this entry.
study:  # Overall study description
```

In the `yaml` format, each separate field has a name followed by : and a value. The `citationKey` field is simply an ID to cite or identify the name of each entry. It has the same convention as the name of the folder for each particular entry. The `doi` field is the digital object identifier for the publication where the data was originally obtained. This doi can be used to automatically retrieve information from other databases such as Mendeley. The `entryAuthor` field is the name of the person who created the entry. `entryCreationDate` is the date at which the entry was created and uploaded in the database. This date follows the convention YYYY-MM-DD.

In `yaml` it is possible to create hierarchies with different type of information. This is very useful to store diverse fields related to the research sites where the soils were sampled for the incubation. For each metadata file, it is required to include a `siteInfo` field as follows

```yaml
siteInfo:
        site: # Names of individual sites, if one site, keep on this line, if multiple, use array format
# These fields should be arrays of equal length to site array
        coordinates:
          latitude: # Latitude in decimal units (check for negative that denotes southern hemisphere)
          longitude: # Longitude in decimal units (check for negative that denotes western hemisphere)
        country: # Name of country where site was conducted
        MAT: # Mean annual temperature in degrees Celsius
        MAP: # Mean annual precipitation in mm
        elevation: # Elevation of study site in meters above sea level
        landCover: # Land cover of the site. Valid fields are: bare, cultivated, forest, rangeland/grassland, shrubland, urban, wetland, tundra
        vegNote: # Additional details about land cover such as species or functional type composition
        soilTaxonomy:
          soilOrder: # Soil order according to the classification system described below
          soilFamily: # Soil family description (ex. 'Eutric' for a Eutric Cambisol)
          soilSeries: # Soil series according to the classification system described below
          classificationSystem: # Name of classification system used. Valid fields are: USDA, FAO, and WRB.
        permafrost:
          permafrostExist: # Yes or blank if no (if yes, permafrost must exist at the site)
          activeLayer: # Depth of the active layer in meters
```

Notice that there is an indentation pattern in this example. Indentation is used by `yaml` to create subfields within a field. So, `studySite` is a subfield of `siteInfo`, and `latitude` is a subfield of `coordinates`.

Another important field that must be added is the `incubationInfo`

```yaml
incubationInfo:
        incDesc: # Short description of the incubation setup and main treatments
# These fields should all be one dimensional arrays. Values for experimental variables with multiple treatment levels should be entered in the variables section and left blank here
        depthInfo: # Soil depth in cm. If only one depth listed instead of range, enter as midDepth. By default 0 is defined as organic/mineral interface. If reported otherwise enter "yes" under the surfaceAtm field. If multiple depths analyzed leave blank and specify depths in variables section.
          top:
          bottom:
          midDepth:
          surfaceAtm: # blank if zero is organic/mineral interface, yes if zero is atmospheric interface
          horizon: # soil horizon designation
        temperature: # Temperature at which incubations were performed in Celsius. If temperature is an experimental treatment with multiple levels leave blank and specify in variables section
        # Use 'moisture' as a template for any additional treatments imposed. For example, if amendments were added for a priming experiment, the treatmentName 'moisture' would be replaced with 'amendment', 'value' could be set to 'glucose' (or whatever amendment was added), and 'units' could be set to 'mgC/g soilC'.
        moisture: # Moisture conditions at which incubations were performed.
          value: # If moisture is an experimental treatment with multiple levels leave blank and specify in variables section
          units: # Valid fields are: percentGWC, percentFieldCapacity, percentWaterFilledPoreSpace
        anaerobic: # Yes if headspace flushed with N2 or He, blank if aerobic
        gasMeasured: # Blank if CO2, Other valid entries are: CH4, N2O, 13CO2, 14CO2, 13CH4, etc. Leave blank if multiple gases measured and specify in variables section
        replicates:
          value: # Number of replicates per treatment
          type: # Valid fields are: field or lab
        incubationTime: # length of incubation in days
        preincubationTime: # Pre-incubation time in days
        samplePreparation:
          intactCore: # yes or no
          sieving: # no, or mesh size in mm
          rootPicking: # yes or no
          rockPicking: # yes or no
        gasAnalyzer: # Gas analysis equipment used
```

The `incubationInfo` field has a subfield with a description `desc` on how the incubations were carry out. This is very important information to document details about the incubation experiment.

Critical experimental conditions such as temperature and moisture are reported here, as are any additional treatments imposed, e.g. amendments for priming experiments, anaerobic conditions (`anaerobic`), etc. Other key subfields of the `incubationInfo` field include `samplePreparation` and `preincubationTime` for documenting handling of the samples prior to the main incubation experiment, and the `depthInfo` subfield for reporting the sampling depth from which soils were collected.

Use the `moisture` subfield as a template for any additional incubation treatments imposed. Replace `moisture` with the name of the treatment (in camelCase if multiple words), specify the value of the treatment imposed under the `value` subfield, and enter the units corresponding to the treatment value under `units`. For example, if a priming experiment was conducted with added amendments, `moisture` could be replaced by `amendment`, and the specific amendment would be listed in the `value` field (e.g. glucose, cellulose, etc.), while the units of the amendment would be specified under `units`, e.g. mg amendment C/g soilC.

If any of the incubation treatments imposed have multiple levels, e.g. different temperatures, moisture levels, amendments, etc., the treatment levels (e.g. `value`s) need to be specified explicitly in the `variables` field (described below) in order for the treatments to be linked to the correct data in the time series file (`timeSeries.csv`). Note that the main subheading for additional treatments with multiple treatment levels should still be listed (e.g. list `amendment` if multiple amendments were added) and the treatment `units` specified, but as with multiple `moisture` levels, the `value` field will be left blank.

The last field that must be added is the `variables`. This field contains, in order of appearance, the variables in the `timeSeries.csv` file.

```yaml
variables: # These describe the columns of your timeSeries.csv file
        V1: # column 1
          name: # Name of first variable in the accompanying timeSeries.csv data file. The first variable must always be time.
          units: # Time units used in accompanying file. Usually "d" for days
        V2: # column 2
          name: # Name of second variable in accompanying file
          varDesc: # Description of the variable
          site: # Site where the incubated sample was collected
          experimentalTreatment: # 'experimentalTreatment' here is a place holder for treatments with multiple levels. Replace this word by any of the listed variables in incubationInfo above (temperature, moisture, etc.) and type treatment value (level) after colon. Note that units should be specified in the incubationInfo field above.
          gasMeasured: # Blank if CO2, Other valid fields are: CH4, N2O, 13CO2, 14CO2, 13CH4, etc
          units: # Units for 'gasMeasured' field
          statistic: # Leave blank if mean values. Other valid fields include: SD, SE, and none (if a single rep)
          primaryVariableName: # Links variable with associated time series data collected on the same sample e.g. SD data or 13C-CO2 data associated with mean CO2 data. Leave blank if there are no associated variables
```

The number of variables `V1`, `V2`, etc. in this field must correspond to the number of columns in the associated `timeSeries.csv` file.

## Time series data
The `timeSeries.csv` file for each entry in the database contains the time series of incubation data in a comma separated values format. The first column of the data file must contain the times at which CO<sub>2</sub> measurements were made. Subsequent columns contain the respiration (or associated) measurements. Note that in order to link the correct time series data to the correct `variable` it is essential that the `name` subfields of the `variables` field match the column names of the associated `timeSeries.csv` file exactly.

## Initial conditions
Additional data on the site conditions where the soil samples were collected can be given in the `initConditions.csv` file.
