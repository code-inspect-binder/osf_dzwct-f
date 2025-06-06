# Executable Environment for OSF Project [dzwct](https://osf.io/dzwct/)

This repository was automatically generated as part of a project to test the reproducibility of open science projects hosted on the Open Science Framework (OSF).

**Project Title:** Impact of emotion laden acoustic stimuli on group synchronisation performance (data repository and codes)

**Project Description:**
> Ability to synchronise with other people is a core socio-motor competence acquired during human development. In this study we aimed to understand the impact of individual emotional arousal on joint action performance. We asked 15 mixed-gender groups (of 4 individuals each) to participate in a digital, four-way synchronisation task. Participants shared the same physical space, but could not see each other during the task. Few seconds into each trial run, every participant was induced with emotionally laden acoustic stimulus (pre-selected from the second version of International Affective Digitized Sounds). Our data demonstrated that the human ability to synchronise is overall robust to fluctuations in individual emotional arousal, but performance varies in quality and movement speed as a result of valence of emotional induction (both on the individual and group level). We found that the accumulation of negatively-valenced emotional inductions in a trial led to a drop in overall group synchronisation performance (measured as median and standard deviation of order parameter). We report that negatively-valenced induction led to slower performance, whilst positive induction afforded higher pace of performance. On the individual level of synchronisation performance we found an effect of empathetic disposition (higher competence linked to better performance especially during the negative induction condition) and of participant's sex (males being able to reach higher synchronisation bands). We believe this work is a blueprint for exploring the frontiers of inextricably bound worlds of emotion and joint action, be it physical or digital.

**Original OSF Page:** [https://osf.io/dzwct/](https://osf.io/dzwct/)

---

**Important Note:** The contents of the `dzwct_src` folder were cloned from the OSF project on **12-03-2025**. Any changes made to the original OSF project after this date will not be reflected in this repository.

The `DESCRIPTION` file was automatically added to make this project Binder-ready. For more information on how R-based OSF projects are containerized, please refer to the `osf-to-binder` GitHub repository: [https://github.com/Code-Inspect/osf-to-binder](https://github.com/Code-Inspect/osf-to-binder)

## flowR Integration

This version of the repository has the **[flowR Addin](https://github.com/flowr-analysis/rstudio-addin-flowr)** preinstalled. flowR allows visual design and execution of data analysis workflows within RStudio, supporting better reproducibility and modular analysis pipelines.

To use flowR, open the project in RStudio and go to `Addins` > `flowR`.

## How to Launch:

**Launch in your Browser:**

🚀 **MyBinder:** [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/code-inspect-binder/osf_dzwct-f/HEAD?urlpath=rstudio)

   * This will launch the project in an interactive RStudio environment in your web browser.
   * Please note that Binder may take a few minutes to build the environment.

🚀 **NFDI JupyterHub:** [![NFDI](https://nfdi-jupyter.de/images/nfdi_badge.svg)](https://hub.nfdi-jupyter.de/r2d/gh/code-inspect-binder/osf_dzwct-f/HEAD?urlpath=rstudio)

   * This will launch the project in an interactive RStudio environment on the NFDI JupyterHub platform.

**Access Downloaded Data:**
The downloaded data from the OSF project is located in the `dzwct_src` folder.

## Run via Docker for Long-Term Reproducibility

In addition to launching this project using Binder or NFDI JupyterHub, you can reproduce the environment locally using Docker. This is especially useful for long-term access, offline use, or high-performance computing environments.

### Pull the Docker Image

```bash
docker pull meet261/repo2docker-dzwct-f:latest
```

### Launch RStudio Server

Run the container (with a name, e.g. `rstudio-dev`):
```bash
docker run -it --name rstudio-dev --platform linux/amd64 -p 8888:8787 --user root meet261/repo2docker-dzwct-f bash
```

Inside the container, start RStudio Server with no authentication:
```bash
/usr/lib/rstudio-server/bin/rserver --www-port 8787 --auth-none=1
```

Then, open your browser and go to: [http://localhost:8888](http://localhost:8888)

> **Note:** If you're running the container on a remote server (e.g., via SSH), replace `localhost` with your server's IP address.
> For example: `http://<your-server-ip>:8888`

## Looking for the Base Version?

For the original Binder-ready repository **without flowR**, visit:
[osf_dzwct](https://github.com/code-inspect-binder/osf_dzwct)

