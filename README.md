[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/hernanmd/badges/CIMatrix)](https://img.shields.io/github/workflow/status/hernanmd/badges/CIMatrix)
[![GitHub repo size](https://img.shields.io/github/repo-size/hernanmd/badges)](https://img.shields.io/github/repo-size/hernanmd/badges)
[![GitHub Repo stars](https://img.shields.io/github/stars/hernanmd/badges?style=social)](https://img.shields.io/github/stars/hernanmd/badges?style=social)

# Table of Contents

- [Demo](#demo)
- [Features](#features)
- [Installation](#installation)
  - [Baseline String](#baseline-string)
- [Usage](#usage)
- [Contribute](#contribute)
  - [Version management](#version-management)
- [License](#license)

# Demo

![badges](https://user-images.githubusercontent.com/4825959/185053552-9a8b1124-2ad2-442c-ab18-f749630e4a4a.gif)

# Features

- Select the badges you like, complete the required variables, and get your badge(s).
- Save and load commonly used variables.
- Preview both Markdown and resulting PNG.
- View all your saved badge variables.

# Installation

```smalltalk
EpMonitor disableDuring: [ 
	Metacello new	
		baseline: 'Badges';	
		onWarningLog;
		repository: 'github://hernanmd/badges/src';	
		load ].
```

## Baseline String 

If you want to add the Badges to your Metacello Baselines or Configurations, copy and paste the following expression:

```smalltalk
	" ... "
	spec
		baseline: 'Badges' 
		with: [ spec repository: 'github://hernanmd/badges/src' ];
	" ... "
```

# Contribute

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

If you have discovered a bug or have a feature suggestion, feel free to create an issue on Github.
If you have any suggestions for how this package could be improved, please get in touch or suggest an improvement using the GitHub issues page.
If you'd like to make some changes yourself, see the following:    

  - Fork this repository to your own GitHub account and then clone it to your local device
  - Do some modifications
  - Test.
  - Add <your GitHub username> to add yourself as author below.
  - Finally, submit a pull request with your changes!
  - This project follows the [all-contributors specification](https://github.com/kentcdodds/all-contributors). Contributions of any kind are welcome!

## Version management 

This project use semantic versioning to define the releases. This means that each stable release of the project will be assigned a version number of the form `vX.Y.Z`. 

- **X** defines the major version number
- **Y** defines the minor version number 
- **Z** defines the patch version number

When a release contains only bug fixes, the patch number increases. When the release contains new features that are backward compatible, the minor version increases. When the release contains breaking changes, the major version increases. 

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

# License
	
This software is licensed under the MIT License.

Copyright Hernán Morales Durand, 2022.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Authors

Hernán Morales Durand
