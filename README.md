# Positron's GearSwap scripts

*Please do not message me about addons in-game. I usally hang out on the BG Wiki Discord, which you can find a link to on the sidebar of [the wiki's main page](https://www.bg-wiki.com/ffxi/Main_Page). Contact me there with any questions.*

These scripts are a constant work in progress and any changes may render previous versions of scripts in this repo incompatible. However, the following will generally be true:
* All jobs require the `all`, `common`, and `func` directories to be present to work correctly
* Job-specific logic is found in `[Character]_[JOB].lua`.
* Job-specific gear sets are found in `[job]`.
* No job is depedent on files in another job's directory. If you only want to use certain jobs' files, other jobs' directories can be ignored.
* A job's own directory contains only gear sets, no logic. This means it's safe to override sets by adding new sets directly to the logic file, though it is strongly discouraged.

Aside from GearSwap itself, these scripts have soft dependencies on the following additional addons:
* DressUp: used for setting blinking modes.
* PorterPacker: used for packing and unpacking gear on load and on job change. [gimlic1's forked version](https://github.com/gimlic1/Windower-addons/tree/master/PorterPacker) is recommended as it works in Sheol: Gaol.
* Enternity: used to prevent the race condition in PorterPacker that can otherwise fail to unpack the correct gear.

None of these addons are strictly required to get the basic GearSwap functionality. However, if you choose not to use them, I highly recommend setting `console_displayactivity 0` in your Windower init script to avoid a flood of console errors.