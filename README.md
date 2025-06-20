# Pubchem_Compound.sh
 Script to retrieve compound from the pubchem database

## Usage
```bash
/path/to/folder/pubchem_compound.sh "Compound Name"
```
Or
```bash
/path/to/folder/pubchem_compound.sh "Compound CID"
```

***Add "csv" after first argument to diplay outpus in csv format.***

### Installation

From Master
  ```bash
  curl -sSL https://raw.githubusercontent.com/tmiland/Pubchem_Compound.sh/refs/heads/main/pubchem_compound.sh > pubchem_compound.sh && \
  chmod +x pubchem_compound.sh
  ```

Or clone the project

```bash
git clone https://github.com/tmiland/Pubchem_Compound.sh.git && \
cd Pubchem_Compound.sh && \
chmod +x pubchem_compound.sh
```

### Symlink
```bash
ln -sfn ~/path/to/folder/pubchem_compound.sh ~/.local/bin/pubchem_compound
```

### Example output
```bash
./pubchem_compound.sh "2519"
```
```bash
Name: Caffeine

CID: 2519

Molecular Weight: 194.19

Molecular Formula: C8H10N4O2

SMILES: CN1C=NC2=C1C(=O)N(C(=O)N2C)C

Description: Caffeine stimulates the central nervous system (CNS), heightening alertness, and sometimes causing restlessness and agitation. It relaxes smooth muscle, stimulates the contraction of cardiac muscle, and enhances athletic performance. Caffeine promotes gastric acid secretion and increases gastrointestinal motility. It is often combined in products with analgesics and ergot alkaloids, relieving the symptoms of migraine and other types of headaches. Finally, caffeine acts as a mild diuretic.

Information: Caffeine is indicated for the short term treatment of apnea of prematurity in infants and off label for the prevention and treatment of bronchopulmonary dysplasia caused by premature birth. In addition, it is indicated in combination with sodium benzoate to treat respiratory depression resulting from an overdose with CNS depressant drugs. Caffeine has a broad range of over the counter uses, and is found in energy supplements, athletic enhancement products, pain relief products, as well as cosmetic products.

Link: https://pubchem.ncbi.nlm.nih.gov/compound/Caffeine
```
Or csv
```bash
./pubchem_compound.sh "2519" csv
```
```bash

Name,CID,Molecular Weight,Molecular Formula,SMILES,Description,Information,Link
Caffeine,2519,194.19,C8H10N4O2,CN1C=NC2=C1C(=O)N(C(=O)N2C)C,Caffeine stimulates the central nervous system (CNS), heightening alertness, and sometimes causing restlessness and agitation. It relaxes smooth muscle, stimulates the contraction of cardiac muscle, and enhances athletic performance. Caffeine promotes gastric acid secretion and increases gastrointestinal motility. It is often combined in products with analgesics and ergot alkaloids, relieving the symptoms of migraine and other types of headaches. Finally, caffeine acts as a mild diuretic.,Caffeine is indicated for the short term treatment of apnea of prematurity in infants and off label for the prevention and treatment of bronchopulmonary dysplasia caused by premature birth. In addition, it is indicated in combination with sodium benzoate to treat respiratory depression resulting from an overdose with CNS depressant drugs. Caffeine has a broad range of over the counter uses, and is found in energy supplements, athletic enhancement products, pain relief products, as well as cosmetic products.,https://pubchem.ncbi.nlm.nih.gov/compound/Caffeine
```

#### Credits

- [pubchem.ncbi.nlm.nih.gov](https://pubchem.ncbi.nlm.nih.gov)

#### Donations
<a href="https://coindrop.to/tmiland" target="_blank"><img src="https://coindrop.to/embed-button.png" style="border-radius: 10px; height: 57px !important;width: 229px !important;" alt="Coindrop.to me"></img></a>

#### Disclaimer 

*** ***Use at own risk*** ***

### License

[![MIT License Image](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/MIT_logo.svg/220px-MIT_logo.svg.png)](https://github.com/tmiland/Pubchem_Compound.sh/blob/main/LICENSE)

[MIT License](https://github.com/tmiland/Pubchem_Compound.sh/blob/main/LICENSE)
